-- auto gen by cherry 2016-07-18 21:36:33
 select redo_sqls($$
	ALTER TABLE notice_tmpl ADD COLUMN order_num INT4;
	ALTER TABLE notice_tmpl ADD COLUMN is_display bool;
$$);

COMMENT ON TABLE notice_tmpl IS '排序';
COMMENT ON TABLE notice_tmpl IS '标识是不是在站长中心后台展现';


--玩家注册成功
UPDATE notice_tmpl SET order_num = 1 WHERE tmpl_type = 'auto' AND event_type = 'PLAYER_REGISTER_SUCCESS';
--代理注册成功
UPDATE notice_tmpl SET order_num = 2 WHERE tmpl_type = 'auto' AND event_type = 'AGENT_REGISTER_SUCCESS';
--存款审核成功
UPDATE notice_tmpl SET order_num = 3 WHERE tmpl_type = 'auto' AND event_type = 'DEPOSIT_AUDIT_SUCCESS';
--玩家取款审核成功
UPDATE notice_tmpl SET order_num = 4 WHERE tmpl_type = 'auto' AND event_type = 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS';
--代理取款审核成功
UPDATE notice_tmpl SET order_num = 5 WHERE tmpl_type = 'auto' AND event_type = 'AGENT_WITHDRAWAL_AUDIT_SUCCESS';
--手动存款成功
UPDATE notice_tmpl SET order_num = 6 WHERE tmpl_type = 'auto' AND event_type = 'MANUAL_RECHARGE_SUCCESS';
--优惠审核成功
UPDATE notice_tmpl SET order_num = 7 WHERE tmpl_type = 'auto' AND event_type = 'PREFERENCE_AUDIT_SUCCESS';
--玩家返水成功
UPDATE notice_tmpl SET order_num = 8 WHERE tmpl_type = 'auto' AND event_type = 'RETURN_RABBET_SUCCESS';
--代理返佣成功
UPDATE notice_tmpl SET order_num = 9 WHERE tmpl_type = 'auto' AND event_type = 'RETURN_COMMISSION_SUCCESS';
--手动修改玩家资料
UPDATE notice_tmpl SET order_num = 10 WHERE tmpl_type = 'auto' AND event_type = 'CHANGE_PLAYER_DATA';


--manual_event_type.PLAYER_ACCOUNT_FREEZON=玩家账号冻结
UPDATE notice_tmpl SET order_num = 1 WHERE tmpl_type = 'manual' AND event_type = 'PLAYER_ACCOUNT_FREEZON';
--manual_event_type.ACENTER_ACCOUNT_FREEZON=代理账号冻结
UPDATE notice_tmpl SET order_num = 2 WHERE tmpl_type = 'manual' AND event_type = 'ACENTER_ACCOUNT_FREEZON';
--manual_event_type.TCENTER_ACCOUNT_FREEZON=总代账号冻结
UPDATE notice_tmpl SET order_num = 3 WHERE tmpl_type = 'manual' AND event_type = 'TCENTER_ACCOUNT_FREEZON';
--manual_event_type.BALANCE_FREEZON=余额冻结(手动)
UPDATE notice_tmpl SET order_num = 4 WHERE tmpl_type = 'manual' AND event_type = 'BALANCE_FREEZON';
--manual_event_type.FORCE_KICK_OUT=强制踢出
UPDATE notice_tmpl SET order_num = 5 WHERE tmpl_type = 'manual' AND event_type = 'FORCE_KICK_OUT';
--manual_event_type.PLAYER_ACCOUNT_STOP=玩家账号停用
UPDATE notice_tmpl SET order_num = 6 WHERE tmpl_type = 'manual' AND event_type = 'PLAYER_ACCOUNT_STOP';
--manual_event_type.ACENTER_ACCOUNT_STOP=代理账号停用
UPDATE notice_tmpl SET order_num = 7 WHERE tmpl_type = 'manual' AND event_type = 'ACENTER_ACCOUNT_STOP';
--manual_event_type.TCENTER_ACCOUNT_STOP=总代账号停用
UPDATE notice_tmpl SET order_num = 8 WHERE tmpl_type = 'manual' AND event_type = 'TCENTER_ACCOUNT_STOP';
--manual_event_type.DEPOSIT_AUDIT_FAIL=存款审核失败
UPDATE notice_tmpl SET order_num = 9 WHERE tmpl_type = 'manual' AND event_type = 'DEPOSIT_AUDIT_FAIL';
--manual_event_type.PLAYER_WITHDRAWAL_AUDIT_FAIL=玩家取款审核失败
UPDATE notice_tmpl SET order_num = 10 WHERE tmpl_type = 'manual' AND event_type = 'PLAYER_WITHDRAWAL_AUDIT_FAIL';
--manual_event_type.AGENT_WITHDRAWAL_AUDIT_FAIL=代理取款审核失败
UPDATE notice_tmpl SET order_num = 11 WHERE tmpl_type = 'manual' AND event_type = 'AGENT_WITHDRAWAL_AUDIT_FAIL';
--manual_event_type.REFUSE_PLAYER_WITHDRAWAL=拒绝玩家取款
UPDATE notice_tmpl SET order_num = 12 WHERE tmpl_type = 'manual' AND event_type = 'REFUSE_PLAYER_WITHDRAWAL';
--manual_event_type.REFUSE_AGENT_WITHDRAWAL=拒绝代理取款
UPDATE notice_tmpl SET order_num = 13 WHERE tmpl_type = 'manual' AND event_type = 'REFUSE_AGENT_WITHDRAWAL';
--manual_event_type.MANUAL_WITHDRAWAL=手动取款
UPDATE notice_tmpl SET order_num = 14 WHERE tmpl_type = 'manual' AND event_type = 'MANUAL_WITHDRAWAL';
--manual_event_type.SALE_AUDIT_FAIL=优惠审核失败
UPDATE notice_tmpl SET order_num = 15 WHERE tmpl_type = 'manual' AND event_type = 'PREFERENCE_AUDIT_FAIL';
--manual_event_type.REFUSE_RETURN_RABBET=拒绝返水
UPDATE notice_tmpl SET order_num = 16 WHERE tmpl_type = 'manual' AND event_type = 'REFUSE_RETURN_RABBET';
--manual_event_type.REFUSE_RETURN_COMMISSION=拒绝返佣
UPDATE notice_tmpl SET order_num = 17 WHERE tmpl_type = 'manual' AND event_type = 'REFUSE_RETURN_COMMISSION';

