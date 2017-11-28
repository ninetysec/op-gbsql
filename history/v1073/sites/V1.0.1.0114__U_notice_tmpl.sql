-- auto gen by admin 2016-04-20 14:14:13
select redo_sqls($$
     CREATE SEQUENCE "order_id_api_trans_seq"
     INCREMENT 1
     MINVALUE 1000000
     MAXVALUE 9999999999
     START 1000000
     CACHE 10;
$$);
UPDATE notice_tmpl set group_code='4204dab397f54f59b11c999454d53614' WHERE event_type='SCHEDULE_EXCEPTION' and group_code='1361606215194-iuiuty1';

UPDATE notice_tmpl SET group_code='121259dedb424587a0eed5661604322b' WHERE event_type='SCHEDULE_OVERTIME' AND group_code='1361606215194-iuiuty1';

UPDATE notice_tmpl SET group_code='32cb829ebd4d4bf3bfa765ddba2efa6b' WHERE event_type='AGENT_WITHDRAWAL_AUDIT_SUCCESS' AND group_code='2b801fbd304e00366393bdb9bf1d6c24';

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'BALANCE_AUTO_FREEZON', 'siteMsg', '4c12250314544341bb0f8c57dbad2bc3', 't', 'zh_CN', '您的账户由于异常操作，支付功能（转账和取款功能）被暂时关闭！', '您的安全密码输入错误次数超过上限，支付功能（转账和取款功能）已被系统临时冻结，${unfreezetime}解冻后支付功能将恢复正常。您也可以重置安全密码解冻。如有疑问，请联系客服处理！', 'f', NULL, NULL, '2016-04-19 09:12:40.126', '0', '2016-04-19 09:43:02.123508', '0', 't'
WHERE '4c12250314544341bb0f8c57dbad2bc3' not in(SELECT group_code FROM notice_tmpl where tmpl_type='auto' and event_type='BALANCE_AUTO_FREEZON' and publish_method='siteMsg' and locale='zh_CN');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'BALANCE_AUTO_FREEZON', 'siteMsg', '4c12250314544341bb0f8c57dbad2bc3', 't', 'zh_TW', '您的账户由于异常操作，支付功能（转账和取款功能）被暂时关闭！', '您的安全密码输入错误次数超过上限，支付功能（转账和取款功能）已被系统临时冻结，${unfreezetime}解冻后支付功能将恢复正常。您也可以重置安全密码解冻。如有疑问，请联系客服处理！', 'f', NULL, NULL, '2016-04-19 09:12:40.126', '0', '2016-04-19 09:43:02.123508', '0', 't'
WHERE '4c12250314544341bb0f8c57dbad2bc3' not in(SELECT group_code FROM notice_tmpl where tmpl_type='auto' and event_type='BALANCE_AUTO_FREEZON' and publish_method='siteMsg' and locale='zh_TW');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'BALANCE_AUTO_FREEZON', 'siteMsg', '4c12250314544341bb0f8c57dbad2bc3', 't', 'en_US', 'The payment functions (transfer, withdrawal) are temporary closed because your account has operation exception.', 'You typed too many incorrect security passwords beyond the system limit value, so the payment functions (transfer, deposit and withdrawal) are frozen until 6:30:12pm in Mar 12th, 2015. You also can reset security password in order to unfreeze the functions. If your have any queries, please contact us.', 'f', NULL, NULL, '2016-04-19 09:12:40.126', '0', '2016-04-19 09:43:02.123508', '0', 'f'
WHERE '4c12250314544341bb0f8c57dbad2bc3' not in(SELECT group_code FROM notice_tmpl where tmpl_type='auto' and event_type='BALANCE_AUTO_FREEZON' and publish_method='siteMsg' and locale='en_US');

UPDATE "notice_tmpl" SET "title"='您的个人资料已被管理员修改，请及时确认！', "default_title"='您的个人资料已被管理员修改，请及时确认！'
WHERE "tmpl_type"='manual' and event_type='CHANGE_PLAYER_DATA' and publish_method='siteMsg';