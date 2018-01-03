-- auto gen by cheery 2015-11-17 09:38:05
--创建公司入款各个银行所支持的货币表
CREATE TABLE IF NOT EXISTS "bank_support_currency" (
  "id" SERIAL4 NOT NULL,
  "bank_code" varchar(20) COLLATE "default" NOT NULL,
  "currency_name" varchar(50) COLLATE "default" NOT NULL,
  "currency_code" varchar(200) COLLATE "default" NOT NULL,
  CONSTRAINT "bank_support_currency_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
COMMENT ON TABLE "bank_support_currency" IS '公司入款各个银行所支持的货币--Jerry';
COMMENT ON COLUMN "bank_support_currency"."id" IS '主键';
COMMENT ON COLUMN "bank_support_currency"."bank_code" IS '银行代码';
COMMENT ON COLUMN "bank_support_currency"."currency_name" IS '货币名称';
COMMENT ON COLUMN "bank_support_currency"."currency_code" IS '货币代码';

--添加API封面字段 add by River 2015-11-17
select redo_sqls($$
    ALTER TABLE "api_i18n" ADD COLUMN "cover" varchar(255);
$$);

COMMENT ON COLUMN "api_i18n"."cover" IS '封面';

--添加字典数据 add by River 2015-11-17
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'game', 'status', 'disable', '3', '游戏状态：停用', NULL, 't'
  WHERE 'disable' not in (SELECT dict_code from sys_dict where module = 'game' and dict_type = 'status');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'content', 'check_status', '0', '1', '审核状态：待审核', NULL, 't'
  WHERE '0' not in (SELECT dict_code from sys_dict where module = 'content' and dict_type = 'check_status');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'content', 'check_status', '1', '2', '审核状态：审核通过', NULL, 't'
  WHERE '1' not in (SELECT dict_code from sys_dict where module = 'content' and dict_type = 'check_status');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'content', 'check_status', '2', '3', '审核状态：审核失败', NULL, 't'
  WHERE '2' not in (SELECT dict_code from sys_dict where module = 'content' and dict_type = 'check_status');
