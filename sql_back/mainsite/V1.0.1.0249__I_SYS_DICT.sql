-- auto gen by tom 2016-01-25 09:18:50
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','import_players_status','STATUS_ALL',1,'导入玩家（全部）',true
WHERE 'STATUS_ALL' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'import_players_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','import_players_status','STATUS_ENABLE',2,'已开启',true
WHERE 'STATUS_ENABLE' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'import_players_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','import_players_status','STATUS_CLOSING',3,'关闭中',true
WHERE 'STATUS_CLOSING' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'import_players_status');