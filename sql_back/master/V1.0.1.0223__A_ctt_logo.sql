-- auto gen by cheery 2015-11-24 02:08:01

--LOGO表添加审核信息字段 add by River 2015年11月18日 星期三 11时21分59秒  --文案表添加审核不通过字段
select redo_sqls($$
   ALTER TABLE "ctt_logo" ADD COLUMN "check_user_id" int4, ADD COLUMN "check_status" varchar(255), ADD COLUMN "check_time" timestamp, ADD COLUMN "reason_title" varchar(128),ADD COLUMN "reason_content" varchar(1000);
  ALTER TABLE "ctt_document" ADD COLUMN "reason_title" varchar(128),ADD COLUMN "reason_content" varchar(1000);
$$);

COMMENT ON COLUMN "ctt_logo"."check_user_id" IS '审核人';
COMMENT ON COLUMN "ctt_logo"."check_status" IS '审核状态';
COMMENT ON COLUMN "ctt_logo"."check_time" IS '审核时间';
COMMENT ON COLUMN "ctt_logo"."reason_title" IS '失败原因标题';
COMMENT ON COLUMN "ctt_logo"."reason_content" IS '失败原因内容';

COMMENT ON COLUMN "ctt_document"."reason_title" IS '失败原因标题';
COMMENT ON COLUMN "ctt_document"."reason_content" IS ' 失败原因内容';

