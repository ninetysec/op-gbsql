-- auto gen by cherry 2016-02-25 14:54:14
ALTER TABLE  user_bankcard DROP COLUMN IF EXISTS is_auto_match;

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'MODIFY_STATION_BILL', 'siteMsg', '46ed137324c24ce8a23a8cf135f79409', 't', 'en_US', '修改结算账单', '站长{0}已将站点{1}{2}的应付金额修改为{3}', 't', '修改结算账单', '站长{mastername}已将站点{sitename}{billname}的应付金额修改为{amountMoney}', '2015-09-18 14:39:23.462204', '1', NULL, NULL, 't'
WHERE 'MODIFY_STATION_BILL'  not in(SELECT event_type FROM notice_tmpl  WHERE tmpl_type='auto' AND publish_method='siteMsg' and locale='en_US');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'MODIFY_STATION_BILL', 'siteMsg', '46ed137324c24ce8a23a8cf135f79409', 't', 'zh_CN', '修改结算账单', '站长{0}已将站点{1}{2}的应付金额修改为{3}', 't', '修改结算账单', '站长{mastername}已将站点{sitename}{billname}的应付金额修改为{amountMoney}', '2015-09-18 14:39:23.462204', '1', NULL, NULL, 't'
WHERE 'MODIFY_STATION_BILL'  not in(SELECT event_type FROM notice_tmpl  WHERE tmpl_type='auto' AND publish_method='siteMsg' and locale='zh_CN');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'MODIFY_STATION_BILL', 'siteMsg', '46ed137324c24ce8a23a8cf135f79409', 't', 'zh_TW', '修改结算账单', '站长{0}已将站点{1}{2}的应付金额修改为{3}', 't', '修改结算账单', '站长{mastername}已将站点{sitename}{billname}的应付金额修改为{amountMoney}', '2015-09-18 14:39:23.462204', '1', NULL, NULL, 't'
WHERE 'MODIFY_STATION_BILL'  not in(SELECT event_type FROM notice_tmpl  WHERE tmpl_type='auto' AND publish_method='siteMsg' and locale='zh_TW');

select redo_sqls($$
        ALTER TABLE "player_favorable" ADD COLUMN "operator_id" int4;
 $$);

COMMENT ON COLUMN  "player_favorable"."operator_id" IS '操作人ID';

