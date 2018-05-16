-- auto gen by cherry 2018-05-11 14:49:36
--add by jimmy
  select redo_sqls($$
    ALTER TABLE game_api_log ADD COLUMN  http_state_code  varchar(10);
  $$);

  COMMENT ON COLUMN game_api_log.http_state_code IS 'HTTP状态码'; -- 添加字段注释

-- 投注记录编辑权限

	INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

	SELECT '40301', '投注记录编辑', 'apiMonitorTransConf/list.html', '投注记录编辑', '403', '', '1', 'boss', 'report:betOrderEdit', '2', '', 'f', 't', 't'

	WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE permission = 'report:betOrderEdit' OR ID = 40301);



	-- 投注检测编辑权限

	INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

	SELECT '41002', '投注检测编辑', 'apiMonitorTransConf/list.html', '投注检测编辑', '410', '', '1', 'boss', 'disclose:betOrderEdit', '2', '', 'f', 't', 't'

	WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE permission = 'disclose:betOrderEdit' OR ID = 41002);