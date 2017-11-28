-- auto gen by longer 2016-01-22 09:49:32

--删除无用的规则表
drop view if EXISTS v_sys_rule_file_catalog;
drop table if EXISTS sys_rule_file;
drop table if EXISTS sys_rule_file_catalog;
