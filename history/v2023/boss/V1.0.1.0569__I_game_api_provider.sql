-- auto gen by steffan 2018-05-22 14:19:21  add by mical
INSERT INTO sys_resource (id,name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
  SELECT 920,'API资金记录', 'playerapitransfer/list.html', 'API资金记录', '9', '', '4', 'boss', 'api:player_api_transfer', '1', '', 'f', 't', 't'
  WHERE NOT EXISTS (SELECT id FROM sys_resource  WHERE  id=920) ;