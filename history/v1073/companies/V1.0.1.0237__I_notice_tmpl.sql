-- auto gen by cherry 2016-12-27 21:03:45
UPDATE notice_tmpl SET tmpl_type='auto' ,"content"='站点【${siteId}】${siteName}的盈利上限已使用${rate}%！该站点目前盈利上限${maxProfit}，当前盈利${profit}！${view}' WHERE event_type='PROFIT_MAX_YELLOW';
UPDATE notice_tmpl SET tmpl_type='auto', "content"='站点【${siteId}】${siteName}的盈利上限已使用${rate}%，很快将达到100%，请及时关注！该站点目前盈利上限${maxProfit}，当前盈利${profit}！${view}' WHERE event_type='PROFIT_MAX_ORANGE';
UPDATE notice_tmpl SET tmpl_type='auto',"content"='站点【${siteId}】${siteName}的盈利上限已使用${rate}%，风险较高，建议您及时联系站长，提高盈利上限！该站点目前盈利上限${maxProfit}，当前盈利${profit}！${view}' WHERE event_type='PROFIT_MAX_RED';

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT'auto', 'MCENTER_PROFIT_MAX_YELLOW', 'siteMsg', '69ae337300834d2d8dcf1c01d78693cc', 't', 'zh_CN', '您的站点“${siteName}”盈利上限已使用${rate}%，请及时关注！', '您的站点“${siteName}”盈利上限已使用${rate}%，请及时关注！', 't', 'title', 'content', '2015-11-12 08:30:54.267665', '1', NULL, NULL, 't'
where NOT EXISTS(SELECT id FROM notice_tmpl WHERE tmpl_type='auto' AND event_type='PROFIT_MAX_YELLOW' AND publish_method='siteMsg' and group_code='69ae337300834d2d8dcf1c01d78693cc' and locale='zh_CN');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'MCENTER_PROFIT_MAX_ORANGE', 'siteMsg', '33ad33f0cc3e4148a095bc77f9acc490', 't', 'zh_CN', '您的站点“${siteName}”盈利上限已使用${rate}%，达到100%站点有可能被临时维护，请及时关注！', '您的站点“${siteName}”盈利上限已使用${rate}%，达到100%站点有可能被临时维护，请及时关注！', 't', 'title', 'content', '2015-11-12 08:30:54.267665', '1', NULL, NULL, 't'
where NOT EXISTS(SELECT id FROM notice_tmpl WHERE tmpl_type='auto' AND event_type='MCENTER_PROFIT_MAX_ORANGE' AND publish_method='siteMsg' and group_code='33ad33f0cc3e4148a095bc77f9acc490' and locale='zh_CN');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'MCENTER_PROFIT_MAX_RED', 'siteMsg', '07899ffeeead4584a24d1db999697ce3', 't', 'zh_CN', '您的站点“${siteName}”盈利上限已使用${rate}%，有可能被临时维护，建议您马上联系客服提高盈利上限！', '您的站点“${siteName}”盈利上限已使用${rate}%，有可能被临时维护，建议您马上联系客服提高盈利上限！', 't', 'title', 'content', '2015-11-12 08:30:54.267665', '1', NULL, NULL, 't'
where NOT EXISTS(SELECT id FROM notice_tmpl WHERE tmpl_type='auto' AND event_type='MCENTER_PROFIT_MAX_RED' AND publish_method='siteMsg' and group_code='07899ffeeead4584a24d1db999697ce3' and locale='zh_CN');
