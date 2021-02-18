#rm -f /DSS_TMP/AUDIT/files/file_db_size

#sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD < files.sql > /DSS_TMP/AUDIT/files/file_db_size

#rm -f /DSS_TMP/AUDIT/files/file_fs_size

pushd /DSS_TMP/AUDIT/files/

#cat file_db_size | grep -v 'rows' | grep '\S' | sort -T ../tmp > file_db_size_sorted

cat file_db_size_sorted | awk '{split ($0, a, "\t"); print a[1]}' | xargs ls -ls | awk '{printf "\x27%s\x27\t%s\n", $10, $6}' | sort -T ../tmp >  file_fs_size;

popd 
