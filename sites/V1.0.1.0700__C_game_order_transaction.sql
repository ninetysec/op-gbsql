-- auto gen by linsen 2018-03-09 14:50:09
-- 注单资金记录表 by mical

CREATE TABLE IF NOT EXISTS "game_order_transaction" (

"id" varchar(50) COLLATE "default" NOT NULL PRIMARY KEY,

"user_id" int4,

"api_id" int4,

"username" varchar(32) COLLATE "default",

"transaction_type" varchar(32) COLLATE "default",

"money" numeric(20,3),

"apibalance" numeric(20,2),

"balance" numeric(20,2),

"transaction_time" timestamp(6),

"terminal" varchar(32) COLLATE "default",

"memo" varchar(50) COLLATE "default",

"source_id" int4

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "game_order_transaction" IS '注单资金记录表';

COMMENT ON COLUMN "game_order_transaction"."id" IS '主键';

COMMENT ON COLUMN "game_order_transaction"."user_id" IS '玩家ID';

COMMENT ON COLUMN "game_order_transaction"."api_id" IS 'API_ID';

COMMENT ON COLUMN "game_order_transaction"."username" IS '玩家账号';

COMMENT ON COLUMN "game_order_transaction"."transaction_type" IS '交易类型 (投注，派彩，存款，提款)';

COMMENT ON COLUMN "game_order_transaction"."money" IS '交易金额,有正负';

COMMENT ON COLUMN "game_order_transaction"."apibalance" IS 'api余额';

COMMENT ON COLUMN "game_order_transaction"."balance" IS '钱包余额';

COMMENT ON COLUMN "game_order_transaction"."transaction_time" IS '交易时间';

COMMENT ON COLUMN "game_order_transaction"."terminal" IS '终端标示';

COMMENT ON COLUMN "game_order_transaction"."memo" IS '备注';

COMMENT ON COLUMN "game_order_transaction"."source_id" IS '交易来源ID';


CREATE INDEX if NOT EXISTS "fk_game_order_transaction_api_userId" ON "game_order_transaction" USING btree (user_id,api_id);
CREATE INDEX if NOT EXISTS "fk_game_order_transaction_username" ON "game_order_transaction" USING btree (username);