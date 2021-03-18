BASE_DIR=/DSS_TMP/AUDIT/iss_diff
echo $BASE_DIR

[[ ! -d $BASE_DIR ]] && mkdir -p $BASE_DIR

curl http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/journals.xqy -s >  journals

[[ -f $BASE_DIR/orig_issue_ids ]] && rm $BASE_DIR/orig_issue_ids

while read j; do
  curl "http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/issues.xqy?journal=$j" -s >> $BASE_DIR/orig_issue_ids;
  echo -e "\n" >> $BASE_DIR/orig_issue_ids;
done <journals

sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD  > $BASE_DIR/copy_issue_ids <<EOF 
COLUMN id FORMAT a80
SET LINESIZE 80
SET PAGESIZE 0
SELECT DISTINCT parent_id from Content_Item where content_item_type_code='ARTICLE' order by parent_id;  
EOF

pushd $BASE_DIR

cat orig_issue_ids | grep -v '9999-9999' | grep '\S' | sort | uniq > orig_issue_ids_sorted

cat copy_issue_ids | grep -v '9999-9999' | sort | uniq > copy_issue_ids_sorted

diff orig_issue_ids_sorted copy_issue_ids_sorted | grep '< ' | awk '{print $2}' > iss_in_orig_not_in_copy 

popd

