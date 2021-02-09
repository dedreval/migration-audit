COLUMN id FORMAT a200

SET LINESIZE 200

SET PAGESIZE 0

select content_item_id || chr(9) || lower(part_type_code) || chr(9) || cip.id from Content_Item_Part cip, Content_Item ci where ci.id=cip.content_item_id and part_type_code != 'DOCUMENT' and ci.CONTENT_ITEM_TYPE_CODE='ARTICLE';
