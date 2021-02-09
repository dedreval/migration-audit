xquery version "1.0-ml";

declare namespace wcr-meta = "http://ct.wiley.com/ns/cdts/wcr-metadata";

let $journal := xdmp:get-request-field('journal')
let $path := concat("/content/journals/",$journal,"/")
                                        
return xdmp:directory($path, "infinity")//wcr-meta:meta[wcr-meta:meta-type = 'issue']/wcr-meta:identifier/text()
