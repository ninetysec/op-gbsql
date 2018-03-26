-- auto gen by linsen 2018-03-12 23:05:45

-- 创建风控数据表，风控审核表 add by steffan

CREATE TABLE if not exists  "risk_management" (
"id"  serial,
"site_id" int4 NOT NULL,
data_type varchar(8) NOT NULL,
create_user_id int4 ,
create_user_name varchar(32)  ,
create_time timestamptz(6) DEFAULT now(),
"bank_name" varchar(32) ,
"bankcard_number" varchar(36) NOT NULL,
"real_name" varchar(32),
mobile_phone varchar(300),
ip_address BIGINT,
is_deleted boolean DEFAULT false,
check_status varchar(1),
check_user_id int4,
check_time timestamptz(6) DEFAULT now(),
check_remark varchar(300)
) ;


COMMENT ON TABLE "risk_management" IS '风控审核表，数据结构和风控公共数据表一样-createBy steffan';

COMMENT ON COLUMN "risk_management"."id" IS '主键';
COMMENT ON COLUMN "risk_management"."site_id" IS '站点id';
COMMENT ON COLUMN "risk_management"."data_type" IS '数据类型:最后3为不为0，对应 套利玩家、洗水玩家、恶意玩家，1为站长标识，2为系统标识';
COMMENT ON COLUMN "risk_management"."create_user_id" IS '提交人id';
COMMENT ON COLUMN "risk_management"."create_user_name" IS '提交人user_name';
COMMENT ON COLUMN "risk_management"."create_time" IS '提交时间';
COMMENT ON COLUMN "risk_management"."bank_name" IS '银行名称';
COMMENT ON COLUMN "risk_management"."bankcard_number" IS '银行卡号';
COMMENT ON COLUMN "risk_management"."real_name" IS '真实姓名';
COMMENT ON COLUMN "risk_management"."mobile_phone" IS '手机号码';
COMMENT ON COLUMN "risk_management"."ip_address" IS 'ip地址';
COMMENT ON COLUMN "risk_management"."check_status" IS '状态0待审核，1通过，2失败';
COMMENT ON COLUMN "risk_management"."is_deleted" IS '是否删除';
COMMENT ON COLUMN "risk_management"."check_user_id" IS '审核人id';
COMMENT ON COLUMN "risk_management"."check_time" IS '审核时间';
COMMENT ON COLUMN risk_management.check_remark IS '审核备注原因';


CREATE INDEX IF not EXISTS "index_risk_management_create_time" ON "risk_management" USING btree ("create_time");
CREATE INDEX IF not EXISTS "index_risk_management_data_type" ON "risk_management" USING btree ("data_type");







CREATE TABLE if not exists  "risk_management_check" (
"id"  serial    ,
"site_id" int4 NOT NULL,
data_type varchar(8) NOT NULL,
create_user_id int4 ,
create_user_name varchar(32)  ,
create_time timestamptz(6) DEFAULT now(),
"bank_name" varchar(32) ,
"bankcard_number" varchar(36) NOT NULL,
"real_name" varchar(32),
mobile_phone varchar(300),
ip_address BIGINT,
is_deleted boolean DEFAULT false,
check_status varchar(1),
check_user_id int4,
check_time timestamptz(6) DEFAULT now(),
check_remark varchar(300)
) ;


COMMENT ON TABLE "risk_management_check" IS '风控审核表，数据结构和风控公共数据表一样-createBy steffan';

COMMENT ON COLUMN "risk_management_check"."id" IS '主键';
COMMENT ON COLUMN "risk_management_check"."site_id" IS '站点id';
COMMENT ON COLUMN "risk_management_check"."data_type" IS '数据类型:最后3为不为0，对应 套利玩家、洗水玩家、恶意玩家，1为站长标识，2为系统标识';
COMMENT ON COLUMN "risk_management_check"."create_user_id" IS '提交人id';
COMMENT ON COLUMN "risk_management_check"."create_user_name" IS '提交人user_name';
COMMENT ON COLUMN "risk_management_check"."create_time" IS '提交时间';
COMMENT ON COLUMN "risk_management_check"."bank_name" IS '银行名称';
COMMENT ON COLUMN "risk_management_check"."bankcard_number" IS '银行卡号';
COMMENT ON COLUMN "risk_management_check"."real_name" IS '真实姓名';
COMMENT ON COLUMN "risk_management_check"."mobile_phone" IS '手机号码';
COMMENT ON COLUMN "risk_management_check"."ip_address" IS 'ip地址';
COMMENT ON COLUMN "risk_management_check"."check_status" IS '状态0待审核，1通过，2失败';
COMMENT ON COLUMN "risk_management_check"."is_deleted" IS '是否删除';
COMMENT ON COLUMN "risk_management_check"."check_user_id" IS '审核人id';
COMMENT ON COLUMN "risk_management_check"."check_time" IS '审核时间';
COMMENT ON COLUMN risk_management_check.check_remark IS '审核备注原因';


CREATE INDEX IF not EXISTS "index_risk_management_check_create_time" ON "risk_management_check" USING btree ("create_time");
CREATE INDEX IF not EXISTS "index_risk_management_check_data_type" ON "risk_management_check" USING btree ("data_type");
