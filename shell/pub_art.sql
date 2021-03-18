ET LINESIZE 200
SET PAGESIZE 0
select DOI || chr(9) || published_date || chr(9) || last_upload_date from cdts.Content_Item where CONTENT_ITEM_TYPE_CODE = 'ARTICLE' and published = 1;