UPDATE notice_tmpl SET is_display = false WHERE tmpl_type = 'auto' AND event_type = 'BALANCE_AUTO_FREEZON';
UPDATE notice_tmpl SET is_display = false WHERE tmpl_type = 'auto' AND event_type = 'RESET_PERMISSION_PWD_SUCCESS';
UPDATE notice_tmpl SET is_display = false WHERE tmpl_type = 'auto' AND event_type = 'RESET_LOGIN_PASSWORD_SUCCESS';

--先删除旧的默认权限
delete from sys_user_role where role_id in (372,373,374);

delete from sys_role_resource where role_id in (372,373,374);

delete from sys_role_default_resource where role_id in (372,373,374);

delete from sys_role where id in (372,373,374);


--添加新的权限
INSERT INTO "sys_role" ("id", "name", "status", "create_user", "create_time", "update_user", "update_time", "subsys_code", "code", "built_in", "site_id")
	SELECT '-11', 'default_role_customer_service', '1', '0', '2016-07-01 09:16:30.175', NULL, NULL, 'mcenter', NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM sys_role where id='-11');

INSERT INTO "sys_role" ("id", "name", "status", "create_user", "create_time", "update_user", "update_time", "subsys_code", "code", "built_in", "site_id")
SELECT '-12', 'default_role_in', '1', '0', '2016-07-01 09:25:26.451', NULL, NULL, 'mcenter', NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM sys_role where id='-12');

INSERT INTO "sys_role" ("id", "name", "status", "create_user", "create_time", "update_user", "update_time", "subsys_code", "code", "built_in", "site_id")
SELECT '-13', 'default_role_out', '1', '0', '2016-07-01 09:29:53.058', NULL, NULL, 'mcenter', NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM sys_role where id='-13');

INSERT INTO "sys_role" ("id", "name", "status", "create_user", "create_time", "update_user", "update_time", "subsys_code", "code", "built_in", "site_id")
SELECT '-14', 'default_role_foreman', '1', '0', '2016-07-01 09:38:08.788', NULL, NULL, 'mcenter', NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM sys_role where id='-14');

DELETE FROM sys_role_resource where role_id='-11';

DELETE FROM sys_role_resource where role_id='-12';

DELETE FROM sys_role_resource where role_id='-13';

