-- auto gen by cheery 2015-10-16 11:50:41
INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '41', '玩家首页', 'home/homeIndex.html', '玩家首页', NULL, '', '1', 'pcenter', 'test:view', '1', '', 't', 'f'
  WHERE '玩家首页' not in (SELECT name from sys_resource where name = '玩家首页' and subsys_code = 'pcenter');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '42', '资金管理', 'test', '资金管理', NULL, NULL, '2', 'pcenter', 'test:view', '1', '', 't', 'f'
  WHERE '资金管理' not in (SELECT name from sys_resource where name = '资金管理' and subsys_code = 'pcenter');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '43', '交易记录', 'test', '交易记录', NULL, NULL, '3', 'pcenter', 'test:view', '1', '', 't', 'f'
  WHERE '交易记录' not in (SELECT name from sys_resource where name = '交易记录' and subsys_code = 'pcenter');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '44', '优惠活动', 'test', '优惠活动', NULL, NULL, '4', 'pcenter', 'test:view', '1', '', 't', 'f'
  WHERE '优惠活动' not in (SELECT name from sys_resource where name = '优惠活动' and subsys_code = 'pcenter');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '45', '消息公告', 'test', '消息公告', NULL, NULL, '5', 'pcenter', 'test:view', '1', '', 't', 'f'
  WHERE '消息公告' not in (SELECT name from sys_resource where name = '消息公告' and subsys_code = 'pcenter');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '46', '账号管理', 'test', '账号管理', NULL, NULL, '6', 'pcenter', 'test:view', '1', '', 't', 'f'
  WHERE '账号管理' not in (SELECT name from sys_resource where name = '账号管理' and subsys_code = 'pcenter');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '47', '推荐好友', 'test', '推荐好友', NULL, NULL, '7', 'pcenter', 'test:view', '1', '', 't', 'f'
  WHERE '推荐好友' not in (SELECT name from sys_resource where name = '推荐好友' and subsys_code = 'pcenter');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4201', '转账', 'test', '转账', '42', NULL, '1', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '转账' not in (SELECT name from sys_resource where name = '转账' and subsys_code = 'pcenter' AND parent_id = '42');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4202', '存款', 'test', '存款', '42', NULL, '2', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '存款' not in (SELECT name from sys_resource where name = '存款' and subsys_code = 'pcenter' AND parent_id='42');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4203', '取款', 'test', '取款', '42', NULL, '3', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '取款' not in (SELECT name from sys_resource where name = '取款' and subsys_code = 'pcenter' AND parent_id = '42');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4204', '资金记录', 'test', '资金记录', '42', NULL, '4', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '资金记录' not in (SELECT name from sys_resource where name = '资金记录' and subsys_code = 'pcenter' AND parent_id='42');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4301', '历史记录', 'test', '历史记录', '43', NULL, '1', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '历史记录' not in (SELECT name from sys_resource where name = '历史记录' and subsys_code = 'pcenter' AND parent_id='43');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4302', '未结算记录', 'test', '未结算记录', '43', NULL, '2', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '未结算记录' not in (SELECT name from sys_resource where name = '未结算记录' and subsys_code = 'pcenter' AND parent_id='43');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4501', '站点消息', 'test', '站点消息', '45', NULL, '1', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '站点消息' not in (SELECT name from sys_resource where name = '站点消息' and subsys_code = 'pcenter' AND parent_id='45');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4502', '游戏公告', 'test', '游戏公告', '45', NULL, '2', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '游戏公告' not in (SELECT name from sys_resource where name = '游戏公告' and subsys_code = 'pcenter' AND parent_id='45');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4601', '账号设置', 'test', '账号设置', '46', NULL, '1', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '账号设置' not in (SELECT name from sys_resource where name = '账号设置' and subsys_code = 'pcenter' AND parent_id='46');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4602', '个人信息', 'test', '个人信息', '46', NULL, '2', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '个人信息' not in (SELECT name from sys_resource where name = '个人信息' and subsys_code = 'pcenter' AND parent_id='46');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4603', '登录日志', 'test', '登录日志', '46', NULL, '3', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '登录日志' not in (SELECT name from sys_resource where name = '登录日志' and subsys_code = 'pcenter' AND parent_id='46');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4701', '推荐好友', 'test', '推荐好友', '47', NULL, '1', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '推荐好友' not in (SELECT name from sys_resource where name = '推荐好友' and subsys_code = 'pcenter' AND parent_id='47');

INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
  SELECT '4702', '推荐记录', 'test', '推荐记录', '47', NULL, '2', 'pcenter', 'test:view', '1', NULL, 't', 'f'
  WHERE '推荐记录' not in (SELECT name from sys_resource where name = '推荐记录' and subsys_code = 'pcenter' AND parent_id='47');