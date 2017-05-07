-- auto gen by kevice 2015-09-11 16:54:57

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','manual_event_type','REFUSE_RETURN_RABBET',null,'拒绝返水',true
WHERE 'REFUSE_RETURN_RABBET' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'manual_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','manual_event_type','REFUSE_RETURN_COMMISSION',null,'拒绝返佣',true
WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'manual_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','auto_event_type','DEPOSIT_AUDIT_SUCCESS',null,'充值审核成功',true
WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'auto_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','auto_event_type','WITHDRAWAL_AUDIT_SUCCESS',null,'提现审核成功',true
WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'auto_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','manual_event_type','DEPOSIT_AUDIT_FAIL',null,'充值审核失败',true
WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'manual_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','manual_event_type','WITHDRAWAL_AUDIT_FAIL',null,'提现审核失败',true
WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'manual_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','manual_event_type','DEPOSIT_FOR_PLAYER',null,'玩家负数余额归零',true
WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'manual_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','manual_event_type','DEDUCT_MONEY_FROM_PLAYER',null,'扣除玩家款项',true
WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'manual_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','auto_event_type','RETURN_RABBET_SUCCESS',null,'返水结算成功',true
WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'auto_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','auto_event_type','RETURN_COMMISSION_SUCCESS',null,'返佣结算成功',true
WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'auto_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','contact_way_status','22',null,'被清除',true
WHERE '22' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'contact_way_status');
