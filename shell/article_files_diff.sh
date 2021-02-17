rm -rf /DSS_TMP/AUDIT/diff_files/*

curl http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/journals.xqy -s >  journals

while read j; do
  echo $j;
  curl "http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/articlefiles.xqy?journal=$j" -s >> /DSS_TMP/AUDIT/diff_files/orig_article_files_$j;
  echo -e "\n" >> /DSS_TMP/AUDIT/diff_files/orig_article_files_$j;
  sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD @article_files.sql $j > /DSS_TMP/AUDIT/diff_files/copy_article_files_$j;
  pushd /DSS_TMP/AUDIT/diff_files/;
  cat orig_article_files_$j | grep -v '9999-9999' | grep '\S' | grep -v 'pdf_first_page' | sed  -E 's/^([^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^0-9]+)(0*)([^0]*.+\/.+)$/\1\3/g' | grep -v 'null' | grep -v '.suppl' | sort -T ../tmp > orig_article_files_sorted_$j;
  cat copy_article_files_$j | grep -v '9999-9999' | grep '\S' | grep -v 'content_item_id' | grep -v 'undefined' | grep -v 'pdf_first_page' |  sed  -E 's/^([^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^0-9]+)(0*)([^0]*.+\/.+)$/\1\3/g' | sort -T ../tmp > copy_article_files_sorted_$j;
  diff orig_article_files_sorted_$j copy_article_files_sorted_$j | grep '<' > article_files_in_orig_not_in_copy_$j;
  diff orig_article_files_sorted_$j copy_article_files_sorted_$j | grep '>' > article_files_in_copy_not_in_orig_$j;
  cat article_files_in_orig_not_in_copy_$j >> missing;
  cat article_files_in_copy_not_in_orig_$j >> extra;
  popd;
done <journals




