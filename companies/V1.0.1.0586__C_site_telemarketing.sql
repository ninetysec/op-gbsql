-- auto gen by linsen 2018-03-27 16:52:35
-- 站点电销 by steffan
CREATE TABLE IF NOT EXISTS  "site_telemarketing" (
"id" serial,
"site_id" int4 NOT NULL,
"ip" int8 ,
"url" varchar(255) ,
is_encryption BOOLEAN ,
encryption_method varchar(1),
encryption_code varchar(255) ,
"remark" varchar(300)  ,
is_deleted boolean DEFAULT false,
create_user_id int4 ,
create_user_name varchar(32)  ,
create_time timestamptz(6) DEFAULT now(),
update_user_id int4 ,
update_user_name varchar(32)  ,
update_time timestamptz(6) DEFAULT now(),
CONSTRAINT "site_telemarketing_pkey" PRIMARY KEY ("id")
) ;
COMMENT ON TABLE   "site_telemarketing" IS '站点电销--steffan';

COMMENT ON COLUMN "site_telemarketing"."id" IS '主键';
COMMENT ON COLUMN "site_telemarketing"."site_id" IS '站点id';
COMMENT ON COLUMN "site_telemarketing"."ip" IS 'ip地址';
COMMENT ON COLUMN "site_telemarketing"."url" IS 'ip电话url';
COMMENT ON COLUMN "site_telemarketing"."is_encryption" IS '是否加密';
COMMENT ON COLUMN "site_telemarketing"."encryption_method" IS '加密方式';
COMMENT ON COLUMN "site_telemarketing"."encryption_code" IS '加密代码';
COMMENT ON COLUMN "site_telemarketing"."remark" IS '备注';
COMMENT ON COLUMN "site_telemarketing"."is_deleted" IS '是否删除';
COMMENT ON COLUMN "site_telemarketing"."create_user_id" IS '提交人id';
COMMENT ON COLUMN "site_telemarketing"."create_user_name" IS '提交人user_name';
COMMENT ON COLUMN "site_telemarketing"."create_time" IS '提交时间';
COMMENT ON COLUMN "site_telemarketing"."update_user_id" IS '更新人id';
COMMENT ON COLUMN "site_telemarketing"."update_user_name" IS '更新人user_name';
COMMENT ON COLUMN "site_telemarketing"."update_time" IS '更新时间';