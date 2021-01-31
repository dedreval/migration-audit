sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD < article_ids.sql > /DSS_TMP/copy_art_ids
sqlplus -S cdts/cdts@CAR-LNDSSDBP-02.WILEY.COM:1593/DSSPROD < article_ids.sql > /DSS_TMP/orig_art_ids
