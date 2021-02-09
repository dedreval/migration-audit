rm /DSS_TMP/AUDIT/diff_files/*

curl http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/journals.xqy -s >  journals

while read j; do
  curl "http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/articlefiles.xqy?journal=$j" -s >> /DSS_TMP/AUDIT/diff_files/orig_article_files;
  echo -e "\n" >> /DSS_TMP/AUDIT/diff_files/orig_article_files;
done <journals

sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD < article_files.sql > /DSS_TMP/AUDIT/diff_files/copy_article_files

pushd /DSS_TMP/AUDIT/diff_files/

cat orig_article_files | grep -v '9999-9999' | grep '\S' | grep -v 'pdf_first_page' | sort -T ../tmp > orig_article_files_sorted
cat copy_article_files | grep -v '9999-9999' | grep '\S' | grep -v 'undefined' | grep -v 'pdf_first_page' | sort -T ../tmp > copy_article_files_sorted

comm -2 orig_article_files_sorted copy_article_files_sorted > article_files_in_orig_not_in_copy 
comm -1 orig_article_files_sorted copy_article_files_sorted > article_files_in_copy_not_in_orig

popd
