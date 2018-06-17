-- auto gen by linsen 2018-06-12 21:07:10
--修改导出玩家联系方式设置 by martin
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
select  'log', 'log_type', '75', '75', '修改导出玩家联系方式设置', NULL, 't'
where not exists(select id from sys_dict where module='log' and dict_type='log_type' and dict_code = '75');