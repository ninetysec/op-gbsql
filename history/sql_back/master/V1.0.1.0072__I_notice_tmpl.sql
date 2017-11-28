-- auto gen by kevice 2015-09-16 20:12:19

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'comet', '1441964613861-iopqwere', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'comet', '1441964613861-iopqwere', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'comet', '1441964613861-iopqwere', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'siteMsg', '1441964613861-iopqwere', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'siteMsg', '1441964613861-iopqwere', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'siteMsg', '1441964613861-iopqwere', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'email', '1441964613861-iopqwere', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'email', '1441964613861-iopqwere', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'email', '1441964613861-iopqwere', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'sms', '1441964613861-iopqwere', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'sms', '1441964613861-iopqwere', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DEPOSIT_AUDIT_SUCCESS', 'sms', '1441964613861-iopqwere', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_SUCCESS' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);




INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'comet', '1441964613861-iopqwere', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'comet', '1441964613861-iopqwere', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'comet', '1441964613861-iopqwere', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'siteMsg', '1441964613861-iopqwere', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'siteMsg', '1441964613861-iopqwere', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'siteMsg', '1441964613861-iopqwere', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'email', '1441964613861-iopqwere', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'email', '1441964613861-iopqwere', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'email', '1441964613861-iopqwere', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'sms', '1441964613861-iopqwere', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'sms', '1441964613861-iopqwere', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'WITHDRAWAL_AUDIT_SUCCESS', 'sms', '1441964613861-iopqwere', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);
    
    
    
    
INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'comet', '1441964613840-iuiutydsq', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'comet', '1441964613840-iuiutydsq', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'comet', '1441964613840-iuiutydsq', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'siteMsg', '1441964613840-iuiutydsq', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'siteMsg', '1441964613840-iuiutydsq', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'siteMsg', '1441964613840-iuiutydsq', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'email', '1441964613840-iuiutydsq', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'email', '1441964613840-iuiutydsq', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'email', '1441964613840-iuiutydsq', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'sms', '1441964613840-iuiutydsq', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'sms', '1441964613840-iuiutydsq', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_AUDIT_FAIL', 'sms', '1441964613840-iuiutydsq', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_AUDIT_FAIL' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);



INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'comet', '1441964613860-sqiuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'comet', '1441964613860-sqiuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'comet', '1441964613860-sqiuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'email', '1441964613860-sqiuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'email', '1441964613860-sqiuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'email', '1441964613860-sqiuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'sms', '1441964613860-sqiuiuty', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'sms', '1441964613860-sqiuiuty', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'WITHDRAWAL_AUDIT_FAIL', 'sms', '1441964613860-sqiuiuty', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'WITHDRAWAL_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'comet', '1441964613861-awsqiuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'comet', '1441964613861-awsqiuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'comet', '1441964613861-awsqiuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'siteMsg', '1441964613861-awsqiuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'siteMsg', '1441964613861-awsqiuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'siteMsg', '1441964613861-awsqiuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'email', '1441964613861-awsqiuiuty', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'email', '1441964613861-awsqiuiuty', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'email', '1441964613861-awsqiuiuty', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'sms', '1441964613861-awsqiuiuty', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'sms', '1441964613861-awsqiuiuty', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEPOSIT_FOR_PLAYER', 'sms', '1441964613861-awsqiuiuty', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEPOSIT_FOR_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEPOSIT_FOR_PLAYER' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);
    
    
    
    
    
INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'comet', '1441964613855-iuiutyssfd', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'comet', '1441964613855-iuiutyssfd', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'comet', '1441964613855-iuiutyssfd', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'siteMsg', '1441964613855-iuiutyssfd', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'siteMsg', '1441964613855-iuiutyssfd', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'siteMsg', '1441964613855-iuiutyssfd', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'email', '1441964613855-iuiutyssfd', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'email', '1441964613855-iuiutyssfd', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'email', '1441964613855-iuiutyssfd', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'sms', '1441964613855-iuiutyssfd', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'sms', '1441964613855-iuiutyssfd', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'manual', 'DEDUCT_MONEY_FROM_PLAYER', 'sms', '1441964613855-iuiutyssfd', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DEDUCT_MONEY_FROM_PLAYER' not in (SELECT event_type from notice_tmpl where event_type = 'DEDUCT_MONEY_FROM_PLAYER' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);





INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'comet', '1441964613856-iuiutyssfdsa', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'comet', '1441964613856-iuiutyssfdsa', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'comet', '1441964613856-iuiutyssfdsa', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'siteMsg', '1441964613856-iuiutyssfdsa', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'siteMsg', '1441964613856-iuiutyssfdsa', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'siteMsg', '1441964613856-iuiutyssfdsa', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'email', '1441964613856-iuiutyssfdsa', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'email', '1441964613856-iuiutyssfdsa', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'email', '1441964613856-iuiutyssfdsa', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'sms', '1441964613856-iuiutyssfdsa', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'sms', '1441964613856-iuiutyssfdsa', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_RABBET_SUCCESS', 'sms', '1441964613856-iuiutyssfdsa', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_RABBET_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_RABBET_SUCCESS' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);


update notice_tmpl set title='${本期结算名称}返水结算', content='本期返水已发放至您的钱包，请查收！' where event_type = 'RETURN_RABBET_SUCCESS';




INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'comet', '1441964613826-iuiutssyssfd', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'comet' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'comet', '1441964613826-iuiutssyssfd', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'comet' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'comet', '1441964613826-iuiutssyssfd', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'comet' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'siteMsg', '1441964613826-iuiutssyssfd', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'siteMsg', '1441964613826-iuiutssyssfd', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'siteMsg', '1441964613826-iuiutssyssfd', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'siteMsg' and locale = 'zh_TW' and built_in = true);


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'email', '1441964613826-iuiutssyssfd', true, 'zh_CN',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'email' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'email', '1441964613826-iuiutssyssfd', true, 'en_US',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'email' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'email', '1441964613826-iuiutssyssfd', true, 'zh_TW',
            'title', 'content', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'email' and locale = 'zh_TW' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'sms', '1441964613826-iuiutssyssfd', false, 'zh_CN',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'sms' and locale = 'zh_CN' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'sms', '1441964613826-iuiutssyssfd', false, 'en_US',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'sms' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'RETURN_COMMISSION_SUCCESS', 'sms', '1441964613826-iuiutssyssfd', false, 'zh_TW',
            'title', 'content', false, 'title', 'content', now(),
            1, null, null, true
    WHERE 'RETURN_COMMISSION_SUCCESS' not in (SELECT event_type from notice_tmpl where event_type = 'RETURN_COMMISSION_SUCCESS' and publish_method = 'sms' and locale = 'zh_TW' and built_in = true);


update notice_tmpl set title='${本期结算名称}返佣结算', content='本期返佣已发放至您的贴户，请查收！' where event_type = 'RETURN_COMMISSION_SUCCESS';