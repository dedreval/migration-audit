SET LINESIZE 200

SET PAGESIZE 0

select chr(39) || '/WCR/content/wcr-store/' || location || chr(39) || chr(9) || file_size from Content_Item_Part where last_update_date<SYSDATE-1;

