-- ----------------------------
-- Table structure for assume_scheme_detail
-- ----------------------------
DROP TABLE IF EXISTS "assume_scheme_detail";
CREATE TABLE "assume_scheme_detail" (
"id" serial4 NOT NULL,
"assume_scheme_id" int4 NOT NULL,
"api_id" int4 NOT NULL,
"game_type" varchar(32) COLLATE "default" NOT NULL,
"is_assume" varchar(1) COLLATE "default" DEFAULT 'N'
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "assume_scheme_detail" IS '运营商盈亏API承担设置表-Lins';
COMMENT ON COLUMN "assume_scheme_detail"."api_id" IS 'api外键';
COMMENT ON COLUMN "assume_scheme_detail"."game_type" IS '游戏类别:Dicts:   Module:common   Dict_Type:gameType';
COMMENT ON COLUMN "assume_scheme_detail"."assume_scheme_id" IS '运营商盈亏承担方案表ID，assume_scheme.id';
COMMENT ON COLUMN "assume_scheme_detail"."is_assume" IS '是否共担，Y/N 默认是共担';

ALTER TABLE "assume_scheme_detail" ADD PRIMARY KEY ("id");
