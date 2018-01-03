-- auto gen by kevice 2015-10-10 13:51:27

update sys_dict set dict_code = 'all_front', remark='所有玩家' where id = 224;
update sys_dict set dict_code = 'online_front', remark='在线玩家' where id = 225;
update sys_dict set dict_code = 'offline_front', remark='离线玩家' where id = 226;

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark)
SELECT 'notice','receiver_group_type','all_back',null,'所有后台用户'
WHERE 'all_back' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'receiver_group_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark)
SELECT 'notice','receiver_group_type','online_back',null,'后台在线用户'
WHERE 'online_back' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'receiver_group_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark)
SELECT 'notice','receiver_group_type','offline_back',null,'后台离线用户'
WHERE 'offline_back' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'receiver_group_type');
