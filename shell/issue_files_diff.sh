BASE_DIR=/DSS_TMP/AUDIT/iss_files
echo $BASE_DIR

[[ ! -d $BASE_DIR ]] && mkdir -p $BASE_DIR
rm $BASE_DIR/*

curl http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/journals.xqy -s >  journals

while read j; do
  curl "http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/issuefiles.xqy?journal=$j" -s >> $BASE_DIR/orig_issue_files;
  echo -e "\n" >> $BASE_DIR/orig_issue_files;
done < journals

sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD > $BASE_DIR/copy_issue_files <<EOF
COLUMN id FORMAT a200
SET LINESIZE 200
SET PAGESIZE 0
select content_item_id || chr(9) || lower(part_type_code) || chr(9) || cip.id from Content_Item_Part cip, Content_Item ci where ci.id=cip.content_item_id and ci.CONTENT_ITEM_TYPE_CODE='ISSUE'; 

EOF

pushd $BASE_DIR

cat orig_issue_files | grep -v '9999-9999' | grep '\S' | grep -v 'null' | sort > orig_issue_files_sorted

cat copy_issue_files | grep -v '9999-9999' | grep '\S' | sort > copy_issue_files_sorted

diff orig_issue_files_sorted copy_issue_files_sorted | grep '< ' > issue_files_in_orig_not_in_copy 

diff orig_issue_files_sorted copy_issue_files_sorted | grep '> ' > issue_files_in_copy_not_in_orig 

cat issue_files_in_orig_not_in_copy | awk '{print $2}' | sort | uniq > issue_diff_ids

popd
