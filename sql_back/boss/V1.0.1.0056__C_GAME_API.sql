-- auto gen by mark 2016-01-14 19:46:55
CREATE TABLE IF NOT EXISTS "game_api_provider" (
"id" serial4 NOT NULL,
"abbr_name" varchar(16) COLLATE "default" NOT NULL,
"full_name" varchar(64) COLLATE "default",
"api_url" varchar(128) COLLATE "default" NOT NULL,
"remarks" varchar(128) COLLATE "default",
"jar_url" varchar(128) COLLATE "default",
"api_class" varchar(128) COLLATE "default",
"jar_version" varchar(16) COLLATE "default",
"ext_json" varchar(500) COLLATE "default",
CONSTRAINT "pk_game_api_provider" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "game_api_provider" OWNER TO "postgres";

COMMENT ON TABLE "game_api_provider" IS '游戏api提供商 -- Kevice';

COMMENT ON COLUMN "game_api_provider"."id" IS '主键';

COMMENT ON COLUMN "game_api_provider"."abbr_name" IS '简称';

COMMENT ON COLUMN "game_api_provider"."full_name" IS '全称';

COMMENT ON COLUMN "game_api_provider"."api_url" IS 'api调用的url';

COMMENT ON COLUMN "game_api_provider"."remarks" IS '备注';

COMMENT ON COLUMN "game_api_provider"."jar_url" IS '具体实现jar包的url';

COMMENT ON COLUMN "game_api_provider"."api_class" IS 'api具体实现的类(全类名)';

COMMENT ON COLUMN "game_api_provider"."jar_version" IS 'jar包版本';

COMMENT ON COLUMN "game_api_provider"."ext_json" IS 'json格式的扩展信息';



CREATE TABLE IF NOT EXISTS "game_api_interface" (
"id" serial4 NOT NULL,
"protocol" varchar(8) COLLATE "default" NOT NULL,
"api_action" varchar(200) COLLATE "default",
"local_action" varchar(32) COLLATE "default" NOT NULL,
"http_method" varchar COLLATE "default",
"remarks" varchar COLLATE "default",
"param_class" varchar COLLATE "default" NOT NULL,
"result_class" varchar(64) COLLATE "default" NOT NULL,
"request_content_type" varchar(32) COLLATE "default",
"response_content_type" varchar(32) COLLATE "default" NOT NULL,
"provider_id" int4 NOT NULL,
"ext_json" varchar(500) COLLATE "default",
CONSTRAINT "pk_game_api_interface" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "game_api_interface" OWNER TO "postgres";

COMMENT ON TABLE "game_api_interface" IS '游戏api接口信息 -- Kevice';

COMMENT ON COLUMN "game_api_interface"."id" IS '主键';

COMMENT ON COLUMN "game_api_interface"."protocol" IS '协议';

COMMENT ON COLUMN "game_api_interface"."api_action" IS '请求的action';

COMMENT ON COLUMN "game_api_interface"."local_action" IS '本地j自定义的action(面向业务系统)';

COMMENT ON COLUMN "game_api_interface"."http_method" IS 'http提交方式';

COMMENT ON COLUMN "game_api_interface"."remarks" IS '64';

COMMENT ON COLUMN "game_api_interface"."param_class" IS '请求参数对象的类';

COMMENT ON COLUMN "game_api_interface"."result_class" IS '返回的结果类';

COMMENT ON COLUMN "game_api_interface"."request_content_type" IS '请求的内容类型';

COMMENT ON COLUMN "game_api_interface"."response_content_type" IS '响应的内容类型';

COMMENT ON COLUMN "game_api_interface"."provider_id" IS 'api提供商id';

COMMENT ON COLUMN "game_api_interface"."ext_json" IS 'json格式的扩展信息';



DROP INDEX  if EXISTS fk_game_api_interface_provider_id;
CREATE INDEX "fk_game_api_interface_provider_id" ON "game_api_interface" USING btree (provider_id);


CREATE TABLE IF NOT EXISTS "game_api_interface_request" (
"id" serial4 NOT NULL,
"api_field_name" varchar(32) COLLATE "default" NOT NULL,
"property_name" varchar(32) COLLATE "default",
"required" bool DEFAULT true NOT NULL,
"min_length" int4,
"max_length" int4,
"reg_exp" varchar(300) COLLATE "default",
"default_value" varchar(32) COLLATE "default",
"interface_id" int4 NOT NULL,
"remarks" varchar(64) COLLATE "default",
"comment" varchar(300) COLLATE "default",
"min_value" varchar(32) COLLATE "default",
"max_value" varchar(32) COLLATE "default",
CONSTRAINT "pk_game_api_interface_request" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "game_api_interface_request" OWNER TO "postgres";

COMMENT ON TABLE "game_api_interface_request" IS '游戏api接口请求参数信息 -- Kevice';

COMMENT ON COLUMN "game_api_interface_request"."id" IS '主键';

COMMENT ON COLUMN "game_api_interface_request"."api_field_name" IS 'api要求的字段名';

COMMENT ON COLUMN "game_api_interface_request"."property_name" IS 'param类中定义的属性名';

COMMENT ON COLUMN "game_api_interface_request"."required" IS '是否必须';

COMMENT ON COLUMN "game_api_interface_request"."min_length" IS '最小长度';

COMMENT ON COLUMN "game_api_interface_request"."max_length" IS '最大长度';

COMMENT ON COLUMN "game_api_interface_request"."reg_exp" IS '正规表达式';

COMMENT ON COLUMN "game_api_interface_request"."default_value" IS '默认值';

COMMENT ON COLUMN "game_api_interface_request"."interface_id" IS '接口id, 外键';

COMMENT ON COLUMN "game_api_interface_request"."remarks" IS '备注';

COMMENT ON COLUMN "game_api_interface_request"."comment" IS '注释';

COMMENT ON COLUMN "game_api_interface_request"."min_value" IS '最小值';

COMMENT ON COLUMN "game_api_interface_request"."max_value" IS '最大值';


DROP INDEX  if EXISTS fk_game_api_interface_request_interface_id;
CREATE INDEX "fk_game_api_interface_request_interface_id" ON "game_api_interface_request" USING btree (interface_id);

CREATE TABLE IF NOT EXISTS "game_api_interface_response" (
"id" serial4 NOT NULL,
"api_field_name" varchar(32) COLLATE "default" NOT NULL,
"property_name" varchar(32) COLLATE "default",
"comment" varchar(32) COLLATE "default",
"interface_id" int4 NOT NULL,
CONSTRAINT "pk_game_api_interface_response" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "game_api_interface_response" OWNER TO "postgres";

COMMENT ON TABLE "game_api_interface_response" IS '游戏api接口响应信息 -- Kevice';

COMMENT ON COLUMN "game_api_interface_response"."id" IS '主键';

COMMENT ON COLUMN "game_api_interface_response"."api_field_name" IS 'api字段名';

COMMENT ON COLUMN "game_api_interface_response"."property_name" IS '属性名';

COMMENT ON COLUMN "game_api_interface_response"."comment" IS '注释';

COMMENT ON COLUMN "game_api_interface_response"."interface_id" IS '接口id, 外键';


DROP INDEX  if EXISTS fk_game_api_interface_response_interface_id;
CREATE INDEX "fk_game_api_interface_response_interface_id" ON "game_api_interface_response" USING btree (interface_id);