DELETE FROM sys_role_resource where role_id='-14';

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '7');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '708');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '4');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '2');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '5');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '505');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '504');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '503');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '502');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '70802');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '70801');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '506');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '50501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '50401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '50301');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '50201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '40103');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '207');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '306');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '20101');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '20208');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '20209');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '20203');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '20204');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '20202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-11', '20206');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '7');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '708');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '4');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '3');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '2');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '5');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '505');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '504');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '503');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '502');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '302');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '301');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '70802');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '70801');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '506');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '50501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '50401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '50301');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '50201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '40103');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '305');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '30202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '30201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '30101');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '207');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '306');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '20101');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '20208');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '20204');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '20202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-12', '20206');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '7');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '708');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '3');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '2');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '5');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '505');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '504');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '503');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '502');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '406');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '405');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '404');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '304');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '303');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '70802');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '70801');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '506');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '50501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '50401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '50301');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '50201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '40601');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '40501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '40401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '305');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '30401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '30301');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '207');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '306');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '20101');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '20208');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '20204');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '20202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-13', '20206');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '1');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '206');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '204');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '2');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '7');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '70302');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '703');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '708');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '612');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '6');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '608');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '5');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '505');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '504');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '503');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '502');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '4');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '705');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '611');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '610');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '3');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '406');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '405');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '404');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '304');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '303');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '302');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '301');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '203');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '710');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '70804');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '70802');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '70803');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '70801');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '61204');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '61202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '61201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '61203');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '714');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '713');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '701');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '403');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '614');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '613');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '602');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '601');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '605');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '604');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '60801');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '402');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '607');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '506');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '50501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '50401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '50301');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '50201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '707');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '706');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '70501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '704');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '61101');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '61102');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '61103');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '61001');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '40103');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '40101');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '40102');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '40601');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '40501');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '40401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '305');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '30401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '30301');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '30202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '30201');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '30101');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '207');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '306');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20101');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20302');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20301');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20602');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20601');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20401');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20402');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20403');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20208');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20209');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20203');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20204');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20202');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20205');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20206');

INSERT INTO "sys_role_resource" ("role_id", "resource_id") VALUES ('-14', '20207');



DELETE FROM sys_role_default_resource where role_id='-11';

DELETE FROM sys_role_default_resource where role_id='-12';

DELETE FROM sys_role_default_resource where role_id='-13';

DELETE FROM sys_role_default_resource where role_id='-14';

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '7');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '708');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '4');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '2');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '5');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '505');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '504');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '503');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '502');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '70802');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '70801');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '506');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '50501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '50401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '50301');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '50201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '40103');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '207');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '306');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '20101');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '20208');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '20209');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '20203');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '20204');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '20202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-11', '20206');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '7');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '708');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '4');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '3');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '2');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '5');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '505');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '504');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '503');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '502');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '302');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '301');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '70802');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '70801');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '506');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '50501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '50401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '50301');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '50201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '40103');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '305');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '30202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '30201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '30101');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '207');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '306');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '20101');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '20208');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '20204');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '20202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-12', '20206');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '7');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '708');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '3');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '2');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '5');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '505');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '504');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '503');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '502');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '406');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '405');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '404');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '304');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '303');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '70802');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '70801');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '506');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '50501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '50401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '50301');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '50201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '40601');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '40501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '40401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '305');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '30401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '30301');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '207');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '306');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '20101');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '20208');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '20204');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '20202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-13', '20206');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '1');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '206');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '204');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '2');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '7');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '70302');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '703');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '708');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '612');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '6');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '608');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '5');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '505');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '504');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '503');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '502');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '4');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '705');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '611');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '610');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '3');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '406');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '405');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '404');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '304');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '303');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '302');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '301');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '203');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '710');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '70804');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '70802');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '70803');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '70801');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '61204');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '61202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '61201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '61203');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '714');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '713');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '701');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '403');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '614');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '613');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '602');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '601');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '605');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '604');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '60801');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '402');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '607');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '506');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '50501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '50401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '50301');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '50201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '707');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '706');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '70501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '704');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '61101');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '61102');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '61103');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '61001');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '40103');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '40101');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '40102');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '40601');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '40501');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '40401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '305');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '30401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '30301');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '30202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '30201');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '30101');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '207');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '306');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20101');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20302');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20301');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20602');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20601');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20401');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20402');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20403');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20208');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20209');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20203');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20204');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20202');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20205');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20206');

INSERT INTO "sys_role_default_resource" ("role_id", "resource_id") VALUES ('-14', '20207');

