-- auto gen by sh $now
--字典表添加广告列表
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'content','carousel_type','carousel_type_login',1,'广告类别-登录',true WHERE 'carousel_type_login' not in (SELECT dict_code from sys_dict where module = 'content' and dict_type = 'carousel_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'content','carousel_type','carousel_type_register',2,'广告类别-注册',true WHERE 'carousel_type_login' not in (SELECT dict_code from sys_dict where module = 'content' and dict_type = 'carousel_type');
