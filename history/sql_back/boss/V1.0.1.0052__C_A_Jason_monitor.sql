-- auto gen by jason 2016-01-13 09:31:09



/*
Navicat PGSQL Data Transfer

Source Server         : developing
Source Server Version : 90404
Source Host           : 192.168.0.88:5432
Source Database       : gamebox-boss
Source Schema         : public

Target Server Type    : PGSQL
Target Server Version : 90404
File Encoding         : 65001

Date: 2016-01-12 10:03:21
*/


-- ----------------------------
-- Table structure for monitor_config
-- ----------------------------
DROP TABLE IF EXISTS "monitor_config";
CREATE TABLE "monitor_config" (
"id" int8 NOT NULL,
"type_name" varchar(256) COLLATE "default" NOT NULL,
"method_name" varchar(100) COLLATE "default" NOT NULL,
"vo_name" varchar(256) COLLATE "default" NOT NULL,
"priority" int2 NOT NULL,
"create_time" timestamp(6),
"is_invoked" int2 DEFAULT 1 NOT NULL,
"is_sync" int2 DEFAULT 1 NOT NULL,
"rule_instance" varchar(256) COLLATE "default" DEFAULT ''::character varying NOT NULL,
"delay_sec" int8 DEFAULT 10 NOT NULL
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "monitor_config" IS '监控配置--jasonli';
COMMENT ON COLUMN "monitor_config"."id" IS '主键';
COMMENT ON COLUMN "monitor_config"."type_name" IS '接口服务名';
COMMENT ON COLUMN "monitor_config"."method_name" IS '方法名';
COMMENT ON COLUMN "monitor_config"."vo_name" IS '参数名（完整类路劲）';
COMMENT ON COLUMN "monitor_config"."priority" IS '优先级1.本地队列发送，2.mq发送';
COMMENT ON COLUMN "monitor_config"."create_time" IS '创建时间';
COMMENT ON COLUMN "monitor_config"."is_invoked" IS '0拦截入参，1拦截返回结果result';
COMMENT ON COLUMN "monitor_config"."is_sync" IS '是否实时调用规则链：1实时2延时';
COMMENT ON COLUMN "monitor_config"."rule_instance" IS '规则链实例';
COMMENT ON COLUMN "monitor_config"."delay_sec" IS '延迟触发的秒数';


-- ----------------------------
-- Alter Sequences Owned By
-- ----------------------------

-- ----------------------------
-- Uniques structure for table monitor_config
-- ----------------------------
ALTER TABLE "monitor_config" ADD UNIQUE ("type_name", "method_name");

-- ----------------------------
-- Primary Key structure for table monitor_config
-- ----------------------------
ALTER TABLE "monitor_config" ADD PRIMARY KEY ("id");



/*
Navicat PGSQL Data Transfer

Source Server         : developing
Source Server Version : 90404
Source Host           : 192.168.0.88:5432
Source Database       : gamebox-boss
Source Schema         : public

Target Server Type    : PGSQL
Target Server Version : 90404
File Encoding         : 65001

Date: 2016-01-12 10:04:24
*/


-- ----------------------------
-- Table structure for monitor_data_result
-- ----------------------------
DROP TABLE IF EXISTS "monitor_data_result";

CREATE TABLE "monitor_data_result" (
"id" SERIAL8 NOT NULL,
"config_id" int8 NOT NULL,
"warn_type" int4 NOT NULL,
"origin_info" varchar COLLATE "default",
"warn_desc" varchar COLLATE "default",
"act_type" int4 NOT NULL,
"create_time" timestamp(6),
"warn_level" int4 NOT NULL,
"busi_id" int8,
"site_id" int4,
"user_id" int8
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "monitor_data_result" IS '监控数据分析结果';
COMMENT ON COLUMN "monitor_data_result"."id" IS '流水号';
COMMENT ON COLUMN "monitor_data_result"."config_id" IS '业务流程编号';
COMMENT ON COLUMN "monitor_data_result"."warn_type" IS '警告类型';
COMMENT ON COLUMN "monitor_data_result"."origin_info" IS '原始信息';
COMMENT ON COLUMN "monitor_data_result"."warn_desc" IS '警告描述';
COMMENT ON COLUMN "monitor_data_result"."act_type" IS '处理方式';
COMMENT ON COLUMN "monitor_data_result"."create_time" IS '创建时间';
COMMENT ON COLUMN "monitor_data_result"."warn_level" IS '警告严重等级，1，2，3，4依次降低';
COMMENT ON COLUMN "monitor_data_result"."busi_id" IS '外部业务表ID';
COMMENT ON COLUMN "monitor_data_result"."site_id" IS '上下文-站点ID';
COMMENT ON COLUMN "monitor_data_result"."user_id" IS '上下文-用户ID';

-- ----------------------------
-- Alter Sequences Owned By
-- ----------------------------

-- ----------------------------
-- Indexes structure for table monitor_data_result
-- ----------------------------
CREATE INDEX "fk_monitor_data_result_busi_id" ON "monitor_data_result" USING btree (busi_id);
CREATE INDEX "fk_monitor_data_result_config_id" ON "monitor_data_result" USING btree (config_id);

-- ----------------------------
-- Primary Key structure for table monitor_data_result
-- ----------------------------
ALTER TABLE "monitor_data_result" ADD PRIMARY KEY ("id");




/*
Navicat PGSQL Data Transfer

Source Server         : developing
Source Server Version : 90404
Source Host           : 192.168.0.88:5432
Source Database       : gamebox-boss
Source Schema         : public

Target Server Type    : PGSQL
Target Server Version : 90404
File Encoding         : 65001

Date: 2016-01-12 10:26:47
*/


-- ----------------------------
-- Table structure for monitor_config_relation
-- ----------------------------
DROP TABLE IF EXISTS "monitor_config_relation";
CREATE TABLE "monitor_config_relation" (
"config_id" int4 NOT NULL,
"parent_config_id" int4,
"config_group_id" int4 NOT NULL,
"desc" varchar(256) COLLATE "default" NOT NULL,
"push_type" int2 DEFAULT 0 NOT NULL
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "monitor_config_relation" IS '监控业务配置关系表--业务链';
COMMENT ON COLUMN "monitor_config_relation"."config_id" IS '监控配置ID';
COMMENT ON COLUMN "monitor_config_relation"."parent_config_id" IS '监控配置父ID';
COMMENT ON COLUMN "monitor_config_relation"."config_group_id" IS '配置组ID，配置组对应一个业务链';
COMMENT ON COLUMN "monitor_config_relation"."desc" IS '监控业务链说明';
COMMENT ON COLUMN "monitor_config_relation"."push_type" IS '1:主动收集 0:filter收集';



-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Indexes structure for table monitor_config_relation
-- ----------------------------
CREATE INDEX "fk_monitor_config_relation_config_group_id" ON "monitor_config_relation" USING btree (config_group_id);
CREATE INDEX "fk_monitor_config_relation_config_id" ON "monitor_config_relation" USING btree (config_id);
CREATE INDEX "fk_monitor_config_relation_parent_config_id" ON "monitor_config_relation" USING btree (parent_config_id);

-- ----------------------------
-- Primary Key structure for table monitor_config_relation
-- ----------------------------
ALTER TABLE "monitor_config_relation" ADD PRIMARY KEY ("config_id");
