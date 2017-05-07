-- auto gen by admin 2016-06-18 14:17:50
drop function if exists gamebox_site_rebate_gametype(hstore, hstore);
create or replace function gamebox_site_rebate_gametype(
	api_map 	hstore,
	dict_map 	hstore
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：站点返佣.GAME_TYPE
--v1.01  2016/06/17  Leisure  返佣统计改为每期（原来为每月）执行一次，去除DELETE逻辑
*/
DECLARE
	keys 		TEXT[];
	sub_keys 	TEXT[];
	val 		FLOAT;
	col_split 	TEXT:='_';
	sid 		INT;
	center_id 	INT;
	master_id 	INT;
	c_year 		INT;
	c_month 	INT;

BEGIN
	sid = (dict_map->'site_id')::INT;
	center_id = (dict_map->'center_id')::INT;
	master_id = (dict_map->'master_id')::INT;
	c_year = (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;

	--v1.01  2016/06/17  Leisure
	--DELETE FROM site_rebate_gametype WHERE site_id = sid AND rebate_year = c_year AND rebate_month = c_month;

	keys = akeys(api_map);
	IF api_map is null OR array_length(keys, 1) is null THEN
		RETURN;
	END IF;

	FOR i IN 1..array_length(keys, 1)
	LOOP
		val = (api_map->keys[i])::FLOAT;
		sub_keys = regexp_split_to_array(keys[i], col_split);
		INSERT INTO site_rebate_gametype(
			center_id, master_id, site_id,
			api_id, game_type,
			rebate_year, rebate_month, static_time, rebate_total
		)VALUES(
			center_id, master_id, sid,
			sub_keys[1]::INT, sub_keys[2],
			c_year, c_month, now(), val
		);
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate_gametype(api_map hstore, dict_map hstore)
IS 'Lins-站点返佣.GAME_TYPE';

drop function if exists gamebox_site_rebate_api(hstore);
create or replace function gamebox_site_rebate_api(
	dict_map hstore
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：站点返佣.GAME_TYPE
--v1.01  2016/06/17  Leisure  返佣统计改为每期（原来为每月）执行一次，去除DELETE逻辑
*/
DECLARE
	sid 	INT;
	c_id 	INT;
	m_id 	INT;
	c_year 	INT;
	c_month INT;
BEGIN
	sid = (dict_map->'site_id')::INT;
	c_id = (dict_map->'center_id')::INT;
	m_id = (dict_map->'master_id')::INT;
	c_year = (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;

	--v1.01  2016/06/17  Leisure
	--DELETE FROM site_rebate_api WHERE site_id = sid AND rebate_year = c_year AND rebate_month = c_month;

	INSERT INTO site_rebate_api(
		center_id, master_id, site_id,
		rebate_year, rebate_month, static_time,
		api_id, rebate_total
	) SELECT
		c_id, m_id, sid,
		c_year, c_month, now(),
		api_id, SUM(rebate_total)
		FROM site_rebate_gametype
  	   WHERE site_id = sid
  	   	 AND rebate_year = c_year
  	   	 AND rebate_month = c_month
	   GROUP BY api_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate_api(dict_map hstore)
IS 'Lins-站点返佣.API';

drop function if exists gamebox_site_rebate(hstore, hstore);
create or replace function gamebox_site_rebate(
	expense_map hstore,
	dict_map 	hstore
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：站点返佣
--v1.01  2016/06/09  Leisure  增加上期未结费用计算
--v1.02  2016/06/18  Leisure  返佣统计改为每期（原来为每月）执行一次，去除DELETE逻辑
*/
DECLARE
	center_id 	INT;
	master_id 	INT;
	siteId 		INT;
	rbt_year 	INT;
	rbt_month 	INT;

	player_num 	INT:=0;
	apportion 	FLOAT:=0.00;
	rakeback 	FLOAT:=0.00;
	recommend	FLOAT:=0.00;
	refund_fee 	FLOAT:=0.00;
	profit_loss FLOAT:=0.00;
	deposit 	FLOAT:=0.00;	-- 存款
	effe_trans 	FLOAT:=0.00;
	favorable 	FLOAT:=0.00;	-- 优惠
	withdraw 	FLOAT:=0.00;	-- 取款
	rebate_tot 	FLOAT:=0.00;
	rebate_act 	FLOAT:=0.00;
	expense_leaving		FLOAT := 0.00; --v1.01  2016/06/09  Leisure

BEGIN
	center_id 	= (dict_map->'center_id')::INT;
	master_id 	= (dict_map->'master_id')::INT;
	siteId 	= (dict_map->'site_id')::INT;
	rbt_year = (dict_map->'year')::INT;
	rbt_month = (dict_map->'month')::INT;

	player_num 	= (expense_map->'player_num')::INT;
	apportion	= (expense_map->'apportion')::FLOAT;
	rakeback	= (expense_map->'rakeback')::FLOAT;
	recommend	= (expense_map->'recommend')::FLOAT;
	refund_fee	= (expense_map->'refund_fee')::FLOAT;
	profit_loss = (expense_map->'profit_loss')::FLOAT;
	deposit 	= (expense_map->'deposit')::FLOAT;
	effe_trans 	= (expense_map->'effe_trans')::FLOAT;
	favorable 	= (expense_map->'favorable')::FLOAT;
	withdraw 	= (expense_map->'withdraw')::FLOAT;
	rebate_tot 	= (expense_map->'rebate_tot')::FLOAT;
	rebate_act 	= (expense_map->'rebate_act')::FLOAT;
	--v1.01  2016/06/09  Leisure
	expense_leaving 	= (expense_map->'expense_leaving')::FLOAT;

	--v1.02  2016/06/18  Leisure
	--DELETE FROM site_rebate re WHERE re.site_id = siteId AND re.rebate_year = rbt_year AND re.rebate_month = rbt_month;

	INSERT INTO site_rebate(
  		center_id, master_id, site_id,
  		effective_player, effective_transaction, profit_loss, deposit_amount,
  		withdrawal_amount, preferential_value, refund_fee, rebate_total, rebate_actual,
  		rebate_year, rebate_month, static_time, rakeback, apportion, history_apportion --v1.01  2016/06/09  Leisure
	) VALUES (
		center_id, master_id, siteId,
  		player_num, effe_trans, profit_loss, deposit,
  		withdraw, favorable + recommend, refund_fee, rebate_tot, rebate_act,
  		rbt_year, rbt_month, now(), rakeback, apportion, expense_leaving --v1.01  2016/06/09  Leisure
	);
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate(expense_map hstore, dict_map hstore)
IS 'Lins-站点返佣';