-- auto gen by cheery 2015-09-18 17:36:19
--新增词典：交易类型-返水
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','transaction_type','backwater',5,'交易类型:返水',true
WHERE 'backwater' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_type');

--新增/修改存款类型
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'fund','recharge_type_parent','artificial_deposit',3,'充值父类型：手动存款',true
WHERE 'artificial_deposit' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_type_parent');

UPDATE sys_dict SET dict_code = 'company_deposit' WHERE "module" ='fund' AND dict_type = 'recharge_type_parent' AND dict_code = 'comapny_despoit';

UPDATE sys_dict SET dict_code = 'online_deposit' WHERE "module" ='fund' AND dict_type = 'recharge_type_parent' AND dict_code = 'online_despoit';

UPDATE sys_dict SET parent_code ='company_deposit' WHERE
"module" ='fund' AND dict_type = 'recharge_type'
AND (dict_code='online' or dict_code='atm' OR dict_code='counter');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active,parent_code)
SELECT 'fund','recharge_type','artificial_deposit',4,'充值方式:手动存入-综合存款',true,'artificial_deposit'
WHERE 'artificial_deposit' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active,parent_code)
SELECT 'fund','recharge_type','error_withdraw',5,'充值方式:手动存入-取款误操作',true,'artificial_deposit'
WHERE 'error_withdraw' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active,parent_code)
SELECT 'fund','recharge_type','deposit_other',6,'充值方式:手动存入-其他',true,'artificial_deposit'
WHERE 'deposit_other' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active,parent_code)
SELECT 'fund','recharge_type','artificial_favourable',7,'充值方式:手动存入-存款优惠',true,'artificial_deposit'
WHERE 'artificial_favourable' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active,parent_code)
SELECT 'fund','recharge_type','deposit_negative',8,'充值方式:手动存入-负数余额归零',true,'artificial_deposit'
WHERE 'deposit_negative' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_type');

--新增优惠活动状态的字典
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','activity_state','1',1,'优惠活动状态：进行中',true
WHERE '1' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'activity_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','activity_state','2',2,'优惠活动状态：未开始',true
WHERE '2' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'activity_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','activity_state','3',3,'优惠活动状态：已结束',true
WHERE '3' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'activity_state');

--新增-消息公告类型字典
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','announcement_type','system_announcement',1,'系统公告',true
WHERE 'system_announcement' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'announcement_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','announcement_type','advisory_announcement',3,'咨询消息',true
WHERE 'advisory_announcement' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'announcement_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','announcement_type','game_announcement',2,'游戏公告',true
WHERE 'game_announcement' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'announcement_type');

--新增-返水发放状态字典
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','lssuing_state','pengding_pay',1,'返水状态：待发放',true
WHERE 'pengding_pay' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'lssuing_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','lssuing_state','part_pay',2,'返水发放状态：部分已发放',true
WHERE 'part_pay' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'lssuing_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','lssuing_state','all_pay',3,'返水发放状态：全部已发放',true
WHERE 'all_pay' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'lssuing_state');

--新增-结算状态
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','settlement_state','pending_lssuing',1,'结算状态：待发放',true
WHERE 'pending_lssuing' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'settlement_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','settlement_state','lssuing',2,'结算状态：已发放',true
WHERE 'lssuing' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'settlement_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'operation','settlement_state','reject_lssuing',3,'结算状态：拒绝发放',true
WHERE 'reject_lssuing' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'settlement_state');

--删除手工存入项目，全部迁移到recharge_type 充值类型
DELETE FROM sys_dict WHERE "module"='fund' AND dict_type='deposit_project'





