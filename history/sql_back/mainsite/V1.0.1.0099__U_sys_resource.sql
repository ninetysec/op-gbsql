-- auto gen by cheery 2015-11-24 01:23:18
UPDATE sys_resource set url = 'sys/vSubAccount/list.html' where name = '系统账号' AND url <> 'sys/vSubAccount/list.html';

UPDATE sys_resource set url = 'sys/account/index.html' where name = '我的账号' AND url <> 'sys/account/index.html';

truncate table sys_resource;
alter SEQUENCE sys_resource_id_seq RESTART 1;
SELECT redo_sqls($$
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (501, '资金记录', 'report/vPlayerFundsLog/fundsList.html', '', 5, '', 1, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (604, '联系人管理', 'ccenter/vSiteContacts/list.html', null, 6, null, 4, 'ccenter', 'filter:filter', 1, null, false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (302, '站点管理', 'vSysSiteManage/list.html', '站点管理', 3, '', 2, 'ccenter', 'test:view', 1, null, false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (301, '站长管理', 'vSiteMasterManage/list.html', '站长管理', 3, '', 1, 'ccenter', 'test:view', 1, null, false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (602, '系统账号', 'sys/vSubAccount/list.html', '', 6, '', 2, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (601, '系统参数', 'ccenterParam/basicSettingIndex.html', null, 6, null, 1, 'ccenter', 'test:view', 1, null, false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (101, '提醒事项', null, '', 1, '', 1, 'ccenter', 'game:view', 1, null, false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (102, '资金概况', '', '', 1, '', 2, 'ccenter', 'game:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (103, '站点概况', '', '', 1, '', 3, 'ccenter', 'game:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (104, 'API游戏', '', '', 1, '', 4, 'ccenter', 'game:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (105, '权限日志', '', '', 1, '', 5, 'ccenter', 'game:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (502, '交易记录', 'report/vPlayerGameTransaction/transacList.html', '', 5, '', 2, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (403, '信息公告', 'messageAnnouncement/systemAnnouncement.html', '', 4, '', 1, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (603, '我的账号', 'sys/account/index.html', '', 6, '', 3, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (201, '内容审核', 'vSiteContent/list.html', null, 2, null, 1, 'ccenter', 'test:view', 1, null, false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (506, '日志管理', 'report/log/logList.html', '运营中心-报表-日志管理', 5, '', 6, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (505, '返佣统计', 'report/rebate/rebateIndex.html', '运营中心-报表-返佣统计', 5, '', 5, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (504, '返水统计', 'report/backwater/reindex.html', '运营中心-报表-返水统计', 5, '', 4, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (503, '经营报表', 'report/operating/list.html', '运营中心-报表-经营报表', 5, '', 3, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (202, '模板管理', null, null, 2, null, 2, 'ccenter', 'test:view', 1, null, false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (401, '结算账单', null, '', 4, '', 1, 'ccenter', 'test:view', 1, null, false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (402, '包网方案', '', '', 4, '', 1, 'ccenter', 'test:view', 1, '', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (1, '首页', 'home/homeIndex.html', '', null, null, 1, 'ccenter', 'previlege:view', 1, 'fa-coffee', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (2, '服务', '', null, null, null, 2, 'ccenter', 'message:view', 1, 'fa-server', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (3, '站点', '', '', null, null, 3, 'ccenter', 'test:view', 1, 'fa-gamepad', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (4, '运营', '', '', null, null, 4, 'ccenter', 'test:view', 1, 'fa-credit-card', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (5, '报表', '', '', null, null, 5, 'ccenter', 'test:view', 1, 'fa-pie-chart', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (6, '系统', null, '', null, '', 6, 'ccenter', 'test:view', 1, 'fa-cogs', false, false);
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege) VALUES (203, '系统公告', 'systemAnnouncement/systemNotice.html', '', 2, '', 3, 'ccenter', 'test:view', 1, '', false, false);
$$);

--角色
truncate table sys_role_resource;
alter SEQUENCE sys_role_resource_id_seq RESTART 63;
SELECT redo_sqls($$
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (25, 1, 102);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (26, 1, 103);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (27, 1, 1);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (28, 1, 2);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (29, 1, 3);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (30, 1, 4);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (31, 1, 5);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (32, 1, 104);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (33, 1, 105);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (34, 1, 6);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (35, 1, 201);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (36, 1, 202);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (37, 1, 203);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (38, 1, 204);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (39, 1, 301);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (40, 1, 302);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (41, 1, 401);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (42, 1, 501);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (43, 1, 502);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (44, 1, 503);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (45, 1, 504);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (46, 1, 601);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (47, 1, 602);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (48, 1, 603);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (49, 1, 604);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (50, 1, 40101);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (51, 1, 40102);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (52, 1, 40103);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (53, 1, 60101);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (54, 1, 60102);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (55, 1, 60103);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (56, 1, 60104);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (57, 1, 60201);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (58, 1, 60202);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (59, 1, 60203);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (60, 1, 60401);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (61, 1, 60402);
INSERT INTO sys_role_resource (id, role_id, resource_id) VALUES (62, 1, 101);
$$);







DROP VIEW IF EXISTS v_sub_account;
CREATE OR REPLACE VIEW v_sub_account  as
  ---是否包含重要角色
  SELECT
    su.user_type,
    su. ID,
    su.username,
    su.status,
    su.create_time,
    su.real_name,
    array_to_json(array(SELECT name FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) roles,
    array_to_json(array(SELECT id FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) role_ids,
    (SELECT CASE WHEN count(1) > 0 then true else false end built_in FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) and built_in )built_in,
    su.owner_id
  FROM
    sys_user su
  where su.user_type in ('11') and status in ('1','2');
COMMENT ON VIEW "v_sub_account" IS '子账户视图';



--资金类型 删掉返佣
DELETE FROM sys_dict where MODULE = 'common' AND dict_type = 'transaction_type' AND dict_code = 'rebate';