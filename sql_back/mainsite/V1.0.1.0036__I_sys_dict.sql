-- auto gen by cheery 2015-10-14 10:46:56
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','check_status','1',1,'待处理',true
WHERE '1' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'check_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','check_status','2',2,'成功',true
WHERE '2' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'check_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','check_status','3',3,'失败',true
WHERE '3' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'check_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','preferential_form','regular_handsel',1,'固定彩金',true
WHERE 'regular_handsel' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'preferential_form');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','preferential_form','percentage_handsel',2,'比例彩金',true
WHERE 'percentage_handsel' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'preferential_form');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','preferential_form','accumulate_points',3,'积分',true
WHERE 'accumulate_points' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'preferential_form');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','preferential_form','coupons',4,'优惠券',true
WHERE 'coupons' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'preferential_form');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','preferential_form','luck_draw_number',5,'抽奖次数',true
WHERE 'luck_draw_number' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'preferential_form');



