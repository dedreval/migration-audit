pushd /DSS_TMP/AUDIT/diff_files/

cat orig_article_files | grep -v '9999-9999' | grep '\S' | grep -v 'pdf_first_page' | sort -T ../tmp > orig_article_files_sorted
cat copy_article_files | grep -v '9999-9999' | grep '\S' | sort -T ../tmp > copy_article_files_sorted

diff -w --speed-large-files orig_article_files_sorted copy_article_files_sorted | grep '<' | awk '{print $2}' > article_files_in_orig_not_in_copy 
diff -w --speed-large-files orig_article_files_sorted copy_article_files_sorted | grep '>' | awk '{print $2}' > article_files_in_copy_not_in_orig

popd
