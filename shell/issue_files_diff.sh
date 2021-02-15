curl http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/journals.xqy -s >  journals

rm /DSS_TMP/AUDIT/iss_files/*

echo $DIR

while read j; do
  curl "http://car-lndsmlep-02.wiley.com:9002/com/wiley/dss/issuefiles.xqy?journal=$j" -s >> /DSS_TMP/AUDIT/iss_files/orig_issue_files;
  echo -e "\n" >> /DSS_TMP/AUDIT/iss_files/orig_issue_files;
done <journals

sqlplus -S DSS/DSS@AUS-LNDSSDBP-03.WILEY.COM:1593/DSSPRD < issue_files.sql > /DSS_TMP/AUDIT/iss_files/copy_issue_files

pushd /DSS_TMP/AUDIT/iss_files

cat orig_issue_files | grep -v '9999-9999' | grep '\S' | grep -v 'null' | sort > orig_issue_files_sorted

cat copy_issue_files | grep -v '9999-9999' | grep '\S' | sort > copy_issue_files_sorted

diff orig_issue_files_sorted copy_issue_files_sorted | grep '<' > issue_files_in_orig_not_in_copy 

diff orig_issue_files_sorted copy_issue_files_sorted | grep '>' > issue_files_in_copy_not_in_orig 

cat issue_files_in_orig_not_in_copy

popd
