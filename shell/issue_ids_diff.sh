sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD < issue_ids.sql > /DSS_TMP/copy_issue_ids
sqlplus -S cdts/cdts@CAR-LNDSSDBP-02.WILEY.COM:1593/DSSPROD < issue_ids.sql > /DSS_TMP/orig_issue_ids
diff orig_issue_ids copy_issue_ids | grep '<' | awk '{print $2}' > iss_in_orig_not_in_copy 
