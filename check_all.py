import cx_Oracle
import datetime


orig_report = open("orig_all_content_item", "w", encoding="utf-8")
copy_report = open("copyed_all_content_item", "w", encoding="utf-8")

# sql = """SELECT id, content_item_status_code, to_char(last_upload_date, 'yyyy-mm-dd'), to_char(published_date, 'yyyy-mm-dd')
#          FROM Content_Item
#          WHERE 1=1
#          AND last_upload_date > SYSDATE-1
#          AND last_upload_date < SYSDATE-0
#          AND content_item_type_code IN ('ARTICLE')
#          ORDER BY id desc"""

sql = """SELECT id, content_item_status_code, to_char(last_upload_date, 'yyyy-mm-dd'), to_char(published_date, 'yyyy-mm-dd')
         FROM Content_Item
         WHERE content_item_type_code = 'ARTICLE'
         ORDER BY id desc"""

         
counter = 0

# ORIG 
orig_connection = cx_Oracle.connect("cdts", "cdts", "CAR-LNDSSDBP-02.wiley.com:1593/DSSPROD")
orig_cursor = orig_connection.cursor()
orig_cursor.execute(sql)
print(datetime.datetime.now())
for row in orig_cursor:
    if(counter % 1000 == 0):
        print(counter)
    counter += 1
    orig_report.write(str(row))
    orig_report.write('\n')
print(datetime.datetime.now())

# COPY

copy_connection = cx_Oracle.connect("DSS", "DSS", "AUS-LNDSSDBP-03.wiley.com:1593/DSSPRD")
copy_cursor = copy_connection.cursor();
copy_cursor.execute(sql)
print(datetime.datetime.now())
for row in copy_cursor:
    if(counter % 1000 == 0):
        print(counter)
    counter += 1
    copy_report.write(str(row))
    copy_report.write('\n')
print(datetime.datetime.now())