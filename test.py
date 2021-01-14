import datetime
import requests as req
import xml.dom.minidom as md

prod_host = "10.200.0.61"
pre_prod_host = "aus-lndssapp-02.wiley.com"

orig_report = open("orig", "w")
copied_report = open("copied", "w")

def getUpdates(begin, end, parent, type, offset):
    before = end.strftime("%Y%m%dT%H00")
    after = begin.strftime("%Y%m%dT%H00")
    updates = []
    page_url = f"http://{prod_host}:8080/resteasy/id/{parent}/lastupload?type={type}&size=1000&after={after}&before={before}&offset={offset}"
    print(page_url)
    resp = req.request(method='GET', url=(page_url))
    with open('list', 'wb+') as f:
        f.write(resp.content)
    dom = md.parse('list')
    for id in dom.getElementsByTagName('rest:identifier'):
        updates.append(id.firstChild.nodeValue)
    return updates

def getUpdatedItems(begin, end, parent, type):
    list = []
    offset = 0
    page = getUpdates(begin, end, parent, type, offset)
    while len(page) > 0:
        list.extend(page)
        offset += 1000
        page = getUpdates(begin, end, parent, type, offset)
    return list

def checkArticle(article):
    orig_article_metadata_url = f"http://{prod_host}:8080/resteasy/id/{article}/metadata"
    orig_resp = req.request(method='GET', url=(orig_article_metadata_url))
    copied_article_metadata_url = f"http://{pre_prod_host}:8080/resteasy/id/{article}/metadata"
    copied_resp = req.request(method='GET', url=(copied_article_metadata_url))

    if (orig_resp.status_code == 200 and copied_resp.status_code == 200):
        orig_report.write(getArticleData(article, orig_resp.text))
        copied_report.write(getArticleData(article, copied_resp.text))
    else:
        print(article, 'ORIG', orig_resp.status_code, 'COPY', copied_resp.status_code)

def getArticleData(article, xmlStr):
    try:
        xml = md.parseString(xmlStr)
        files = []
        for file in xml.getElementsByTagName('binary-file'):
            if (file.getAttribute('type') != 'pdf_first_page'):
                files.append(article + '\t' + file.getAttribute('type') + '\t' + file.getElementsByTagName('binary-uri')[0].firstChild.nodeValue + '\n')
        files.sort()
        return ''.join(files)
    except:            
        print(article, xmlStr)
        return(article + 'FAIL \n')
        
def getWeeklyUpdates():
    started = datetime.datetime.now()
    weekago = datetime.datetime.now() - datetime.timedelta(days=707)
    dayago = datetime.datetime.now() - datetime.timedelta(days=701)
    twomonthago = datetime.datetime.now() - datetime.timedelta(days=60)
    monthago = datetime.datetime.now() - datetime.timedelta(days=30)
    now = datetime.datetime.now() - datetime.timedelta(days=0)
    for article in getUpdatedItems(twomonthago, monthago, 'journals', 'article'):
        print (article)
        checkArticle(article)
    orig_report.close()    
    copied_report.close()
    print(started, datetime.datetime.now())

getWeeklyUpdates()

