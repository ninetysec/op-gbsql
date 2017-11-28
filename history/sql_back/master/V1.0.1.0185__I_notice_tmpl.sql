-- auto gen by tom 2015-11-12 16:06:48
-- 账号冻结
INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'comet', '1361606215101-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'comet', '1361606215101-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'comet', '1361606215101-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'siteMsg', '1361606215101-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'siteMsg', '1361606215101-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'siteMsg', '1361606215101-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'email', '1361606215101-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'email', '1361606215101-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'email', '1361606215101-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'sms', '1361606215101-iuiuty', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'sms', '1361606215101-iuiuty', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_FREEZON', 'sms', '1361606215101-iuiuty', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_FREEZON' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);




-- 余额冻结

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'comet', '1361606215102-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'comet', '1361606215102-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'comet', '1361606215102-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'siteMsg', '1361606215102-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'siteMsg', '1361606215102-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'siteMsg', '1361606215102-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'email', '1361606215102-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'email', '1361606215102-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'email', '1361606215102-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'sms', '1361606215102-iuiuty', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'sms', '1361606215102-iuiuty', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'BALANCE_FREEZON', 'sms', '1361606215102-iuiuty', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'BALANCE_FREEZON' not in (SELECT event_type from notice_tmpl where event_type = 'BALANCE_FREEZON' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);



-- 账号停用

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'comet', '1361606215103-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'comet', '1361606215103-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'comet', '1361606215103-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'siteMsg', '1361606215103-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'siteMsg', '1361606215103-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'siteMsg', '1361606215103-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'email', '1361606215103-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'email', '1361606215103-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'email', '1361606215103-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'sms', '1361606215103-iuiuty', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'sms', '1361606215103-iuiuty', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'ACCOUNT_STOP', 'sms', '1361606215103-iuiuty', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACCOUNT_STOP' not in (SELECT event_type from notice_tmpl where event_type = 'ACCOUNT_STOP' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);



-- 拒绝提现

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'comet', '1361606215104-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'comet', '1361606215104-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'comet', '1361606215104-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'siteMsg', '1361606215104-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'siteMsg', '1361606215104-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'siteMsg', '1361606215104-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'email', '1361606215104-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'email', '1361606215104-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'email', '1361606215104-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'sms', '1361606215104-iuiuty', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'sms', '1361606215104-iuiuty', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_WITHDRAWAL', 'sms', '1361606215104-iuiuty', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_WITHDRAWAL' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);


update notice_tmpl set active=true where event_type='DEPOSIT_FOR_PLAYER';