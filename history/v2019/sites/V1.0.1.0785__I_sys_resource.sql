-- auto gen by linsen 2018-04-24 17:47:51
-- 删除原来菜单权限重建 by steffan
delete from sys_resource where id='408' ;

-- 活动菜单,权限; by steffan

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
 select '408', '活动大厅', 'activityHall/vActivityMessageHall/list.html', '运营-活动大厅菜单', '4', NULL, '9', 'mcenter', 'operate:activityHall', '1', 'icon-huodongguanli', 't', 'f', 't'
where not EXISTS (SELECT id FROM sys_resource where id='408' );

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '40801', '活动列表', 'activityHall/vActivityMessageHall/list.html', '运营-活动大厅菜单', '408', '', NULL, 'mcenter', 'operate:activityHall', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=40801);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '40802', '活动编辑', 'activityHall/activityType/activityEdit.html', '运营-活动大厅-活动编辑', '408', '', NULL, 'mcenter', 'operate:activityHall_edit', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=40802);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '40803', '活动删除', 'activityHall/activity/deleteActivity.html', '运营-活动大厅-活动删除', '408', '', NULL, 'mcenter', 'operate:activityHall_delete', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=40803);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '40804', '活动新增', 'activityHall/activityType/customList.html', '运营-活动大厅菜单-活动新增', '408', '', NULL, 'mcenter', 'operate:activityHall_add', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=40804);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '40805', '活动排序', 'activityHall/activity/order/saveOrder.html', '运营-活动大厅菜单-活动排序', '408', '', NULL, 'mcenter', 'operate:activityHall_order', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=40805);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '40806', '活动审核', 'activityHall/vActivityPlayerApply/auditStatus.html', '运营-活动大厅菜单-活动审核', '408', '', NULL, 'mcenter', 'operate:activityHall_checkapply', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=40806);

