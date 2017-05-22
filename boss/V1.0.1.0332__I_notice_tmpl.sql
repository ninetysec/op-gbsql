-- auto gen by cherry 2017-05-22 15:01:33
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'PROFIT_MAX_YELLOW', 'siteMsg', '1452751825160', 't', 'zh_CN', '站长${userName}的站点“${siteName}”盈利上限已使用${rate}%！', '站点【${siteId}】${siteName}的盈利上限已使用${rate}%！请及时关注！', 't', 'title', 'content', '2015-11-12 08:30:54.267665', '1', NULL, NULL, 't'
WHERE not EXISTS (SELECT  id FROM notice_tmpl WHERE tmpl_type='auto' AND event_type='PROFIT_MAX_YELLOW' AND publish_method='siteMsg' AND locale='zh_CN');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'PROFIT_MAX_YELLOW', 'siteMsg', '1452751825160', 't', 'en_US', '站长${userName}的站点“${siteName}”盈利上限已使用${rate}%！', '站点【${siteId}】${siteName}的盈利上限已使用${rate}%！请及时关注！', 't', 'title', 'content', '2015-11-12 08:30:54.267665', '1', NULL, NULL, 't'
WHERE not EXISTS (SELECT  id FROM notice_tmpl WHERE tmpl_type='auto' AND event_type='PROFIT_MAX_YELLOW' AND publish_method='siteMsg' AND locale='en_US');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'PROFIT_MAX_YELLOW', 'siteMsg', '1452751825160', 't', 'zh_TW', '站长${userName}的站点“${siteName}”盈利上限已使用${rate}%！', '站点【${siteId}】${siteName}的盈利上限已使用${rate}%！请及时关注！', 't', 'title', 'content', '2015-11-12 08:30:54.267665', '1', NULL, NULL, 't'
WHERE not EXISTS (SELECT  id FROM notice_tmpl WHERE tmpl_type='auto' AND event_type='PROFIT_MAX_YELLOW' AND publish_method='siteMsg' AND locale='zh_TW');