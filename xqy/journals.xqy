xquery version "1.0-ml";

declare namespace wcr-meta = "http://ct.wiley.com/ns/cdts/wcr-metadata";
(xdmp:directory("/content/journals/", "infinity")//wcr-meta:meta[wcr-meta:meta-type = 'journal']/wcr-meta:identifier/text())