-- auto gen by admin 2016-05-26 00:01:26
CREATE or REPLACE VIEW v_exception_transfer AS
SELECT t1.* ,t2.username comanyname,t3.username mastername,t4.username sitename
FROM exception_transfer t1
LEFT JOIN sys_user t2 ON t1.company_id = t2.id
LEFT JOIN sys_user t3 ON t1.master_id = t3.id
LEFT JOIN sys_user t4 on t1.site_id = t4.id;


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT  'fund', 'transfer_state', 'process', '1', '转账状态：待确认', NULL, 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict WHERE module='fund' and dict_type ='transfer_state' and dict_code='process');