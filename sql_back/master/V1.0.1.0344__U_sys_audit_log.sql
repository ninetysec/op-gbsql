-- auto gen by cherry 2016-01-24 13:45:48

UPDATE sys_audit_log SET module_type = '2' WHERE description = 'passport.login.desc.fail';

CREATE OR REPLACE FUNCTION "f_calculator_total_assets"(playerid int4)
  RETURNS "pg_catalog"."numeric" AS $BODY$ DECLARE
	sql_text VARCHAR ; --查询sql,获取当前玩家的有效交易量
	api_money NUMERIC;--api余额
	player_wallet_balance NUMERIC;--玩家钱包余额
	player_freezing_balance NUMERIC ;--当前冻结金额
	total_assets NUMERIC ; --总资产
BEGIN
select sum(money) from player_api where player_id=playerid into api_money;

select wallet_balance,freezing_funds_balance from user_player where id=playerid into player_wallet_balance,player_freezing_balance;

raise notice '该玩家的api总余额:%,钱包余额:%,玩家冻结余额为：%',api_money,player_wallet_balance,player_freezing_balance;

total_assets = COALESCE(api_money,0)+COALESCE(player_wallet_balance,0)+COALESCE(player_freezing_balance,0);

raise notice '该玩家的总资产:%',total_assets;

RETURN total_assets;
END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "f_calculator_total_assets"(playerid int4) OWNER TO "postgres";

COMMENT ON FUNCTION "f_calculator_total_assets"(playerid int4) IS '计算某玩家当前的总资产';

ALTER TABLE "ctt_document_i18n" ALTER COLUMN "content" TYPE text COLLATE "default",ALTER COLUMN "content_default" TYPE text COLLATE "default";