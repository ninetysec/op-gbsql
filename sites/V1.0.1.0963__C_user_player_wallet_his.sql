-- auto gen by steffan 2018-08-31 18:00:37
DROP TABLE IF EXISTS "user_player_wallet_his";
CREATE TABLE "gb-site-1"."user_player_wallet_his" (
id serial4 NOT NULL,
player_id int4 NOT NULL,
"wallet_balance_before" numeric(20,2),
"wallet_balance_after" numeric(20,2),
"create_time" timestamp(6),
"remark" text
)
;
COMMENT ON TABLE  "user_player_wallet_his" IS '玩家钱包更新历史记录表--steffan';
COMMENT ON COLUMN  "user_player_wallet_his"."id" IS '记录id';
COMMENT ON COLUMN  "user_player_wallet_his"."player_id" IS ' 玩家id';
COMMENT ON COLUMN  "user_player_wallet_his"."wallet_balance_before" IS '更新前钱包金额';
COMMENT ON COLUMN  "user_player_wallet_his"."wallet_balance_after" IS '更新后钱包金额';
COMMENT ON COLUMN  "user_player_wallet_his"."create_time" IS '创建时间';
COMMENT ON COLUMN  "user_player_wallet_his"."remark" IS '备注';