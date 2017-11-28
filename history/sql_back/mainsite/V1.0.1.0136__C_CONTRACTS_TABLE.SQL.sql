-- auto gen by tom 2015-12-04 16:59:39
drop view if EXISTS  v_contract_scheme;
DROP TABLE IF EXISTS contract_scheme;
CREATE TABLE IF NOT EXISTS "contract_scheme" (
"id" SERIAL4 NOT NULL ,
"ensure_consume" numeric(20,2) DEFAULT 0,
"maintenance_charges" numeric(20,2) DEFAULT 0,
"create_user_id" int4,
"create_time" timestamp(6),
"update_user_id" int4,
"update_time" timestamp(6),
"status" varchar(32) COLLATE "default",
CONSTRAINT "contract_scheme_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "contract_scheme" OWNER TO "postgres";

COMMENT ON TABLE "contract_scheme" IS '包网方案信息--tom';

COMMENT ON COLUMN "contract_scheme"."id" IS '主键';

COMMENT ON COLUMN "contract_scheme"."ensure_consume" IS '保底消费额';

COMMENT ON COLUMN "contract_scheme"."maintenance_charges" IS '维护费/月';

COMMENT ON COLUMN "contract_scheme"."create_user_id" IS '用户ID';

COMMENT ON COLUMN "contract_scheme"."create_time" IS '创建时间';

COMMENT ON COLUMN "contract_scheme"."update_user_id" IS '更新用户ID';

COMMENT ON COLUMN "contract_scheme"."update_time" IS '更新时间';

COMMENT ON COLUMN "contract_scheme"."status" IS '状态 1:启用,2:禁用,3:删除';

DROP TABLE IF EXISTS contract_occupy_grads;
CREATE TABLE IF NOT EXISTS "contract_occupy_grads" (
"id" SERIAL4 NOT NULL ,
"contract_scheme_id" int4,
"profit_lower" numeric(20,2) DEFAULT 0,
"profit_limit" numeric(20,2) DEFAULT 0,
"order_num" int4,
CONSTRAINT "contract_occupy_grads_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "contract_occupy_grads" OWNER TO "postgres";

COMMENT ON TABLE "contract_occupy_grads" IS '包网方案占成梯度--tom';

COMMENT ON COLUMN "contract_occupy_grads"."id" IS '主键';

COMMENT ON COLUMN "contract_occupy_grads"."contract_scheme_id" IS '包网方案id';

COMMENT ON COLUMN "contract_occupy_grads"."profit_lower" IS '盈利下限(包含)';

COMMENT ON COLUMN "contract_occupy_grads"."profit_limit" IS '盈利上限';

COMMENT ON COLUMN "contract_occupy_grads"."order_num" IS '顺序';

DROP TABLE IF EXISTS contract_occupy_api;
CREATE TABLE IF NOT EXISTS "contract_occupy_api" (
"id" SERIAL4 NOT NULL ,
"contract_occupy_grads_id" int4,
"api_id" int4,
"game_type" varchar(32) COLLATE "default",
"ratio" numeric(20,2) DEFAULT 0,
CONSTRAINT "contract_occupy_api_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "contract_occupy_api" OWNER TO "postgres";

COMMENT ON TABLE "contract_occupy_api" IS '包网方案api占成比例--tom';

COMMENT ON COLUMN "contract_occupy_api"."id" IS '主键';

COMMENT ON COLUMN "contract_occupy_api"."contract_occupy_grads_id" IS '占成梯度id';

COMMENT ON COLUMN "contract_occupy_api"."api_id" IS 'api外键';

COMMENT ON COLUMN "contract_occupy_api"."game_type" IS '游戏分类,即api二级分类';

COMMENT ON COLUMN "contract_occupy_api"."ratio" IS '占成比例';

DROP TABLE IF EXISTS contract_api;
CREATE TABLE IF NOT EXISTS "contract_api" (
"id" SERIAL4 NOT NULL ,
"contract_scheme_id" int4 NOT NULL,
"api_id" int4,
"is_assume" bool NOT NULL,
CONSTRAINT "contract_api_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "contract_api" OWNER TO "postgres";

COMMENT ON TABLE "contract_api" IS '包网方案api盈利共担信息--tom';

COMMENT ON COLUMN "contract_api"."id" IS '主键';

COMMENT ON COLUMN "contract_api"."contract_scheme_id" IS '包网方案id';

COMMENT ON COLUMN "contract_api"."api_id" IS 'api外键';

COMMENT ON COLUMN "contract_api"."is_assume" IS '是否盈亏共担';

DROP TABLE IF EXISTS contract_favourable;
CREATE TABLE IF NOT EXISTS "contract_favourable" (
"id" SERIAL4 NOT NULL ,
"contract_scheme_id" int4,
"favourable_type" varchar(32) COLLATE "default",
"favourable_way" varchar(32) COLLATE "default",
"favourable_limit" numeric(20,2) DEFAULT 0,
CONSTRAINT "contract_favourable_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "contract_favourable" OWNER TO "postgres";

COMMENT ON TABLE "contract_favourable" IS '包网方案优惠信息--tom';

COMMENT ON COLUMN "contract_favourable"."contract_scheme_id" IS '包网方案id';

COMMENT ON COLUMN "contract_favourable"."favourable_type" IS '优惠类型,1:减免维护费 , 2:返还盈利)';

COMMENT ON COLUMN "contract_favourable"."favourable_way" IS '优惠方式(1:固定,2:比例)';

COMMENT ON COLUMN "contract_favourable"."favourable_limit" IS '优惠上限,返还盈利需要设置该值';

DROP TABLE IF EXISTS contract_favourable_grads;
CREATE TABLE IF NOT EXISTS "contract_favourable_grads" (
"id" SERIAL4 NOT NULL ,
"contract_favourable_id" int4,
"profit_lower" numeric(20),
"profit_limit" numeric(20),
"favourable_value" varchar COLLATE "default",
CONSTRAINT "contract_favorable_grads_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "contract_favourable_grads" OWNER TO "postgres";

COMMENT ON TABLE "contract_favourable_grads" IS '包网方案占成梯度--tom';

COMMENT ON COLUMN "contract_favourable_grads"."id" IS '主键';

COMMENT ON COLUMN "contract_favourable_grads"."contract_favourable_id" IS '包网优惠ID';

COMMENT ON COLUMN "contract_favourable_grads"."profit_lower" IS '盈利下限(包含)';

COMMENT ON COLUMN "contract_favourable_grads"."profit_limit" IS '盈利上限';

COMMENT ON COLUMN "contract_favourable_grads"."favourable_value" IS '优惠值';

DROP TABLE IF EXISTS "site_contract_scheme";
CREATE TABLE IF NOT EXISTS "site_contract_scheme" (
"id" SERIAL4 NOT NULL,
"contract_scheme_id" int4 NOT NULL,
"center_id" int4 NOT NULL,
CONSTRAINT "site_contract_scheme_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_contract_scheme" OWNER TO "postgres";

COMMENT ON TABLE "site_contract_scheme" IS '运营商拥有包网方案--tom';

COMMENT ON COLUMN "site_contract_scheme"."id" IS '主键';

COMMENT ON COLUMN "site_contract_scheme"."contract_scheme_id" IS '包网方案id';

COMMENT ON COLUMN "site_contract_scheme"."center_id" IS '运营商ID';