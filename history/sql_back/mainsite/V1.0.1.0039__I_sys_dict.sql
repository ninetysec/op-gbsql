-- auto gen by kevice 2015-10-14 16:42:02

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','manual_event_type','PREFERENCE_AUDIT_FAIL',null,'优惠审批失败',true
WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'manual_event_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','auto_event_type','PREFERENCE_AUDIT_SUCCESS',null,'优惠审批成功',true
WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'auto_event_type');