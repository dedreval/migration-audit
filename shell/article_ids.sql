COLUMN id FORMAT a80

SET LINESIZE 80

SET PAGESIZE 0

SELECT id from Content_Item where content_item_type_code='ARTICLE' order by id; 
