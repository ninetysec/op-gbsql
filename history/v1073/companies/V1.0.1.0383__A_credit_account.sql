-- auto gen by cherry 2017-08-05 10:19:23
  select redo_sqls($$
        ALTER TABLE credit_account ADD COLUMN pay_types varchar(32);
				ALTER TABLE credit_account ALTER COLUMN sort type int4;
	      ALTER TABLE credit_record ADD COLUMN pay_type varchar(2);
	      ALTER TABLE credit_record ADD COLUMN bank_name varchar(32);
	      ALTER TABLE credit_record ADD COLUMN pay_user_id int4;
	      ALTER TABLE credit_record ADD COLUMN quota NUMERIC(20,2);
	      ALTER TABLE sys_site ADD COLUMN default_profit NUMERIC(20,2);
	      ALTER TABLE sys_site ADD COLUMN profit_time TIMESTAMP;
	      ALTER TABLE credit_record ADD COLUMN currency varchar(30);
	      ALTER TABLE credit_record add COLUMN external_order_no varchar(64);
      $$);

COMMENT ON COLUMN credit_account.pay_types is '收款账号可支付类型以逗号分隔,其中1-押金 2-报表';
COMMENT on COLUMN credit_record.pay_type is '支付类型：1-押金 2-报表';
COMMENT on COLUMN credit_record.bank_name is '支付银行';
COMMENT on COLUMN credit_record.pay_user_id is '支付人id';
COMMENT on COLUMN credit_record.quota is '支付后的额度';
COMMENT on COLUMN sys_site.default_profit is '默认额度';
COMMENT ON COLUMN sys_site.profit_time is '额度超出时间';
COMMENT on COLUMN credit_record.currency is '货币符号';
COMMENT ON COLUMN credit_record.external_order_no is '外部交易号';

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'credit', 'pay_type', '1', '1', '买分支付类型：1-押金', NULL, 't'
WHERE not EXISTS(SELECT id FROM sys_dict WHERE module='credit' AND dict_type='pay_type' AND dict_code='1');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'credit', 'pay_type', '2', '2', '买分支付类型：2-账单', NULL, 't'
WHERE not EXISTS(SELECT id FROM sys_dict WHERE module='credit' AND dict_type='pay_type' AND dict_code='2');

CREATE TABLE if not EXISTS "credit_account_currency" (
"id" serial4 NOT NULL PRIMARY key,
"credit_account_id" int4 NOT NULL,
"currency_code" varchar(50) COLLATE "default" NOT NULL,
CONSTRAINT "u_credit_account_currency" UNIQUE ("credit_account_id", "currency_code")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE "credit_account_currency" IS '收款账户对应币种表';

COMMENT ON COLUMN "credit_account_currency"."credit_account_id" IS '收款账户表ID';

COMMENT ON COLUMN "credit_account_currency"."currency_code" IS '币种表code(site_currency)';

CREATE INDEX if not EXISTS "fk_credit_account_currency_credit_account_id" ON "credit_account_currency" USING btree (credit_account_id);
