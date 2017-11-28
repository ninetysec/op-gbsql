-- auto gen by kevice 2015-09-11 17:12:04

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'comet', '1441964613850-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'comet', '1441964613850-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'comet', '1441964613850-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'siteMsg', '1441964613850-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'siteMsg', '1441964613850-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'siteMsg', '1441964613850-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'email', '1441964613850-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'email', '1441964613850-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'email', '1441964613850-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'sms', '1441964613850-iuiuty', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'sms', '1441964613850-iuiuty', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_RABBET', 'sms', '1441964613850-iuiuty', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_RABBET' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_RABBET' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);









INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'comet', '1441964613851-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'comet', '1441964613851-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'comet', '1441964613851-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'siteMsg', '1441964613851-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'siteMsg', '1441964613851-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'siteMsg', '1441964613851-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'email', '1441964613851-iuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'email', '1441964613851-iuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'email', '1441964613851-iuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'sms', '1441964613851-iuiuty', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'sms', '1441964613851-iuiuty', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'REFUSE_RETURN_COMMISSION', 'sms', '1441964613851-iuiuty', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'REFUSE_RETURN_COMMISSION' not in (SELECT event_type from notice_tmpl where event_type = 'REFUSE_RETURN_COMMISSION' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);