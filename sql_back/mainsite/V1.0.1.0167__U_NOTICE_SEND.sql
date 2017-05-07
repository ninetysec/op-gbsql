-- auto gen by mark 2015-12-22 15:25:22
select redo_sqls($$
ALTER TABLE "notice_send"
ADD COLUMN "actual_receiver" varchar(64);

COMMENT ON COLUMN "notice_send"."actual_receiver" IS '实际接收者：目前仅支持邮件发送方式，存储的是实际邮箱地址。';
$$);