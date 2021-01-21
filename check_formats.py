
import requests as req

print ("CHECKING ARTICLES")

for id in [117,165,145,313,2231,354,2064,108,2014,2025,2099,317,2416,2215,2003,2016,2019,306,2171,2061,2054,2107,170,324,353,143,150]:
    resp = req.request(method='GET', url=f"http://aus-lndssapp-02.wiley.com:8080/resteasy/id/10.1111/joa.13387/format/{id}?fileDownload=true")
    print(id, resp.status_code)

print ("CHECKING ISSUES")

for id in [149,2069,2001,2015,2040,2078,169,2010,2018,2028,2045,2256,2089,190,2141,109,154,2011,2017,2022,141,2042,308,106,2062,2136,2137,349,2356,174,2008,2168,318,307,2087,325,319,144,164,2002,2009,2027,2038,2177,2007,2039,2055,118,1086,2004,2005,2013,2108,2316,2235,2098]:
    resp = req.request(method='GET', url=f"http://aus-lndssapp-02.wiley.com:8080/resteasy/id/10.1111/jpe.2019.56.issue-2/format/{id}?fileDownload=true")
    print(id, resp.status_code)

