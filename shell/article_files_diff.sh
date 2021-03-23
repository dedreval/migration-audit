BASE_DIR=/DSS_TMP/AUDIT/art_files
TMP_DIR=/DSS_TMP/AUDIT/tmp
echo $BASE_DIR

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

[[ ! -d $TMP_DIR ]] && mkdir -p $TMP_DIR
rm -rf $TMP_DIR/*

[[ ! -d $BASE_DIR ]] && mkdir -p $BASE_DIR
rm -rf $BASE_DIR/*

curl http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/journals.xqy -s >  journals

while read j; do
  echo $j
  curl "http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/articlefiles.xqy?journal=$j" -s >> $BASE_DIR/orig_article_files_$j
  echo -e "\n" >> $BASE_DIR/orig_article_files_$j

  sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD > $BASE_DIR/copy_article_files_$j <<EOF
COLUMN id FORMAT a200
SET LINESIZE 200
SET PAGESIZE 0
select content_item_id || chr(9) || lower(part_type_code) || chr(9) || cip.id from Content_Item_Part cip, Content_Item ci, Product p where ci.id=cip.content_item_id and part_type_code != 'DOCUMENT' and ci.CONTENT_ITEM_TYPE_CODE='ARTICLE' and ci.PRODUCT_ID=p.id and p.IDENTIFIER='$j';
EXIT 
EOF
 
  pushd $BASE_DIR/
  cat orig_article_files_$j | grep -v '9999-9999' | grep '\S' | grep -v 'pdf_first_page' | sed  -E 's/^([^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^0-9]+)(0*)([^0]*.+\/.+)$/\1\3/g' | grep -v 'null' | grep -v '\.suppl' | sort -T $TMP_DIR > orig_article_files_sorted_$j
  cat copy_article_files_$j | grep -v '9999-9999' | grep '\S' | grep -v 'content_item_id' | grep -v 'undefined' | grep -v 'pdf_first_page' |  sed  -E 's/^([^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^\/]+\/[^0-9]+)(0*)([^0]*.+\/.+)$/\1\3/g' | sort -T $TMP_DIR > copy_article_files_sorted_$j
  diff orig_article_files_sorted_$j copy_article_files_sorted_$j | grep '< ' > article_files_in_orig_not_in_copy_$j
  diff orig_article_files_sorted_$j copy_article_files_sorted_$j | grep '> ' > article_files_in_copy_not_in_orig_$j
  cat article_files_in_orig_not_in_copy_$j >> missing
  cat article_files_in_copy_not_in_orig_$j >> extra
  popd
done < journals

