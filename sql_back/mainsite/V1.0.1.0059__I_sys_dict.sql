-- auto gen by fly 2015-11-02 13:49:53
/* ------ 总代中心代理状态字典数据 ------ */
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,parent_code,active)
  SELECT 'agent', 'agent_status', '1', '1', '总代中心代理状态：正常', '', true
  WHERE '1' not in (SELECT dict_code from sys_dict where module = 'agent' and dict_type = 'agent_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,parent_code,active)
  SELECT 'agent', 'agent_status', '2', '2', '总代中心代理状态：账号冻结', '', true
  WHERE '2' not in (SELECT dict_code from sys_dict where module = 'agent' and dict_type = 'agent_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,parent_code,active)
  SELECT 'agent', 'agent_status', '3', '3', '总代中心代理状态：账号停用', '', true
  WHERE '3' not in (SELECT dict_code from sys_dict where module = 'agent' and dict_type = 'agent_status');