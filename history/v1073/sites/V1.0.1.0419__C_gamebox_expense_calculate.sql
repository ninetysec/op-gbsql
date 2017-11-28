-- auto gen by cherry 2017-03-30 14:00:14
drop function if exists gamebox_expense_calculate(hstore, hstore, TEXT);
create or replace function gamebox_expense_calculate(
	cost_map 	hstore,
	sys_map 	hstore,
	category TEXT
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 总代占成-分摊费用
--v1.01  2017/03/29  Leisure  分摊费用改为全部由代理承担 by Shook
*/
DECLARE
	keys 		text[];
	mhash 		hstore;
	keyname 	text:='';
	val 		text:='';
	tmp 		TEXT:='';

	backwater 				float:=0.00;	-- 返水
	backwater_apportion 	float:=0.00;

	favourable 				float:=0.00;	-- 优惠 = (优惠 + 推荐 + 手动存入优惠)
	--recommend 				float:=0.00;
	--artificial_depositfavorable		float:=0.00;	-- 手动存入优惠
	favourable_apportion 	float:=0.00;

	refund_fee 				float:=0.00;	-- 手续费
	refund_fee_apportion 	float:=0.00;

	rebate 					float:=0.00;	-- 返佣
	rebate_apportion 		float:=0.00;

	apportion 				FLOAT:=0.00;	-- 总分摊费用

	retio 					FLOAT:=0.00;
	retio2 					FLOAT:=0.00;

	sys_config 	hstore;
	sp 			TEXT:='@';
	rs 			TEXT:='\~';
	cs 			TEXT:='\^';

BEGIN
	--取得系统变量
	SELECT sys_config() INTO sys_config;
	sp = sys_config->'sp_split';
	rs = sys_config->'row_split';
	cs = sys_config->'col_split';

	IF cost_map is null THEN
		RETURN cost_map;
	END IF;
	keys = akeys(cost_map);
	FOR i in 1..array_length(keys, 1)
	LOOP
		keyname = keys[i];
		val = cost_map->keyname;
		tmp = val;
		--转换成hstore数据格式:key1=>value1, key2=>value2
		tmp = replace(tmp, rs,',');
		tmp = replace(tmp, cs,'=>');
		SELECT tmp into mhash;

		backwater = 0.00;--返水
		IF exist(mhash, 'backwater') THEN
			backwater = (mhash->'backwater')::float;
		END IF;

		favourable = 0.00;--优惠
		IF exist(mhash, 'favourable') THEN
			favourable = (mhash->'favourable')::float;
		END IF;

		refund_fee = 0.00;--返手续费
		IF exist(mhash, 'refund_fee') THEN
			refund_fee = (mhash->'refund_fee')::float;
		END IF;

		/*
		\* 优惠/推荐已全部归入favorable
		recommend = 0.00;--推荐
		IF exist(mhash, 'recommend') THEN
			recommend = (mhash->'recommend')::float;
		END IF;

		artificial_depositfavorable = 0.00; -- 手动存入优惠
		IF exist(mhash, 'artificial_depositfavorable') THEN
			artificial_depositfavorable = (mhash->'artificial_depositfavorable')::float;
		END IF;
		*\
		rebate = 0.00;
		IF exist(mhash, 'rebate') THEN
			rebate=(mhash->'rebate')::float;
		END IF;

		backwater 	= COALESCE(backwater, 0);
		favourable 	= COALESCE(favourable, 0);
		--recommend 	= COALESCE(recommend, 0);
		--artificial_depositfavorable = COALESCE(artificial_depositfavorable, 0);
		refund_fee 	= COALESCE(refund_fee, 0);
		rebate 		= COALESCE(rebate, 0);

		--计算各种优惠.
		\*
			计算各种优惠.
			1、返水承担费用=赠送给体系下玩家的返水 * 代理承担比例；
			2、优惠承担费用=赠送给体系下玩家的优惠 * 代理承担比例；
			3、返还手续费承担费用=返还给体系下玩家的手续费 * 代理承担比例；
		*\
		--优惠与推荐分摊
		retio2 = 0.00;
		retio = 0.00;

		IF isexists(sys_map, 'agent.preferential.percent') THEN
			retio2 = (sys_map->'agent.preferential.percent')::float;--代理分摊比例
		END IF;

		IF isexists(sys_map, 'topagent.preferential.percent') THEN
			retio = (sys_map->'topagent.preferential.percent')::float;
		END IF;

		IF category = 'OCCUPY' THEN
			retio = (1 - retio2 / 100) * retio / 100;
		ELSE
			retio = retio2 / 100;
		END IF;

		--favourable_apportion = (favourable + recommend + artificial_depositfavorable) * retio;
		favourable_apportion = favourable * retio;

		--返水分摊
		retio2 = 0.00;
		retio = 0.00;

		IF isexists(sys_map, 'agent.rakeback.percent') THEN
			retio2 = (sys_map->'agent.rakeback.percent')::float;--代理分摊比例
		END IF;

		IF isexists(sys_map, 'topagent.rakeback.percent') THEN
			retio = (sys_map->'topagent.rakeback.percent')::float;
		END IF;

		IF category = 'OCCUPY' THEN
			retio = (1 - retio2 / 100) * retio / 100;
		ELSE
			retio = retio2 / 100;
		END IF;

		backwater_apportion = backwater * retio;

		--手续费优惠分摊
		retio2 = 0.00;
		retio = 0.00;

		IF isexists(sys_map, 'agent.poundage.percent') THEN
			retio2 = (sys_map->'agent.poundage.percent')::float;--代理分摊比例
		END IF;

		IF isexists(sys_map, 'topagent.poundage.percent') THEN
			retio = (sys_map->'topagent.poundage.percent')::float;
		END IF;

		IF category = 'OCCUPY' THEN
			retio = (1 - retio2 / 100) * retio / 100;
		ELSE
			retio = retio2 / 100;
		END IF;

		refund_fee_apportion = refund_fee * retio;

		--返佣分摊
		rebate_apportion = 0;
		retio = 0.00;

		IF isexists(sys_map, 'topagent.rebate.percent') THEN
			retio = (sys_map->'topagent.rebate.percent')::float;
			rebate_apportion = rebate * retio / 100;
		END IF;
		*/

		--v1.01  2017/03/29
		rebate_apportion = rebate;
		favourable_apportion = favourable;
		backwater_apportion = backwater;
		refund_fee_apportion = refund_fee;

		apportion = favourable_apportion + backwater_apportion + refund_fee_apportion;

		val = val||rs||'apportion'||cs||apportion;
		val = val||rs||'rebate_apportion'||cs||rebate_apportion;
		val = val||rs||'favourable_apportion'||cs||favourable_apportion;
		val = val||rs||'backwater_apportion'||cs||backwater_apportion;
		val = val||rs||'refund_fee_apportion'||cs||refund_fee_apportion;
		cost_map = cost_map||(SELECT (keyname||'=>'||val)::hstore);
	END LOOP;

	RETURN cost_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_calculate(cost_map hstore, sys_map hstore, category TEXT)
IS 'Lins-费用分摊计算';