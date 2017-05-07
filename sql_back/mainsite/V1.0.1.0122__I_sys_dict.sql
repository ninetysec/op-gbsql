-- auto gen by cheery 2015-11-27 15:21:13
--byEagle
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'activity_type', 'first_deposit', '1', '首存送', NULL, 't'
  WHERE 'first_deposit' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'activity_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'activity_type', 'regist_send', '2', '注册送', NULL, 't'
  WHERE 'regist_send' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'activity_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'activity_type', 'deposit_send', '3', '存就送', NULL, 't'
  WHERE 'deposit_send' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'activity_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'activity_type', 'relief_fund', '4', '救济金', NULL, 't'
  WHERE 'relief_fund' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'activity_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'activity_type', 'back_water', '5', '返水优惠', NULL, 't'
  WHERE 'back_water' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'activity_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'activity_type', 'profit_loss', '6', '盈亏送', NULL, 't'
  WHERE 'profit_loss' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'activity_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'activity_type', 'effective_transaction', '7', '有效交易量', NULL, 't'
  WHERE 'effective_transaction' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'activity_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'activity_type', 'content', '8', '活动内容', NULL, 't'
  WHERE 'content' NOT IN (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'activity_type');

--byRiver
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
    SELECT 'serve', 'content_type', '1', '1', '内容审核类型:LOGO', NULL, 't'
    WHERE '1' NOT IN (SELECT dict_code FROM sys_dict WHERE module='serve' AND dict_type='content_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'serve', 'content_type', '2', '2', '内容审核类型:文案', NULL, 't'
  WHERE '2' NOT IN (SELECT dict_code FROM sys_dict WHERE module='serve' AND dict_type='content_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'serve', 'content_type', '3', '3', '内容审核类型:优惠', NULL, 't'
  WHERE '3' NOT IN (SELECT dict_code FROM sys_dict WHERE module='serve' AND dict_type='content_type');


--byOrange
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  select  'operation', 'publish_platform', 'operator', '2', '运营商', NULL, 't'
  where  'operator' not in (select dict_code from sys_dict where dict_type = 'publish_platform' and dict_code = 'operator');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  select  'operation', 'announcement_type', 'operator_announcement', '4', '运营公告', NULL, 't'
  where 'operator_announcement' not in (select dict_code from sys_dict where dict_type = 'announcement_type' and dict_code = 'operator_announcement');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  select  'operation', 'publish_platform', 'master_control', '1', '总控', NULL, 't'
  where 'master_control' not in (select dict_code from sys_dict where dict_type = 'publish_platform' and dict_code = 'master_control')
