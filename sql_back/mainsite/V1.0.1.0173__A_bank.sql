-- auto gen by cheery 2015-12-23 16:48:29

-- bank 表相关修改
select redo_sqls($$
  ALTER TABLE "bank" ADD COLUMN "bank_short_name" varchar(32);
  ALTER TABLE "bank" ADD COLUMN "bank_icon_simplify" varchar(100);
  ALTER TABLE "bank" ADD COLUMN "bank_short_name2" varchar(32) ;
  ALTER TABLE "bank" ADD COLUMN "is_use" bool DEFAULT 'f';

  ALTER TABLE "sys_currency" ADD COLUMN "currency_sign" varchar(32);
$$);

COMMENT ON COLUMN "bank"."bank_icon" IS '完整logo';

COMMENT ON COLUMN "bank"."bank_icon_simplify"  IS '支付接口图标简图';

COMMENT ON COLUMN "bank"."bank_short_name" IS '支付接口一级简称';

COMMENT ON COLUMN "bank"."bank_short_name2" IS '支付接口二级简称';

COMMENT ON COLUMN "bank"."is_use" IS '是否启用';

-- sys_currency表相关修改
COMMENT ON COLUMN "sys_currency"."currency_sign" IS '货币符号';

--文案类型相关字典
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'content', 'carousel_type', 'carousel_type_api', '3', '广告类别-api', NULL, 't'
WHERE 'carousel_type_api' NOT in (SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='carousel_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'content', 'document_type', 'aboutUs', '1', '关于我们', NULL, 't'
WHERE 'aboutUs' NOT in (SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='document_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'content', 'document_type', 'gameHelp', '2', '游戏帮助', NULL, 't'
WHERE 'gameHelp' NOT in (SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='document_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'document_type', 'cooperation', '3', '代理合作', NULL, 't'
WHERE 'cooperation' NOT in (SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='document_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'content', 'document_type', 'responsibility', '4', '责任声明', NULL, 't'
WHERE 'responsibility' NOT in (SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='document_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'content', 'document_type', 'gameAnnouncement', '5', '游戏公告', NULL, 't'
WHERE 'gameAnnouncement' NOT in (SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='document_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'document_type', 'platformAnnouncement', '6', '平台公告', NULL, 't'
WHERE 'platformAnnouncement' NOT in (SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='document_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'content', 'document_type', 'apiHelp', '7', '各游戏帮助', NULL, 't'
WHERE 'apiHelp' NOT in (SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='document_type');

