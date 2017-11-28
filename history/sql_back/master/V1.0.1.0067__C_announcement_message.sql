-- auto gen by orange 2015-09-14 22:07:57

-- 消息公告表
CREATE TABLE IF NOT EXISTS announcement_message (
  "id" SERIAL4 NOT NULL PRIMARY KEY ,
  "title" varchar(100) COLLATE "default",
  "content" varchar(2000) COLLATE "default",
  "announcement_type" varchar(32) COLLATE "default",
  "release_time" timestamp(6),
  "is_read" bool
)
WITH (OIDS=FALSE)
;

ALTER TABLE announcement_message OWNER TO "postgres";

COMMENT ON TABLE "announcement_message" IS '消息公告表';

COMMENT ON COLUMN "announcement_message"."id" IS '主键id';

COMMENT ON COLUMN "announcement_message"."title" IS '标题';

COMMENT ON COLUMN "announcement_message"."content" IS '内容';

COMMENT ON COLUMN "announcement_message"."announcement_type" IS '公告类型operate.announcement_type';

COMMENT ON COLUMN "announcement_message"."release_time" IS '发布时间';

COMMENT ON COLUMN "announcement_message"."is_read" IS '是否已读';
