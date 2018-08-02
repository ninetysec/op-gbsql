-- auto gen by linsen 2018-06-07 15:43:30
-- 广告推送时间表 by kobe
CREATE TABLE IF NOT EXISTS "carousel_push_time" (
id serial4 PRIMARY KEY,
carousel_id int4 NOT NULL,
push_time varchar(10) NOT NULL
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "carousel_push_time" IS '广告推送时间表';

COMMENT ON COLUMN "carousel_push_time"."id" IS '主键';

COMMENT ON COLUMN "carousel_push_time"."carousel_id" IS '广告ID';

COMMENT ON COLUMN "carousel_push_time"."push_time" IS '推送时间';