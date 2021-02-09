curl http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/journals.xqy -s >  journals

rm /DSS_TMP/orig_article_ids

while read j; do
  curl "http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/articles.xqy?journal=$j" -s >> /DSS_TMP/orig_article_ids
  echo -e "\n" >> /DSS_TMP/orig_article_ids
done <journals

sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD < article_ids.sql > /DSS_TMP/copy_article_ids

cd /DSS_TMP

cat orig_article_ids | grep '\S' | sort | uniq > orig_article_ids_sorted

cat copy_article_ids | grep '\S' | sort | uniq > copy_article_ids_sorted

diff orig_article_ids_sorted copy_article_ids_sorted | grep '<' | awk '{print $2}' > article_in_orig_not_in_copy 
