-- auto gen by cheery 2015-12-23 16:16:02
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'DOMAIN_CHECK', 'siteMsg', '1361606215194-iuiuty1', 't', 'zh_TW', '您提交绑定/解绑运营商（站点、代理）域名${title}，已审核成功', '您提交绑定/解绑运营商（站点、代理）域名${content}，已审核成功', 't', 'title', 'content', '2015-11-12 08:30:54.267665', '1', '2015-12-21 10:11:56', NULL, 't'
WHERE 'DOMAIN_CHECK' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='siteMsg' AND locale='zh_TW');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'DOMAIN_CHECK', 'siteMsg', '1361606215194-iuiuty1', 't', 'zh_US', '您提交绑定/解绑运营商（站点、代理）域名${title}，已审核成功', '您提交绑定/解绑运营商（站点、代理）域名${content}，已审核成功', 't', 'title', 'content', '2015-11-12 08:30:54.267665', '1', '2015-12-21 10:11:56', NULL, 't'
WHERE 'DOMAIN_CHECK' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='siteMsg' AND locale='zh_US');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'DOMAIN_CHECK', 'siteMsg', '1361606215194-iuiuty1', 't', 'zh_CN', '您提交绑定/解绑运营商（站点、代理）域名${title}，已审核成功', '您提交绑定/解绑运营商（站点、代理）域名${content}，已审核成功', 't', 'title', 'content', '2015-11-12 08:30:54.267665', '1', '2015-12-21 10:11:56', NULL, 't'
WHERE 'DOMAIN_CHECK' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='siteMsg' AND locale='zh_CN');