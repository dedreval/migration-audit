BASE_DIR=/DSS_TMP/AUDIT/art_diff
echo $BASE_DIR

[[ ! -d $BASE_DIR ]] && mkdir -p $BASE_DIR
rm $BASE_DIR/*

curl http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/journals.xqy -s >  journals

while read j; do
  curl "http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/articles.xqy?journal=$j" -s >> $BASE_DIR/orig_article_ids
  echo -e "\n" >> $BASE_DIR/orig_article_ids
done <journals

sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD > $BASE_DIR/copy_article_ids <<EOF
COLUMN id FORMAT a80
SET LINESIZE 80
SET PAGESIZE 0
SELECT id from Content_Item where content_item_type_code='ARTICLE' order by id;  

EOF

pushd $BASE_DIR

cat orig_article_ids | grep '\S' | sort | uniq > orig_article_ids_sorted

cat copy_article_ids | grep '\S' | sort | uniq > copy_article_ids_sorted

diff orig_article_ids_sorted copy_article_ids_sorted | grep '< ' | awk '{print $2}' > article_in_orig_not_in_copy 

popd