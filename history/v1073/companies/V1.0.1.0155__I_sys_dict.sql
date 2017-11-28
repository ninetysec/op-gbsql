-- auto gen by fei 2016-08-22 15:26:12
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'player','create_channel','4',4,'手机注册',true
 WHERE '4' not in (SELECT dict_code from sys_dict where module = 'player' and dict_type = 'create_channel');
