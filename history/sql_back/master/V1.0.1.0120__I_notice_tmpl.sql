-- auto gen by kevice 2015-10-14 16:37:05

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'comet', '1441124613861-iopqwersae', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'comet', '1441124613861-iopqwersae', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'comet', '1441124613861-iopqwersae', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'siteMsg', '1441124613861-iopqwersae', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'siteMsg', '1441124613861-iopqwersae', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'siteMsg', '1441124613861-iopqwersae', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'email', '1441124613861-iopqwersae', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'email', '1441124613861-iopqwersae', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'email', '1441124613861-iopqwersae', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'sms', '1441124613861-iopqwersae', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'sms', '1441124613861-iopqwersae', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'PREFERENCE_AUDIT_SUCCESS', 'sms', '1441124613861-iopqwersae', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'comet', '14419646138180-smfddgdfg', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'comet', '14419646138180-smfddgdfg', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'comet', '14419646138180-smfddgdfg', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'siteMsg', '14419646138180-smfddgdfg', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'siteMsg', '14419646138180-smfddgdfg', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'siteMsg', '14419646138180-smfddgdfg', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'email', '14419646138180-smfddgdfg', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'email', '14419646138180-smfddgdfg', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'email', '14419646138180-smfddgdfg', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'sms', '14419646138180-smfddgdfg', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'sms', '14419646138180-smfddgdfg', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'PREFERENCE_AUDIT_FAIL', 'sms', '14419646138180-smfddgdfg', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'PREFERENCE_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_FAIL' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);
