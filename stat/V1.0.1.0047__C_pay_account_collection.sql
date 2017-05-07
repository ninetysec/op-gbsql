-- auto gen by cherry 2016-10-24 21:56:11
CREATE TABLE IF NOT EXISTS pay_account_collection (

id serial4 NOT NULL,

comp_id int4,

master_id int4,

site_id int4 NOT NULL,

site_name varchar COLLATE "default",

pay_account_id int4 NOT NULL,

pay_name varchar(100) COLLATE "default",

account varchar(200) COLLATE "default",

full_name varchar(200) COLLATE "default",

disable_amount int4,

pay_key varchar(200) COLLATE "default",

status varchar COLLATE "default" DEFAULT 1,

create_time timestamp(6),

create_user int4,

type varchar(50) COLLATE "default" DEFAULT 1,

account_type varchar(50) COLLATE "default" DEFAULT 1,

bank_code varchar(50) COLLATE "default",

pay_url varchar(200) COLLATE "default",

code varchar(10) COLLATE "default",

deposit_count int4 DEFAULT 0,

deposit_total numeric(20,2) DEFAULT 0,

deposit_default_count int4 DEFAULT 0,

deposit_default_total numeric(20,2) DEFAULT 0,

effective_minutes int4,

single_deposit_min int4,

single_deposit_max int4,

frozen_time timestamp(6),

channel_json text COLLATE "default" DEFAULT ''::text,

full_rank bool,

custom_bank_name varchar(32) COLLATE "default",

open_acount_name varchar(100) COLLATE "default",

qr_code_url varchar(200) COLLATE "default",

remark varchar(512) COLLATE "default",

CONSTRAINT pay_account_collection_pkey PRIMARY KEY (id),

CONSTRAINT pay_account_collection_uk UNIQUE (site_id, pay_account_id)

)

WITH (OIDS=FALSE)

;


COMMENT ON TABLE pay_account_collection IS '收款账户汇总表--Leisure';

COMMENT ON COLUMN pay_account_collection.site_id IS '站点ID';

COMMENT ON COLUMN pay_account_collection.pay_account_id IS 'pay_account表中ID';

COMMENT ON COLUMN pay_account_collection.pay_name IS '账户名称';

COMMENT ON COLUMN pay_account_collection.account IS '账号';

COMMENT ON COLUMN pay_account_collection.full_name IS '姓名';

COMMENT ON COLUMN pay_account_collection.disable_amount IS '停用金额';

COMMENT ON COLUMN pay_account_collection.pay_key IS 'Key';

COMMENT ON COLUMN pay_account_collection.status IS '状态(1使用中；2已停用；3被冻结；4已删除)(字典表pay_account_status)';

COMMENT ON COLUMN pay_account_collection.create_time IS '创建时间';

COMMENT ON COLUMN pay_account_collection.create_user IS '创建人';

COMMENT ON COLUMN pay_account_collection.type IS '类型（1公司入款；2线上支付）(字典表pay_account_type)';

COMMENT ON COLUMN pay_account_collection.account_type IS '账户类型（1银行账户；2第三方账户）(字典表pay_account_account_type)';

COMMENT ON COLUMN pay_account_collection.bank_code IS '渠道(bank表的bank_name）';

COMMENT ON COLUMN pay_account_collection.pay_url IS '支付URL地址';

COMMENT ON COLUMN pay_account_collection.code IS '代号';

COMMENT ON COLUMN pay_account_collection.deposit_count IS '累计入款次数';

COMMENT ON COLUMN pay_account_collection.deposit_total IS '累计入款金额';

COMMENT ON COLUMN pay_account_collection.deposit_default_count IS '一个周期内累计入款次数';

COMMENT ON COLUMN pay_account_collection.deposit_default_total IS '一个周期内累计入款金额';

COMMENT ON COLUMN pay_account_collection.effective_minutes IS '有效分钟数';

COMMENT ON COLUMN pay_account_collection.single_deposit_min IS '单笔存款最小值';

COMMENT ON COLUMN pay_account_collection.single_deposit_max IS '单笔存款最大值';

COMMENT ON COLUMN pay_account_collection.frozen_time IS '冻结时间';

COMMENT ON COLUMN pay_account_collection.channel_json IS '第三方接口的参数json[{column:字段,value:值}]';

COMMENT ON COLUMN pay_account_collection.full_rank IS '全部层级';

