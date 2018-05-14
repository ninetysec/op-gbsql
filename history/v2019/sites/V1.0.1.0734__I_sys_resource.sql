-- auto gen by linsen 2018-04-10 11:15:27
--站长中心添加活动大厅菜单 add by steffan

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
 select '408', '活动大厅', 'vActivityMessageHall/list.html', '运营-活动大厅菜单', '4', NULL, '9', 'mcenter', 'role:activityHall', '1', 'icon-huodongguanli', 't', 'f', 't'
where not EXISTS (SELECT id FROM sys_resource where id='408' );