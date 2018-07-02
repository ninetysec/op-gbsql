-- auto gen by linsen 2018-06-27 17:25:09
-- 消息通知弹窗表 by linsen

CREATE TABLE IF NOT EXISTS "notice_popup" (
  "id" SERIAL4 NOT NULL,
	"user_id" int4 NOT NULL,
	"show" bool DEFAULT true NOT NULL,
CONSTRAINT "notice_popup_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE "notice_popup" IS '消息通知弹窗';

COMMENT ON COLUMN "notice_popup"."id" IS '主键';

COMMENT ON COLUMN "notice_popup"."user_id" IS '用户ID';

COMMENT ON COLUMN "notice_popup"."show" IS '是否弹窗展示，true：展示，false：不展示';