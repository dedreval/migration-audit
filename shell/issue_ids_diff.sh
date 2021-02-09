curl http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/journals.xqy -s >  journals

rm /DSS_TMP/orig_issue_ids

while read j; do
  curl "http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/issues.xqy?journal=$j" -s >> /DSS_TMP/orig_issue_ids;
  echo -e "\n" >> /DSS_TMP/orig_issue_ids;
done <journals

sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD < issue_ids.sql > /DSS_TMP/copy_issue_ids

cd /DSS_TMP

cat orig_issue_ids | grep -v '9999-9999' | grep '\S' | sort | uniq > orig_issue_ids_sorted

cat copy_issue_ids | grep -v '9999-9999' | sort | uniq > copy_issue_ids_sorted

diff orig_issue_ids_sorted copy_issue_ids_sorted | grep '<' | awk '{print $2}' > iss_in_orig_not_in_copy 
