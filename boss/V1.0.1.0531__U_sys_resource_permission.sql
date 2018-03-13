-- auto gen by water 2018-03-13 20:01:57
-- fix: 菜单的权限控制必须是同段的，不能只有单前缀
update sys_resource set permission = 'serve:download_template'  where id = 202;
update sys_resource set permission = 'platform:download_template'  where id = 304;
update sys_resource set permission = 'system:param'  where id = 601;
update sys_resource set permission = 'system:preferences'  where id = 604;