COMMENT ON COLUMN pay_account_collection.custom_bank_name IS '第三方自定义名称';

COMMENT ON COLUMN pay_account_collection.open_acount_name IS '开户行';

COMMENT ON COLUMN pay_account_collection.qr_code_url IS '第三方入款账户二维码图片路径';

COMMENT ON COLUMN pay_account_collection.remark IS '备注内容';

DROP FUNCTION IF EXISTS gb_pay_account_collect(comp_url text);
CREATE OR REPLACE FUNCTION gb_pay_account_collect(comp_url text)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/09/21  Chan     创建此函数: 收集各站点pay_account
--v1.01  2016/10/24  Leisure  关联sys_site，增加comp_id, master_id字段
*/
DECLARE
	rec 	record;
  rec_ds record;
  site_url text;
	pc_id int;

BEGIN

	TRUNCATE TABLE pay_account_collection;

	FOR rec_ds IN
		SELECT comp_id, master_id, site_id, site_name, ip, port, dbname, username, password
		  FROM dblink(comp_url,
		              'SELECT parent_id comp_id, sys_user_id master_id, d.id site_id, d.name site_name,
		                      ip, port, dbname, username, password
		                 FROM sys_site s, sys_datasource d where s.id = d.id
		                ORDER BY site_id')
		               AS si( comp_id INT, master_id INT, site_id INT, site_name varchar(16),
		                      ip varchar(15), port int4, dbname varchar(32), username varchar(32), password varchar(128)
		              )
	LOOP
		site_url = 'host=' || rec_ds.ip || ' port=' || rec_ds.port || ' dbname=' || rec_ds.dbname || ' user=' || rec_ds.username || ' password=' || rec_ds.password;

		RAISE INFO '正在收集站点：%', rec_ds.username;
		FOR rec IN
			SELECT "id", pay_name, account, full_name, disable_amount, pay_key,
				status, create_time, create_user, type, account_type, bank_code, pay_url,
				code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
				effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
				full_rank, custom_bank_name, open_acount_name, qr_code_url, remark
			FROM dblink(site_url,
				'select id, pay_name, account, full_name, disable_amount, pay_key,
				status, create_time, create_user, type, account_type, bank_code, pay_url,
				code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
				effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
				full_rank, custom_bank_name, open_acount_name, qr_code_url, remark from pay_account')
					  AS a("id" int4, pay_name varchar(100), account varchar(200), full_name varchar(200), disable_amount int4, pay_key varchar(200),
				status varchar, create_time timestamp(6), create_user int4, type varchar(50), account_type varchar(50), bank_code varchar(50), pay_url varchar(200),
				code varchar(10), deposit_count int4, deposit_total numeric(20,2), deposit_default_count int4, deposit_default_total numeric(20,2),
				effective_minutes int4, single_deposit_min int4, single_deposit_max int4, frozen_time timestamp(6), channel_json text,
				full_rank bool, custom_bank_name varchar(32), open_acount_name varchar(100), qr_code_url varchar(200), remark varchar(512))

		LOOP
			raise info 'id = %, pay_name = %', rec."id", rec.pay_name;

			INSERT INTO pay_account_collection (comp_id, master_id, site_id, site_name, pay_account_id, pay_name, account, full_name, disable_amount, pay_key,
				status, create_time, create_user, type, account_type, bank_code, pay_url,
				code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
				effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
				full_rank, custom_bank_name, open_acount_name, qr_code_url, remark
			) VALUES (
				rec_ds.comp_id, rec_ds.master_id, rec_ds.site_id, rec_ds.site_name, rec.id, rec.pay_name, rec.account, rec.full_name, rec.disable_amount, rec.pay_key,
				rec.status, rec.create_time, rec.create_user, rec.type, rec.account_type, rec.bank_code, rec.pay_url,
				rec.code, rec.deposit_count, rec.deposit_total, rec.deposit_default_count, rec.deposit_default_total,
				rec.effective_minutes, rec.single_deposit_min, rec.single_deposit_max, rec.frozen_time, rec.channel_json,
				rec.full_rank, rec.custom_bank_name, rec.open_acount_name, rec.qr_code_url, rec.remark
			) RETURNING "id" into pc_id;
			raise info 'pay_account_collection.新增.键值 = %', pc_id;

		END LOOP;
	END LOOP;
		raise info '统计 % END', rec_ds.site_name;

END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION gb_pay_account_collect(comp_url text) IS 'Chan-收集各站点收款账户';