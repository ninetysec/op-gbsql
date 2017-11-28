-- auto gen by kevice 2015-10-22 16:11:37

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice','send_status','01',null,'取消发送',true
WHERE '01' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'send_status');