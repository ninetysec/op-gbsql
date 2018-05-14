-- auto gen by linsen 2018-04-15 21:27:53
-- 计算某玩家当前的总资产 by kobe
DROP FUNCTION IF EXISTS gamebox_activityhall_calculator_total_assets(playerid int4);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_calculator_total_assets"(playerid int4)
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


COMMENT ON FUNCTION "gamebox_activityhall_calculator_total_assets"(playerid int4) IS '计算某玩家当前的总资产';