-- auto gen by linsen 2018-03-12 09:11:37
-- API注单资金记录 by zain
INSERT INTO sys_resource (id,name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
SELECT 904,'API注单资金记录', 'gameOrderTransaction/list.html', 'API注单资金记录', '9', '', '4', 'boss', 'api:game_order_transaction', '1', '', 'f', 't', 't'
 WHERE NOT EXISTS (SELECT id FROM sys_resource  WHERE  id=904) ;
