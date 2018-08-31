DROP TABLE IF EXISTS "user_player_wallet_history";
CREATE TABLE "user_player_wallet_history" (
id serial4 NOT NULL,
player_id int4 NOT NULL,
"wallet_balance_before" numeric(20,2),
"wallet_balance_after" numeric(20,2),
"create_time" timestamp(6),
"remark" text
)
;
COMMENT ON TABLE  "user_player_wallet_history" IS '玩家钱包更新历史记录表--steffan';
COMMENT ON COLUMN  "user_player_wallet_history"."id" IS '记录id';
COMMENT ON COLUMN  "user_player_wallet_history"."player_id" IS ' 玩家id';
COMMENT ON COLUMN  "user_player_wallet_history"."wallet_balance_before" IS '更新前钱包金额';
COMMENT ON COLUMN  "user_player_wallet_history"."wallet_balance_after" IS '更新后钱包金额';
COMMENT ON COLUMN  "user_player_wallet_history"."create_time" IS '创建时间';
COMMENT ON COLUMN  "user_player_wallet_history"."remark" IS '备注';


DROP TRIGGER "tg_user_player_wallet" ON  "user_player";
CREATE TRIGGER "tg_user_player_wallet" AFTER UPDATE OF "wallet_balance" ON  "user_player"
FOR EACH ROW
EXECUTE PROCEDURE process_tg_user_player_wallet();

COMMENT ON TRIGGER "tg_user_player_wallet" ON  "user_player" IS '钱包余额变化';
create or replace function process_tg_user_player_wallet() returns trigger as $tg_user_player_wallet$
--user_player 钱包余额变化
begin

     insert into user_player_wallet_history(player_id,wallet_balance_before,wallet_balance_after,create_time,remark)
		 select new.id,old.wallet_balance,new.wallet_balance,now(),null;

     return new;

end;
$tg_user_player_wallet$ language plpgsql;