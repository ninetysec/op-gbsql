-- auto gen by cherry 2016-01-06 14:21:21
DROP VIEW IF EXISTS v_notice_email_rank;
CREATE OR REPLACE VIEW v_notice_email_rank AS
 SELECT a.id,
    b.rankids,
    a.name,
    a.built_in,
    a.create_time,
    a.status,
    a.email_account,
    a.account_password,
    a.send_count,
    a.server_address,
    a.server_port,
    b.account,
    b.rankname
   FROM (( SELECT DISTINCT (notice_email_interface.status)::integer AS id,
            notice_email_interface.name,
            notice_email_interface.create_time,
            notice_email_interface.account_password,
            notice_email_interface.status,
            notice_email_interface.email_account,
            notice_email_interface.built_in,
            notice_email_interface.send_count,
            notice_email_interface.server_address,
            notice_email_interface.server_port
           FROM notice_email_interface) a
     JOIN ( SELECT notice_email_interface.email_account AS account,
            string_agg(((notice_email_interface.user_group_id)::character varying)::text, ','::text) AS rankids,
            string_agg((player_rank.rank_name)::text, ','::text) AS rankname
           FROM (notice_email_interface
             JOIN player_rank ON ((notice_email_interface.user_group_id = player_rank.id)))
          GROUP BY notice_email_interface.email_account) b ON (((a.email_account)::text = (b.account)::text)));

DELETE FROM notice_tmpl WHERE event_type='FORCE_KICK_OUT';

DELETE FROM sys_param WHERE param_type='teg_setting_agent';

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT  'auto', 'FORCE_KICK_OUT', 'siteMsg', '59c28bf530784b759136e87dd26879c1', 't', 'zh_CN', '重复登录', '当前您的账号在另一个地点登录，您已被迫下线，该地点IP为${ip}。若这不是您本人操作，很可能您的密码已经泄露，建议您立即修改密码。如有任何疑问，请及时联系在线客服！', 'f', NULL, NULL, '2016-01-04 07:08:49.748994', '0', NULL, NULL, 't'
WHERE 'FORCE_KICK_OUT' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='siteMsg' AND locale='zh_CN' AND title='重复登录');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT  'auto', 'FORCE_KICK_OUT', 'siteMsg', '59c28bf530784b759136e87dd26879c1', 't', 'zh_TW', '重复登录', '当前您的账号在另一个地点登录，您已被迫下线，该地点IP为${ip}。若这不是您本人操作，很可能您的密码已经泄露，建议您立即修改密码。如有任何疑问，请及时联系在线客服！', 'f', NULL, NULL, '2016-01-04 07:08:49.757687', '0', NULL, NULL, 't'
WHERE 'FORCE_KICK_OUT' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='siteMsg' AND locale='zh_TW' AND title='重复登录');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT   'auto', 'FORCE_KICK_OUT', 'siteMsg', '59c28bf530784b759136e87dd26879c1', 't', 'en_US', '重复登录', '当前您的账号在另一个地点登录，您已被迫下线，该地点IP为${ip}。若这不是您本人操作，很可能您的密码已经泄露，建议您立即修改密码。如有任何疑问，请及时联系在线客服！', 'f', NULL, NULL, '2016-01-04 07:08:49.766572', '0', NULL, NULL, 't'
WHERE 'FORCE_KICK_OUT' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='siteMsg' AND locale='en_US' AND title='重复登录');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT  'auto', 'FORCE_KICK_OUT', 'sms', '59c28bf530784b759136e87dd26879c1', 't', 'zh_CN', '重复登录', '当前您的账号在另一个地点登录，您已被迫下线，该地点IP为${ip}。若这不是您本人操作，很可能您的密码已经泄露，建议您立即修改密码。如有任何疑问，请及时联系在线客服！', 'f', NULL, NULL, '2016-01-04 07:08:49.7754', '0', NULL, NULL, 't'
WHERE 'FORCE_KICK_OUT' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='sms' AND locale='zh_CN' AND title='重复登录');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'FORCE_KICK_OUT', 'sms', '59c28bf530784b759136e87dd26879c1', 't', 'zh_TW', '重复登录', '当前您的账号在另一个地点登录，您已被迫下线，该地点IP为${ip}。若这不是您本人操作，很可能您的密码已经泄露，建议您立即修改密码。如有任何疑问，请及时联系在线客服！', 'f', NULL, NULL, '2016-01-04 07:08:49.783438', '0', NULL, NULL, 't'
WHERE 'FORCE_KICK_OUT' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='sms' AND locale='zh_TW' AND title='重复登录');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT  'auto', 'FORCE_KICK_OUT', 'sms', '59c28bf530784b759136e87dd26879c1', 't', 'en_US', '重复登录', '当前您的账号在另一个地点登录，您已被迫下线，该地点IP为${ip}。若这不是您本人操作，很可能您的密码已经泄露，建议您立即修改密码。如有任何疑问，请及时联系在线客服！', 'f', NULL, NULL, '2016-01-04 07:08:49.79175', '0', NULL, NULL, 't'
WHERE 'FORCE_KICK_OUT' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='sms' AND locale='en_US' AND title='重复登录');


INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT  'auto', 'FORCE_KICK_OUT', 'email', '59c28bf530784b759136e87dd26879c1', 't', 'zh_CN', '重复登录', '当前您的账号在另一个地点登录，您已被迫下线，该地点IP为${ip}。若这不是您本人操作，很可能您的密码已经泄露，建议您立即修改密码。如有任何疑问，请及时联系在线客服！', 'f', NULL, NULL, '2016-01-04 07:08:49.79929', '0', NULL, NULL, 't'
WHERE  'FORCE_KICK_OUT' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='zh_CN' AND title='重复登录');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'FORCE_KICK_OUT', 'email', '59c28bf530784b759136e87dd26879c1', 't', 'zh_TW', '重复登录', '当前您的账号在另一个地点登录，您已被迫下线，该地点IP为${ip}。若这不是您本人操作，很可能您的密码已经泄露，建议您立即修改密码。如有任何疑问，请及时联系在线客服！', 'f', NULL, NULL, '2016-01-04 07:08:49.808244', '0', NULL, NULL, 't'
WHERE  'FORCE_KICK_OUT' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='zh_TW' AND title='重复登录');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT  'auto', 'FORCE_KICK_OUT', 'email', '59c28bf530784b759136e87dd26879c1', 't', 'en_US', '重复登录', '当前您的账号在另一个地点登录，您已被迫下线，该地点IP为${ip}。若这不是您本人操作，很可能您的密码已经泄露，建议您立即修改密码。如有任何疑问，请及时联系在线客服！', 'f', NULL, NULL, '2016-01-04 07:08:49.816749', '0', NULL, NULL, 't'
WHERE  'FORCE_KICK_OUT' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='en_US' AND title='重复登录');







