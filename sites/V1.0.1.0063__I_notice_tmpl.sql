-- auto gen by cherry 2016-03-15 18:33:36
INSERT INTO notice_tmpl ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT  'manual', 'CHANGE_PLAYER_DATA', 'siteMsg', '1441964613850-iuiuty', 't', 'zh_CN', '您的个人已被管理员修改，请及时确认！', '管理员在后台修改了您的个人资料，请及时确认！若非您主动申请修改，请及时联系客服处理！', 't', '您的个人已被管理员修改，请及时确认！', '管理员在后台修改了您的个人资料，请及时确认！若非您主动申请修改，请及时联系客服处理！', '2015-09-13 15:49:21.680954', '1', '2015-10-19 06:29:00.189604', '2', 't'
WHERE 'CHANGE_PLAYER_DATA' not in(SELECT event_type FROM notice_tmpl WHERE tmpl_type='manual' and publish_method='siteMsg' and locale='zh_CN');

INSERT INTO notice_tmpl ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'manual', 'CHANGE_PLAYER_DATA', 'siteMsg', '1441964613850-iuiuty', 't', 'en_US', '您的个人已被管理员修改，请及时确认！', '管理员在后台修改了您的个人资料，请及时确认！若非您主动申请修改，请及时联系客服处理！', 't', '您的个人已被管理员修改，请及时确认！', '管理员在后台修改了您的个人资料，请及时确认！若非您主动申请修改，请及时联系客服处理！', '2015-09-13 15:49:21.680954', '1', '2015-10-19 06:29:00.195857', '2', 't'
WHERE 'CHANGE_PLAYER_DATA' not in(SELECT event_type FROM notice_tmpl WHERE tmpl_type='manual' and publish_method='siteMsg' and locale='en_US');

INSERT INTO notice_tmpl ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT  'manual', 'CHANGE_PLAYER_DATA', 'siteMsg', '1441964613850-iuiuty', 't', 'zh_TW', '您的个人已被管理员修改，请及时确认！', '管理员在后台修改了您的个人资料，请及时确认！若非您主动申请修改，请及时联系客服处理！', 't', '您的个人已被管理员修改，请及时确认！', '管理员在后台修改了您的个人资料，请及时确认！若非您主动申请修改，请及时联系客服处理！', '2015-09-13 15:49:21.680954', '1', '2015-10-19 06:29:00.216696', '2', 't'
WHERE 'CHANGE_PLAYER_DATA' not in(SELECT event_type FROM notice_tmpl WHERE tmpl_type='manual' and publish_method='siteMsg' and locale='zh_TW');
