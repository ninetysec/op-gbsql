-- auto gen by bruce 2016-09-05 10:39:41
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in", "order_num", "is_display")
  SELECT 'auto', 'ACCOUNT_NOT_EXIST', 'siteMsg', '2b801fbd304e77379393btb9bf1d6c25', 'f', 'zh_CN', '该账号不存在', '用户名输入错误,请确认后重新输入', 't', '该账号不存在', '用户名输入错误,请确认后重新输入', '2016-04-22 08:23:03.419482', '0', NULL, NULL, 't', '12', NULL
  WHERE  'ACCOUNT_NOT_EXIST' NOT IN  (SELECT event_type FROM notice_tmpl WHERE tmpl_type='auto' AND publish_method='siteMsg' AND locale='zh_CN');
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in", "order_num", "is_display")
  SELECT 'auto', 'ACCOUNT_NOT_EXIST', 'siteMsg', '2b801fbd304e77379393btb9bf1d6c25', 'f', 'en_US', '该账号不存在', '用户名输入错误,请确认后重新输入', 't', '该账号不存在', '用户名输入错误,请确认后重新输入', '2016-04-22 08:23:03.419482', '0', NULL, NULL, 't', '12', NULL
  WHERE  'ACCOUNT_NOT_EXIST' NOT IN  (SELECT event_type FROM notice_tmpl WHERE tmpl_type='auto' AND publish_method='siteMsg' AND locale='en_US');
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in", "order_num", "is_display")
  SELECT 'auto', 'ACCOUNT_NOT_EXIST', 'siteMsg', '2b801fbd304e77379393btb9bf1d6c25', 'f', 'zh_TW', '该账号不存在', '用户名输入错误,请确认后重新输入', 't', '该账号不存在', '用户名输入错误,请确认后重新输入', '2016-04-22 08:23:03.419482', '0', NULL, NULL, 't', '12', NULL
  WHERE  'ACCOUNT_NOT_EXIST' NOT IN  (SELECT event_type FROM notice_tmpl WHERE tmpl_type='auto' AND publish_method='siteMsg' AND locale='zh_TW');