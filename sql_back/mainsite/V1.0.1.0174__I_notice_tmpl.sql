-- auto gen by cheery 2015-12-23 17:23:14
INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DOCUMENT_AUDIT_SUCCESS', 'siteMsg', 'eb906e08456f45d38bbedd3e38e90235', true, 'zh_CN',
            '您发布的文案“${title}”，已审核成功', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的文案<span class="co-green ft-bold">审核成功</span>，将会在站点正常展示！</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>文案名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DOCUMENT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_CN');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DOCUMENT_AUDIT_SUCCESS', 'siteMsg', 'eb906e08456f45d38bbedd3e38e90235', true, 'zh_TW',
            '您发布的文案“${title}”，已审核成功', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的文案<span class="co-green ft-bold">审核成功</span>，将会在站点正常展示！</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>文案名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DOCUMENT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_TW');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DOCUMENT_AUDIT_SUCCESS', 'siteMsg', 'eb906e08456f45d38bbedd3e38e90235', true, 'en_US',
            '您发布的文案“${title}”，已审核成功', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的文案<span class="co-green ft-bold">审核成功</span>，将会在站点正常展示！</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>文案名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DOCUMENT_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where  publish_method = 'siteMsg' and locale = 'en_US');


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DOCUMENT_AUDIT_FAIL', 'siteMsg', '7ad16ca7e2964748a6a4370894c74a5b', true, 'zh_CN',
            '您发布的文案“${title}”，审核失败', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的文案<span class="co-orange ft-bold">审核失败</span>，将不会再站点展示，以下为审核失败的原因，您可调整后再重新上传。</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>文案名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd><dd class="form-group clearfix"><b>失败原因：</b>${reasonContent}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DOCUMENT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_CN');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DOCUMENT_AUDIT_FAIL', 'siteMsg', '7ad16ca7e2964748a6a4370894c74a5b', true, 'zh_TW',
            '您发布的文案“${title}”，审核失败', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的文案<span class="co-orange ft-bold">审核失败</span>，将不会再站点展示，以下为审核失败的原因，您可调整后再重新上传。</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>文案名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd><dd class="form-group clearfix"><b>失败原因：</b>${reasonContent}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DOCUMENT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_TW');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'DOCUMENT_AUDIT_FAIL', 'siteMsg', '7ad16ca7e2964748a6a4370894c74a5b', true, 'en_US',
            '您发布的文案“${title}”，审核失败', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的文案<span class="co-orange ft-bold">审核失败</span>，将不会再站点展示，以下为审核失败的原因，您可调整后再重新上传。</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>文案名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd><dd class="form-group clearfix"><b>失败原因：</b>${reasonContent}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'DOCUMENT_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where event_type = 'DOCUMENT_AUDIT_FAIL' and publish_method = 'siteMsg' and locale = 'en_US' and built_in = true);

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'LOGO_AUDIT_SUCCESS', 'siteMsg', '9fa3c504c9394405b47951ba07df476d', true, 'zh_CN',
            '您发布的站点logo“${title}”，已审核成功', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的logo<span class="co-green ft-bold">审核成功</span>，将会在站点正常展示！</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>logo名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'LOGO_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_CN');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'LOGO_AUDIT_SUCCESS', 'siteMsg', '9fa3c504c9394405b47951ba07df476d', true, 'zh_TW',
            '您发布的站点logo“${title}”，已审核成功', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的logo<span class="co-green ft-bold">审核成功</span>，将会在站点正常展示！</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>logo名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'LOGO_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_TW');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'LOGO_AUDIT_SUCCESS', 'siteMsg', '9fa3c504c9394405b47951ba07df476d', true, 'en_US',
            '您发布的站点logo“${title}”，已审核成功', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的logo<span class="co-green ft-bold">审核成功</span>，将会在站点正常展示！</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>logo名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'LOGO_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'en_US' );

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'LOGO_AUDIT_FAIL', 'siteMsg', '8b76d914ab2a42eb8b09fc8d78bacd1f', true, 'zh_CN',
            '您发布的站点logo“${title}”，审核失败', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的logo<span class="co-orange ft-bold">审核失败</span>，将不会再站点展示，以下为审核失败的原因，您可调整后再重新上传。</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>logo名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd><dd class="form-group clearfix"><b>失败原因：</b>${reasonContent}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'LOGO_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_CN' );

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'LOGO_AUDIT_FAIL', 'siteMsg', '8b76d914ab2a42eb8b09fc8d78bacd1f', true, 'zh_TW',
            '您发布的站点logo“${title}”，审核失败', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的logo<span class="co-orange ft-bold">审核失败</span>，将不会再站点展示，以下为审核失败的原因，您可调整后再重新上传。</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>logo名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd><dd class="form-group clearfix"><b>失败原因：</b>${reasonContent}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'LOGO_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_TW');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'LOGO_AUDIT_FAIL', 'siteMsg', '8b76d914ab2a42eb8b09fc8d78bacd1f', true, 'en_US',
            '您发布的站点logo“${title}”，审核失败', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的logo<span class="co-orange ft-bold">审核失败</span>，将不会再站点展示，以下为审核失败的原因，您可调整后再重新上传。</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>logo名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd><dd class="form-group clearfix"><b>失败原因：</b>${reasonContent}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'LOGO_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'en_US');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'ACTIVITY_AUDIT_SUCCESS', 'siteMsg', '0e0024bf7af143408ee98a180077375d', true, 'zh_CN',
            '您发布的优惠活动“${title}”，已审核成功', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的优惠活动<span class="co-green ft-bold">审核成功</span>，将会在站点正常展示！</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>活动名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACTIVITY_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_CN');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'ACTIVITY_AUDIT_SUCCESS', 'siteMsg', '0e0024bf7af143408ee98a180077375d', true, 'zh_TW',
            '您发布的优惠活动“${title}”，已审核成功', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的优惠活动<span class="co-green ft-bold">审核成功</span>，将会在站点正常展示！</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>活动名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACTIVITY_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_TW');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'ACTIVITY_AUDIT_SUCCESS', 'siteMsg', '0e0024bf7af143408ee98a180077375d', true, 'en_US',
            '您发布的优惠活动“${title}”，已审核成功', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的优惠活动<span class="co-green ft-bold">审核成功</span>，将会在站点正常展示！</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>活动名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACTIVITY_AUDIT_SUCCESS' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'en_US');


INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'ACTIVITY_AUDIT_FAIL', 'siteMsg', '2c777a8e7af440c8b8b13dd1ed6d4bdc', true, 'zh_CN',
            '您发布的优惠活动“${title}”，审核失败', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的优惠活动<span class="co-orange ft-bold">审核失败</span>，将不会展示给玩家，以下为审核失败的原因，您可调整后再重新发布。</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>活动名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd><dd class="form-group clearfix"><b>失败原因：</b>${reasonContent}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACTIVITY_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_CN');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'ACTIVITY_AUDIT_FAIL', 'siteMsg', '2c777a8e7af440c8b8b13dd1ed6d4bdc', true, 'zh_TW',
            '您发布的优惠活动“${title}”，审核失败', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的优惠活动<span class="co-orange ft-bold">审核失败</span>，将不会展示给玩家，以下为审核失败的原因，您可调整后再重新发布。</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>活动名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd><dd class="form-group clearfix"><b>失败原因：</b>${reasonContent}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACTIVITY_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'zh_TW');

INSERT INTO notice_tmpl(
            tmpl_type, event_type, publish_method, group_code, active,
            locale, title, content, default_active, default_title, default_content,
            create_time, create_user, update_time, update_user, built_in)
    SELECT 'auto', 'ACTIVITY_AUDIT_FAIL', 'siteMsg', '2c777a8e7af440c8b8b13dd1ed6d4bdc', true, 'en_US',
            '您发布的优惠活动“${title}”，审核失败', '<div class="modal-body"><dd class="m-t m-b line-hi34">您发布的优惠活动<span class="co-orange ft-bold">审核失败</span>，将不会展示给玩家，以下为审核失败的原因，您可调整后再重新发布。</dd><div class="gray-chunk clearfix"><dd class="form-group clearfix"><b>活动名称：</b><a href="javascript:void(0)">${title}</a></dd><dd class="form-group clearfix"><b>提交时间：</b>${submitTime}</dd><dd class="form-group clearfix"><b>失败原因：</b>${reasonContent}</dd></div></div>', true, 'title', 'content', now(),
            1, null, null, true
    WHERE 'ACTIVITY_AUDIT_FAIL' not in (SELECT event_type from notice_tmpl where publish_method = 'siteMsg' and locale = 'en_US' );


