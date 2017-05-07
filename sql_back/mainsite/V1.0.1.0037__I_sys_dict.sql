-- auto gen by cheery 2015-10-14 12:00:01
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'game','order_state','cancel',3,'游戏下单状态：取消订单',true
  WHERE 'cancel' not in (SELECT dict_code from sys_dict where module = 'game' and dict_type = 'order_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'game','order_state','settle',2,'游戏下单状态：已结算',true
  WHERE 'settle' not in (SELECT dict_code from sys_dict where module = 'game' and dict_type = 'order_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'game','order_state','pending_settle',1,'游戏下单状态：待结算',true
  WHERE 'pending_settle' not in (SELECT dict_code from sys_dict where module = 'game' and dict_type = 'order_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'operation','activity_state','draft',4,'草稿',true
  WHERE 'draft' not in (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'activity_state');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'common','remark_title','rebate',7,'备注标题：返佣',true
  WHERE 'rebate' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'remark_title');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'common','remark_title','backwater',6,'备注标题：修改实付返水',true
  WHERE 'backwater' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'remark_title');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'common','status','lssuing',6,'状态：已发放',true
  WHERE 'lssuing' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
  SELECT 'common','status','reject',5,'状态：拒绝',true
  WHERE 'reject' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'status');

update sys_dict SET dict_code='processing' WHERE "module"='operation' AND dict_type='activity_state' AND dict_code='1';

update sys_dict SET dict_code='notStarted ' WHERE "module"='operation' AND dict_type='activity_state' AND dict_code='2';

update sys_dict SET dict_code='finished' WHERE "module"='operation' AND dict_type='activity_state' AND dict_code='3';


