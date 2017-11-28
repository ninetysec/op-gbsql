-- auto gen by cheery 2015-10-25 11:22:52
CREATE TABLE IF NOT EXISTS "notice_sign" (
  "id" SERIAL4 NOT NULL PRIMARY KEY ,
  "sign_id" int4,
  "is_sign" bool
)
WITH (OIDS=FALSE)
;

ALTER TABLE "notice_sign" OWNER TO "postgres";

COMMENT ON TABLE "notice_sign" IS '系统消息标记表-orange';

COMMENT ON COLUMN "notice_sign"."sign_id" IS '标记系统消息id';

COMMENT ON COLUMN "notice_sign"."is_sign" IS '是否标记';
