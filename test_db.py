import cx_Oracle
import datetime

# Establish the database connection
connection = cx_Oracle.connect("DSS_DEV_DD", "DSS_DEV_DD", "AUS-LNDSSDBQ-02.wiley.com:1592/DSSQA")

# Obtain a cursor
cursor = connection.cursor()

# Data for binding
managerId = 145
firstName = "Peter"

# Execute the query
sql = """SELECT *
         FROM Content_Item
         WHERE last_upload_date > :ago"""
cursor.execute(sql, ago = datetime.datetime.now() - datetime.timedelta(days=10))

# Loop over the result set
for row in cursor:
    print(row)
    print(row[1])        
    print(type(row.get(1)))    