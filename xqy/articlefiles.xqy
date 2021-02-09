xquery version "1.0-ml";

declare namespace wcr-meta = "http://ct.wiley.com/ns/cdts/wcr-metadata";

let $journal := xdmp:get-request-field('journal')
let $path := concat("/content/journals/",$journal,"/")
let $tab := '&#9;'
                                        
for $article in xdmp:directory($path, "infinity")//wcr-meta:meta[wcr-meta:meta-type = 'article']
for $file in $article//wcr-meta:binary-file
return concat($article/wcr-meta:identifier, $tab, $file/@type, $tab, $file/wcr-meta:binary-uri/text())
