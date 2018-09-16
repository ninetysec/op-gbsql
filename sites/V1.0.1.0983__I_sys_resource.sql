-- auto gen by steffan 2018-09-16 16:50:31
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '410', '手续费设置', 'rechargeFeeSchema/list.html', '手续费设置', '4', null, '11', 'mcenter', 'operate:recharge_fee', '1', 'icon-xianshangzhifujilu', 't', 'f', 'f'
WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE ID='410');


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '41001', '手续费设置-删除', 'rechargeFeeSchema/delete.html', '手续费设置-删除', '410', NULL, NULL, 'mcenter', 'operate:recharge_fee_delete', '2', NULL, 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE id=41001);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '41002', '手续费设置-编辑', 'rechargeFeeSchema/edit.html', '手续费设置-编辑', '410', NULL, NULL, 'mcenter', 'operate:recharge_fee_edit', '2', NULL, 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE id=41002);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '41003', '手续费设置-新增', 'rechargeFeeSchema/create.html', '手续费设置-新增', '410', NULL, NULL, 'mcenter', 'operate:recharge_fee_create', '2', NULL, 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE id=41003);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '41004', '手续费设置-列表', 'rechargeFeeSchema/list.html', '手续费设置-列表', '410', NULL, NULL, 'mcenter', 'operate:recharge_fee_list', '2', NULL, 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE id=41004);

