import datetime
import requests as req
import xml.dom.minidom as md

prod_host = "dss.wiley.com"
pre_prod_host = "aus-lndssapp-02.wiley.com"

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
    print(1)
    for id in dom.getElementsByTagName('rest:id'):
        print(id)
        updates.append(id.firstChild.nodeValue)
        print(id.firstChild.nodeValue)
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
    orig_resp = req.request(method='GET', url=(article_metadata_url))
    orig_article_dom = md.parseString(resp.text)
    copied_article_metadata_url = f"http://{pre_prod_host}:8080/resteasy/id/{article}/metadata"
    copied_resp = req.request(method='GET', url=(article_metadata_url))
    copied_article_dom = md.parseString(resp.text)


def getWeeklyUpdates():
    weekago = datetime.datetime.now() - datetime.timedelta(days=7)    
    dayago = datetime.datetime.now() - datetime.timedelta(days=1)    
    now = datetime.datetime.now()
    for journal in getUpdatedItems(weekago, now, 'journals', 'journal'):
        for article in getUpdatedItems(weekago, now, journal, 'article'):
            checkArticle(article)

getWeeklyUpdates()