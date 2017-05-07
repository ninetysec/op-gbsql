-- auto gen by cherry 2016-11-02 21:18:21
drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, TEXT);
create or replace function gamebox_expense_gather(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	category 	TEXT
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 分摊费用
--v1.01  2016/05/12  Leisure  修正统计优惠信息的条件（占成）
--v1.02  2016/06/06  Leisure  公司存款、线上支付增加微信、支付宝存款、支付
--v1.03  2016/11/01  Leisure  修改分摊费用计算逻辑
*/
DECLARE
	rec 	record;
	hash 	hstore;
	mhash 	hstore;
	param 	text:='';
	user_id 	text:='';
	money 	float:=0.00;
	name 	TEXT:='';
	--cols 	TEXT;
	--tables 	TEXT;
	--grups 	TEXT;
	c_alias 	VARCHAR;
	sys_config hstore;
	sp TEXT:='@';
	rs TEXT:='\~';
	cs TEXT:='\^';
BEGIN
	--取得系统变量
	SELECT sys_config() INTO sys_config;
	sp = sys_config->'sp_split';
	rs = sys_config->'row_split';
	cs = sys_config->'col_split';
/*
	IF category = 'TOP' THEN
		cols = 'u.topagent_id as id, u.topagent_name as name, ';
		tables= 'player_transaction p, v_sys_user_tier u';
		grups= 'u.topagent_id, u.topagent_name ';
	ELSEIF category ='AGENT' THEN
		cols = 'u.agent_id as id, u.agent_name as name, ';
		tables = 'player_transaction p, v_sys_user_tier u';
		grups = 'u.agent_id, u.agent_name ';
	ELSE
		cols = 'p.player_id as id, u.username as name, ';
		tables = 'player_transaction p, v_sys_user_tier u';
		grups = 'p.player_id, u.username ';
	END IF;
	FOR rec IN EXECUTE
		'SELECT id,
		        name,
		        fund_type,
		        SUM(transaction_money) as transaction_money
		   FROM (SELECT '||cols||'
		                p.fund_type,
		                transaction_money
		           FROM '||tables||'
		          WHERE p.player_id = u.id
		            AND p.fund_type IN (''backwater'', ''refund_fee'', ''artificial_deposit'',
		                                ''artificial_withdraw'', ''player_withdraw'')
		            AND p.status = ''success''
		            AND NOT (fund_type = ''artificial_deposit'' AND
                         transaction_type = ''favorable'')
		            AND p.create_time >= $1
		            AND p.create_time < $2

		         UNION ALL
		         --优惠、推荐
		         SELECT '||cols||'
		                --p.fund_type||p.transaction_type,
		                ''favourable'' fund_type,
		                transaction_money
		           FROM '||tables||'
		          WHERE p.player_id = u.id
                AND (fund_type = ''favourable'' OR
		                 fund_type = ''recommend'' OR
		                 (fund_type = ''artificial_deposit'' AND transaction_type = ''favorable''))
		            AND p.status = ''success''
		            AND create_time >= $1
		            AND create_time < $2

		         UNION ALL
		         --公司存款 --v1.02  2016/06/06  Leisure
		         SELECT '||cols||'
		                --p.fund_type||p.transaction_type,
		                ''company_deposit'' fund_type,
		                transaction_money
		           FROM '||tables||'
		          WHERE p.player_id = u.id
                AND fund_type IN (''company_deposit'', ''wechatpay_fast'', ''alipay_fast'')
		            AND p.status = ''success''
		            AND create_time >= $1
		            AND create_time < $2

		         UNION ALL
		         --线上支付 --v1.02  2016/06/06  Leisure
		         SELECT '||cols||'
		                --p.fund_type||p.transaction_type,
		                ''online_deposit'' fund_type,
		                transaction_money
		           FROM '||tables||'
		          WHERE p.player_id = u.id
                AND fund_type IN (''online_deposit'', ''wechatpay_scan'', ''alipay_scan'')
		            AND p.status = ''success''
		            AND create_time >= $1
		            AND create_time < $2) fund_union
		  GROUP BY id, name, fund_type'
		USING start_time, end_time
	LOOP
*/
	IF category = 'TOP' THEN
		c_alias = 'ptt';
	ELSEIF category ='AGENT' THEN
		c_alias = 'pta';
	ELSE
		c_alias = 'ptp';
	END IF;

	FOR rec IN EXECUTE '
		WITH pt AS (
		  SELECT *
		    FROM player_transaction
		   WHERE status = ''success''
		     AND completion_time >= $1
		     AND completion_time < $2
		),
		pti AS (
		  --存款
		  SELECT player_id,
		         ''deposit'' AS transaction_type,
		         transaction_money
		    FROM pt
		   WHERE transaction_type = ''deposit''
		     --AND (fund_type <> ''artificial_deposit'' OR transaction_way = ''manual_deposit'')

		  UNION ALL
		  --取款
		  SELECT player_id,
		         ''withdrawal'' AS transaction_type,
		         transaction_money
		    FROM pt
		   WHERE transaction_type = ''withdrawals''
		     --AND (fund_type <> ''artificial_withdraw'' OR transaction_way = ''manual_deposit'')

		  UNION ALL
		  --优惠
		  SELECT player_id,
		         ''favorable'' AS transaction_type,
		         transaction_money
		    FROM pt
		   WHERE (transaction_type = ''favorable''
		          AND fund_type <> ''refund_fee''
		          AND transaction_way <> ''manual_rakeback'')

		  UNION ALL
		  --推荐
		  SELECT player_id,
		         ''recommend'' AS transaction_type,
		         transaction_money
		    FROM pt
		   WHERE transaction_type = ''recommend''

		  UNION ALL
		  --返水
		  SELECT player_id,
		         ''backwater'' AS transaction_type,
		         transaction_money
		    FROM pt
		   WHERE (transaction_type = ''backwater'' OR
		          (transaction_type = ''favorable'' AND transaction_way = ''manual_rakeback''))

		  UNION ALL
		  --返手续费
		  SELECT player_id,
		         ''refund_fee'' transaction_type,
		         transaction_money
		    FROM pt
		   WHERE fund_type = ''refund_fee''
		),
		--总代
		ptt AS(
		SELECT ut.id AS id,
		       ut.username AS name,
		       transaction_type AS fund_type,
		       SUM(transaction_money) AS transaction_money
		  FROM pti
		       LEFT JOIN
		       sys_user su ON pti.player_id = su."id" AND su.user_type = ''24''
		       LEFT JOIN
		       sys_user ua ON su.owner_id = ua."id" AND ua.user_type = ''23''
		       LEFT JOIN
		       sys_user ut ON ua.owner_id = ut."id" AND ut.user_type = ''22''
		 GROUP BY ut.id, transaction_type
		),
		--代理
		pta AS(
		SELECT ua.id AS id,
		       ua.username AS name,
		       transaction_type AS fund_type,
		       SUM(transaction_money) AS transaction_money
		  FROM pti
		       LEFT JOIN
		       sys_user su ON pti.player_id = su."id" AND su.user_type = ''24''
		       LEFT JOIN
		       sys_user ua ON su.owner_id = ua."id" AND ua.user_type = ''23''
		 GROUP BY ua.id, transaction_type
		),
		--玩家
		ptp AS(
		SELECT su.id AS id,
		       su.username AS name,
		       transaction_type AS fund_type,
		       SUM(transaction_money) AS transaction_money
		  FROM pti
		       LEFT JOIN
		       sys_user su ON pti.player_id = su."id" AND su.user_type = ''24''
		 GROUP BY su.id, transaction_type
		)
		SELECT * FROM ' || c_alias
	USING start_time, end_time
	LOOP

		user_id = rec.id::text;
		name = rec.name;
		money = rec.transaction_money;

		IF isexists(hash,user_id) THEN
			param = hash->user_id;
			param = param||rs||rec.fund_type||cs||money::text;
		ELSE
			param = 'user_name'||cs||name||rs||rec.fund_type||cs||money::text;
		END IF;

		SELECT user_id||'=>'||param INTO mhash;

		IF hash is null THEN
			hash = mhash;
		ELSE
			hash = hash||mhash;
		END IF;
	END LOOP;
	return hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT)
IS 'Lins-分摊费用';


DROP FUNCTION IF EXISTS gb_occupy_angent(INT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_occupy_angent(
	p_bill_id		INT,
	p_start_time		TIMESTAMP,
	p_end_time		TIMESTAMP
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/08/18  Leisure  创建此函数: 总代占成.代理贡献（占成和费用）
--v1.01  2016/11/01  Leisure  修改分摊费用条件，bet_time改为payout_time
*/
DECLARE
	rec record;

	n_effective_player  INT := 0;

	n_rebate_amount  FLOAT := 0.00;
	n_backwater_amount FLOAT := 0.00;
	n_favourable_amount FLOAT := 0.00;
	n_refund_fee_amount FLOAT := 0.00;

	n_deposit_amount 		float := 0.00;	-- 存款
	--n_company_deposit  float:=0.00;  -- 存款:公司入款
	--n_online_deposit  float:=0.00;  -- 存款:线上支付
	--n_artificial_deposit  float:=0.00;  -- 存款:手动存款

	n_withdrawal_amount  float := 0.00;  -- 取款
	--n_artificial_withdraw  float:=0.00;  -- 取款:手动取款
	--n_player_withdraw  float:=0.00;  -- 取款:玩家取款

	h_sys_apportion hstore;  --分摊比例配置信息
	n_agent_retio float := 0.00;  --代理分摊比例
	n_topagent_retio float := 0.00;  --总代分摊比例

	n_rebate_apportion_top  FLOAT := 0.00;
	n_apportion_top  FLOAT := 0.00;
	n_backwater_apportion_top  FLOAT := 0.00;
	n_favourable_apportion_top  FLOAT := 0.00;
	n_refund_fee_apportion_top  FLOAT := 0.00;

	n_occupy_top_final FLOAT := 0.00;

BEGIN
/*
	FOR rec IN
		SELECT oaa.agent_id,
		       oaa.agent_name,
		       SUM(oaa.effective_transaction)  effective_transaction,
		       SUM(oaa.profit_loss)  profit_loss,
		       SUM(oaa.topagent_occupy)  topagent_occupy
		  FROM occupy_agent_api oaa
		 WHERE oaa.occupy_bill_id = p_bill_id
		 GROUP BY oaa.agent_id, oaa.agent_name
	LOOP

		--有效玩家
		SELECT COUNT(DISTINCT player_id) effective_player
			INTO n_effective_player
		  FROM player_game_order pgo, v_sys_user_tier sut
		 WHERE pgo.player_id = sut.id
		   AND pgo.order_state = 'settle'
		   AND pgo.is_profit_loss = TRUE
		   --v1.01  2016/11/01  Leisure
		   AND pgo.payout_time >= p_start_time
		   AND pgo.payout_time < p_end_time
		   AND sut.agent_id = rec.agent_id;

		--取得存款金额
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_deposit_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND p.fund_type IN ('artificial_deposit',  --手动存款
		                       'company_deposit'', ''wechatpay_fast'', ''alipay_fast',  --公司存款
		                       'online_deposit'', ''wechatpay_scan'', ''alipay_scan'  --线上支付
		                      )
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;

		--取款金额
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_withdrawal_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND p.fund_type IN ('artificial_withdraw',  --手动取款
		                       'player_withdraw'  --玩家取款
		                      )
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;

		--取得返佣金额
		SELECT SUM (ra.rebate_actual)
		  INTO n_rebate_amount
		  FROM rebate_agent ra
		 WHERE ra.agent_id = rec.agent_id
		   AND ra.settlement_time >= p_start_time
		   AND ra.settlement_time < p_end_time
		   AND ra.settlement_state = 'lssuing';

		--统计各种费用
		--反水
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_backwater_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND p.fund_type = 'backwater'
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;

		--优惠、推荐
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_favourable_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND (fund_type = 'favourable' OR
		       fund_type = 'recommend' OR
		       (fund_type = 'artificial_deposit' AND transaction_type = 'favorable'))
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;

		--返手续费
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_refund_fee_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND p.fund_type = 'refund_fee'
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;
*/
	FOR rec IN
		WITH oaa AS(
		  SELECT agent_id,
		         agent_name,
		         SUM(effective_transaction)  effective_transaction,
		         SUM(profit_loss)  profit_loss,
		         SUM(topagent_occupy)  topagent_occupy
		    FROM occupy_agent_api
		   WHERE occupy_bill_id = p_bill_id
		   GROUP BY agent_id, agent_name
		),

		pt AS (
		  SELECT *
		    FROM player_transaction
		   WHERE status = 'success'
		     AND completion_time >= p_start_time
		     AND completion_time < p_end_time
		),

		pti AS (
		        --存款
		         SELECT player_id,
		                'deposit' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE transaction_type = 'deposit'
		            --AND (fund_type <> 'artificial_deposit' OR transaction_way = 'manual_deposit')

		         UNION ALL
		         --取款
		         SELECT player_id,
		                'withdrawal' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE transaction_type = 'withdrawals'
		            --AND (fund_type <> 'artificial_withdraw' OR transaction_way = 'manual_deposit')

		         UNION ALL
		         --优惠
		         SELECT player_id,
		                'favorable' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE (transaction_type = 'favorable'
		                 AND fund_type <> 'refund_fee'
		                 AND transaction_way <> 'manual_rakeback')

		         UNION ALL
		         --推荐
		         SELECT player_id,
		                'recommend' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE transaction_type = 'recommend'

		         UNION ALL
		         --返水
		         SELECT player_id,
		                'backwater' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE (transaction_type = 'backwater' OR
		                 (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))

		         UNION ALL
		         --返手续费
		         SELECT player_id,
		                'refund_fee' transaction_type,
		                transaction_money
		           FROM pt
		          WHERE fund_type = 'refund_fee'
		        ),

		pto AS (
		  SELECT ua."id" AS agent_id,
		         ua.username AS agent_name,
		         transaction_type,
		         transaction_money
		    FROM pti
		         LEFT JOIN
		         sys_user su ON pti.player_id = su."id" AND su.user_type = '24'
		         LEFT JOIN
		         sys_user ua ON su.owner_id = ua."id" AND ua.user_type = '23'
		),

		ptt AS (
		  SELECT agent_id,
		         agent_name,
		         SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit,
		         SUM(CASE transaction_type WHEN 'withdrawal' THEN transaction_money ELSE 0 END) AS withdrawal,
		         SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money ELSE 0 END) AS favorable,
		         SUM(CASE transaction_type WHEN 'recommend' THEN transaction_money ELSE 0 END) AS recommend,
		         SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS backwater,
		         SUM(CASE transaction_type WHEN 'refund_fee' THEN transaction_money ELSE 0 END) AS refund_fee
		    FROM pto
		   GROUP BY agent_id, agent_name
		)

		SELECT COALESCE(oaa.agent_id, ptt.agent_id) agent_id,
		       COALESCE(oaa.agent_name, ptt.agent_name) agent_name,
		       COALESCE(effective_transaction, 0.00) effective_transaction,
		       COALESCE(profit_loss, 0) profit_loss,
		       COALESCE(deposit, 0.00) deposit,
		       COALESCE(withdrawal, 0.00) withdrawal,
		       COALESCE(favorable, 0.00) favorable,
		       COALESCE(recommend, 0.00) recommend,
		       COALESCE(backwater, 0.00) backwater,
		       COALESCE(refund_fee, 0.00) refund_fee
		  FROM oaa FULL JOIN ptt ON oaa.agent_id = ptt.agent_id
		 ORDER BY agent_id
	LOOP

		--存款金额
		n_deposit_amount = rec.deposit;
		--取款金额
		n_withdrawal_amount = rec.withdrawal;

		--优惠、推荐
		n_favourable_amount = rec.favorable + rec.recommend;
		--反水
		n_backwater_amount = rec.backwater;
		--返手续费
		n_refund_fee_amount = rec.refund_fee;

		--有效玩家
		SELECT gamebox_valid_player_num(p_start_time, p_end_time, rec.agent_id, 0.00) INTO n_effective_player;

		--取得返佣金额
		SELECT SUM (ra.rebate_actual)
		  INTO n_rebate_amount
		  FROM rebate_agent ra
		 WHERE ra.agent_id = rec.agent_id
		   AND ra.settlement_time >= p_start_time
		   AND ra.settlement_time < p_end_time
		   AND ra.settlement_state = 'lssuing';

		--计算分摊费用、分摊佣金
		SELECT gamebox_sys_param('apportionSetting') INTO h_sys_apportion;

		--佣金分摊
		n_topagent_retio = 0.00;

		IF isexists(h_sys_apportion, 'topagent.rebate.percent') THEN
			n_topagent_retio = (h_sys_apportion->'topagent.rebate.percent')::float;
		END IF;

		n_rebate_apportion_top = n_rebate_amount * n_topagent_retio / 100;

		--优惠与推荐分摊
		n_agent_retio = 0.00;
		n_topagent_retio = 0.00;

		IF isexists(h_sys_apportion, 'agent.preferential.percent') THEN
			n_agent_retio = (h_sys_apportion->'agent.preferential.percent')::float;  --代理分摊比例
		END IF;

		IF isexists(h_sys_apportion, 'topagent.preferential.percent') THEN
			n_topagent_retio = (h_sys_apportion->'topagent.preferential.percent')::float;  --总代分摊比例
		END IF;

		n_favourable_apportion_top = n_favourable_amount * (1 - n_agent_retio / 100) * n_topagent_retio / 100;

		--返手续费分摊
		n_agent_retio = 0.00;
		n_topagent_retio = 0.00;

		IF isexists(h_sys_apportion, 'agent.poundage.percent') THEN
			n_agent_retio = (h_sys_apportion->'agent.poundage.percent')::float;
		END IF;

		IF isexists(h_sys_apportion, 'topagent.poundage.percent') THEN
			n_topagent_retio = (h_sys_apportion->'topagent.poundage.percent')::float;
		END IF;

		n_topagent_retio = (1 - n_agent_retio / 100) * n_topagent_retio / 100;

		n_refund_fee_apportion_top = n_refund_fee_amount * n_topagent_retio;

		--返水分摊
		n_agent_retio = 0.00;
		n_topagent_retio = 0.00;

		IF isexists(h_sys_apportion, 'agent.rakeback.percent') THEN
			n_agent_retio = (h_sys_apportion->'agent.rakeback.percent')::float;
		END IF;

		IF isexists(h_sys_apportion, 'topagent.rakeback.percent') THEN
			n_topagent_retio = (h_sys_apportion->'topagent.rakeback.percent')::float;
		END IF;

		n_topagent_retio = (1 - n_agent_retio / 100) * n_topagent_retio / 100;

		n_backwater_apportion_top = n_backwater_amount * n_topagent_retio;

		--费用分摊总和 = (优惠+返手续费+反水+返佣)
		n_apportion_top = n_backwater_apportion_top + n_favourable_apportion_top + n_refund_fee_apportion_top + n_rebate_apportion_top;

		--总代最终占成金额 = 总代占成金额 - 佣金分摊 - 其他费用分摊
		n_occupy_top_final = rec.topagent_occupy - n_apportion_top;

		--插入总代占成-代理贡献占成表
		INSERT INTO occupy_agent(
		    occupy_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
		    deposit_amount, rebate, withdrawal_amount, preferential_value, occupy_total, occupy_actual,
		    remark, lssuing_state, apportion, refund_fee, recommend, rakeback
		) VALUES(
		    p_bill_id, rec.agent_id, rec.agent_name, n_effective_player, rec.effective_transaction, rec.profit_loss,
		    n_deposit_amount, n_rebate_amount, n_withdrawal_amount, n_favourable_apportion_top, rec.topagent_occupy, n_occupy_top_final,
		    NULL, 'pending_pay', n_apportion_top, n_refund_fee_apportion_top, 0.00, n_backwater_apportion_top
		);
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_occupy_angent(p_bill_id INT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-总代占成.代理贡献（占成和费用）';


DROP FUNCTION IF EXISTS gb_occupy_angent_api(INT, TIMESTAMP, TIMESTAMP, hstore[]);
CREATE OR REPLACE FUNCTION gb_occupy_angent_api(
	bill_id		INT,
	start_time		TIMESTAMP,
	end_time		TIMESTAMP,
	net_maps		hstore[]
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/08/15  Leisure  创建此函数: 总代占成.代理API贡献占成
--v1.01  2016/11/01  Leisure  bet_time改为payout_time
*/
DECLARE

	occupy_map 	hstore;		-- API占成梯度map
	assume_map 	hstore;		-- 盈亏共担map

	topagent_occupy_map  hstore;

	sys_config 	hstore;
	sp 			TEXT:='@';
	rs 			TEXT:='\~';
	cs 			TEXT:='\^';
	key_name 				TEXT:='';
	col_split 			TEXT:='_';

	rec 					record;

	api 		INT;
	game_type 	TEXT;
	topagent_id  TEXT;

	profit_amount 			FLOAT:=0.00;--盈亏总和
	operation_occupy_retio FLOAT:=0.00;--运营商占成比例
	operation_occupy_value 	FLOAT:=0.00;--运营商API占成金额

	topagent_occupy_retio  FLOAT:=0.00;--总代占成比例
	topagent_occupy_value  FLOAT:=0.00;--总代API占成金额

BEGIN
	--取得系统变量
	SELECT sys_config() INTO sys_config;
	sp = sys_config->'sp_split';
	rs = sys_config->'row_split';
	cs = sys_config->'col_split';

	--取得总代占成比例map
	SELECT gamebox_occupy_api_set() into topagent_occupy_map;

	--取得运营商占成、盈亏共担map
	--raise info '------ net_maps = %', net_maps;
	occupy_map = net_maps[2];
	assume_map = net_maps[3];

	FOR rec IN
		SELECT ua."id"									as agent_id,
		       ua.username							as agent_name,
		       ut."id"									as topagent_id,
		       --ut.username							as topagent_name,
		       pgo.api_id,
		       pgo.game_type,
		       COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount,
		       COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction
		    FROM player_game_order pgo
		    LEFT JOIN sys_user su ON pgo.player_id = su."id"
		    LEFT JOIN sys_user ua ON su.owner_id = ua.id
		    LEFT JOIN sys_user ut ON ua.owner_id = ut.id
		 WHERE pgo.order_state = 'settle'
		   AND pgo.is_profit_loss = TRUE
		   --v1.01  2016/11/01  Leisure
		   --AND pgo.bet_time >= start_time
		   --AND pgo.bet_time < end_time
		   AND pgo.payout_time >= start_time
		   AND pgo.payout_time < end_time
		   AND su.user_type = '24'
		   AND ua.user_type = '23'
		   AND ut.user_type = '22'
		 GROUP BY ut."id", ua."id", ua.username, pgo.api_id, pgo.game_type
	LOOP

		api 			= rec.api_id;
		game_type 		= rec.game_type;
		profit_amount 	= rec.profit_amount;
		topagent_id  =rec.topagent_id;

		--取得运营商API占成.--比例
		key_name = api||col_split||game_type;

		IF isexists(occupy_map, key_name) THEN
			operation_occupy_retio = (occupy_map->key_name)::float;
			operation_occupy_value = profit_amount * operation_occupy_retio/100;
		ELSE
			operation_occupy_value = 0.00;
		END IF;

		--计算总代占成.
		key_name = topagent_id||col_split||api||col_split||game_type;

		IF exist(topagent_occupy_map, key_name) THEN
			topagent_occupy_retio = (topagent_occupy_map->key_name)::FLOAT;
			--总代占成 = (赢利 - 运营商占成) * 总代占比
			topagent_occupy_value = (profit_amount - operation_occupy_value) * topagent_occupy_retio/100;
		ELSE
			topagent_occupy_value = 0.00;
			raise info '总代ID = %, API = %, GAME_TYPE = % 未设置占成.', topagent_id, api, game_type;
		END IF;

		INSERT INTO occupy_agent_api(
		    occupy_bill_id, agent_id, agent_name, api_id, game_type, effective_transaction,
		    profit_loss, operation_retio, operation_occupy, topagent_retio, topagent_occupy
		) VALUES(
		    bill_id, rec.agent_id, rec.agent_name, rec.api_id, rec.game_type, rec.effective_transaction,
		    rec.profit_amount, operation_occupy_retio, operation_occupy_value, topagent_occupy_retio, topagent_occupy_value
		);

	END LOOP;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_occupy_angent_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, net_maps hstore[])
IS 'Leisure-总代占成.代理API贡献占成';


drop function if exists gb_rebate_agent(INT, TEXT, TIMESTAMP, TIMESTAMP);
create or replace function gb_rebate_agent(
	p_bill_id 	INT,
	p_settle_flag 	TEXT,
	p_start_time		TIMESTAMP,
	p_end_time		TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单-代理返佣
--v1.00  2016/10/15  Leisure  更新分摊费用计算
--v1.01  2016/11/01  Leisure  美化SQL
*/
DECLARE
	rec 	record;
	c_agent_name 	TEXT := '';
	c_pending_state 	TEXT := 'pending_lssuing';
	n_rebate_original 		FLOAT := 0.00;	-- 代理返佣（原始佣金）
	n_max_rebate	FLOAT := 0.00;	-- 返佣上限
	n_rebate_final	FLOAT := 0.00;	-- 最终佣金（佣金+上期未结-分摊费用）
	--n_player_num	INT := 0; 	--有效玩家数
	n_next_lssuing 	FLOAT := 0.00; --未结算佣金（往期未结）

	h_sys_apportion hstore;  --分摊比例配置信息

	n_agent_retio float := 0.00; --代理分摊比率
	n_favorable_apportion 	float:=0.00;-- 优惠分摊费用
	n_recommend_apportion 	float:=0.00;-- 推荐分摊费用
	n_backwater_apportion 	float:=0.00;-- 返水分摊费用
	n_refund_fee_apportion 	float:=0.00;-- 返手续费分摊费用
	n_apportion float:=0.00; --代理分摊总费用

BEGIN

	SELECT gamebox_sys_param('apportionSetting') INTO h_sys_apportion;

	FOR rec IN

		WITH raa AS (
		  SELECT agent_id,
		         MIN(rebate_grads_id) rebate_grads_id,
		         SUM(effective_transaction) effective_transaction,
		         MIN(effective_player_num) effective_player_num,
		         SUM(profit_loss) profit_loss,
		         SUM(rebate_value) rebate
		    FROM rebate_agent_api
		   WHERE rebate_bill_id = p_bill_id
		     AND settle_flag = p_settle_flag
		   GROUP BY agent_id
		),

		pt AS (
		  SELECT *
		    FROM player_transaction
		   WHERE status = 'success'
		     AND completion_time >= p_start_time
		     AND completion_time < p_end_time
		),

		pti AS (
		        --存款
		         SELECT player_id,
		                'deposit' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE transaction_type = 'deposit'
		            --AND (fund_type <> 'artificial_deposit' OR transaction_way = 'manual_deposit')

		         UNION ALL
		         --取款
		         SELECT player_id,
		                'withdrawal' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE transaction_type = 'withdrawals'
		            --AND (fund_type <> 'artificial_withdraw' OR transaction_way = 'manual_deposit')

		         UNION ALL
		         --优惠
		         SELECT player_id,
		                'favorable' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE (transaction_type = 'favorable'
		                 AND fund_type <> 'refund_fee'
		                 AND transaction_way <> 'manual_rakeback')

		         UNION ALL
		         --推荐
		         SELECT player_id,
		                'recommend' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE transaction_type = 'recommend'

		         UNION ALL
		         --返水
		         SELECT player_id,
		                'backwater' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE (transaction_type = 'backwater' OR
		                 (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))

		         UNION ALL
		         --返手续费
		         SELECT player_id,
		                'refund_fee' transaction_type,
		                transaction_money
		           FROM pt
		          WHERE fund_type = 'refund_fee'
		        ),

		pto AS (
		  SELECT ua."id" AS agent_id,
		         transaction_type,
		         transaction_money
		    FROM pti
		         LEFT JOIN
		         sys_user su ON pti.player_id = su."id" AND su.user_type = '24'
		         LEFT JOIN
		         sys_user ua ON su.owner_id = ua."id" AND ua.user_type = '23'
		),

		ptt AS (
		  SELECT agent_id,
		         SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit,
		         SUM(CASE transaction_type WHEN 'withdrawal' THEN transaction_money ELSE 0 END) AS withdrawal,
		         SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money ELSE 0 END) AS favorable,
		         SUM(CASE transaction_type WHEN 'recommend' THEN transaction_money ELSE 0 END) AS recommend,
		         SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS backwater,
		         SUM(CASE transaction_type WHEN 'refund_fee' THEN transaction_money ELSE 0 END) AS refund_fee
		    FROM pto
		   GROUP BY agent_id
		)

		SELECT COALESCE(raa.agent_id, ptt.agent_id) agent_id,
		       raa.rebate_grads_id,
		       COALESCE(effective_transaction, 0.00) effective_transaction,
		       COALESCE(effective_player_num, 0) effective_player_num,
		       COALESCE(profit_loss, 0) profit_loss,
		       COALESCE(rebate, 0.00) rebate,
		       COALESCE(deposit, 0.00) deposit,
		       COALESCE(withdrawal, 0.00) withdrawal,
		       COALESCE(favorable, 0.00) favorable,
		       COALESCE(recommend, 0.00) recommend,
		       COALESCE(backwater, 0.00) backwater,
		       COALESCE(refund_fee, 0.00) refund_fee
		  FROM raa FULL JOIN ptt ON raa.agent_id = ptt.agent_id
		 ORDER BY agent_id
	LOOP

		--在循环内部，需要初始化变量
		n_rebate_original = rec.rebate;
		n_max_rebate = 0.00;
		n_next_lssuing = 0.00;

		n_favorable_apportion = 0.00;-- 优惠分摊费用
		n_recommend_apportion = 0.00;-- 推荐分摊费用
		n_backwater_apportion = 0.00;-- 返水分摊费用
		n_refund_fee_apportion = 0.00;-- 返手续费分摊费用

		--获取代理名称
		SELECT username INTO c_agent_name FROM sys_user su WHERE su.user_type = '23' AND su.id = rec.agent_id;

		--获取分摊费用
		--优惠、推荐
		IF isexists(h_sys_apportion, 'agent.preferential.percent') THEN
			n_agent_retio = (h_sys_apportion->'agent.preferential.percent')::float;  --代理分摊比例
			n_favorable_apportion = rec.favorable * n_agent_retio/100;
			n_recommend_apportion = rec.recommend * n_agent_retio/100;
		END IF;
		--返水
		IF isexists(h_sys_apportion, 'agent.rakeback.percent') THEN
			n_agent_retio = (h_sys_apportion->'agent.rakeback.percent')::float;  --代理分摊比例
			n_backwater_apportion = rec.backwater * n_agent_retio/100;
		END IF;
		--返手续费
		IF isexists(h_sys_apportion, 'agent.poundage.percent') THEN
			n_agent_retio = (h_sys_apportion->'agent.poundage.percent')::float;  --代理分摊比例
			n_refund_fee_apportion = rec.refund_fee * n_agent_retio/100;
		END IF;

		n_apportion = n_favorable_apportion + n_recommend_apportion + n_backwater_apportion + n_refund_fee_apportion;

		--如果代理本期完成返佣梯度
		IF n_rebate_original > 0 THEN

			--获得返佣上限
			SELECT max_rebate
			  FROM rebate_grads
			 WHERE id = rec.rebate_grads_id
			  INTO n_max_rebate;

			IF n_max_rebate > 0 AND n_rebate_original > n_max_rebate THEN
				n_rebate_original = n_max_rebate;
			END IF;

			c_pending_state :='pending_lssuing';

			--如果本期满足返佣梯度，需要结算往期费用
			SELECT COALESCE(SUM(rebate_actual), 0.00)
			  INTO n_next_lssuing
			  FROM rebate_agent rao
			 WHERE rao.settlement_state = 'next_lssuing'
			   AND rao.agent_id = rec.agent_id
			   --AND rao.rebate_bill_id <= bill_id
			   AND rao.rebate_bill_id >
			     (SELECT COALESCE(MAX(rebate_bill_id), 0)
			        FROM rebate_agent rai
			       WHERE rai.settlement_state <> 'next_lssuing'
			         AND rai.agent_id = rec.agent_id
			         --AND rai.rebate_bill_id < bill_id
			     );

		ELSE
			c_pending_state := 'next_lssuing';
		END IF;

		n_rebate_final := n_rebate_original + n_next_lssuing - n_apportion;

		IF p_settle_flag = 'Y' THEN

			INSERT INTO rebate_agent(
				rebate_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
				rakeback, rebate_total, rebate_actual, refund_fee, recommend, preferential_value, settlement_state,
				apportion, deposit_amount, withdrawal_amount, history_apportion
			) VALUES (
				p_bill_id, rec.agent_id, c_agent_name, rec.effective_player_num, rec.effective_transaction, rec.profit_loss,
				rec.backwater, n_rebate_final, n_rebate_final, rec.refund_fee, rec.recommend, rec.favorable, c_pending_state,
				--rec.backwater + rec.refund_fee + rec.recommend + rec.favorable,
				n_apportion,
				rec.deposit, rec.withdrawal, n_next_lssuing
			);
		ELSEIF p_settle_flag='N' THEN

			INSERT INTO rebate_agent_nosettled (
				rebate_bill_nosettled_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
				rakeback, rebate_total, refund_fee, recommend, preferential_value,
				apportion, deposit_amount, withdrawal_amount, history_apportion
			) VALUES (
				p_bill_id, rec.agent_id, c_agent_name, rec.effective_player_num, rec.effective_transaction, rec.profit_loss,
				rec.backwater, n_rebate_final, rec.refund_fee, rec.recommend, rec.favorable,
				--rec.backwater + rec.refund_fee + rec.recommend + rec.favorable,
				n_apportion,
				rec.deposit, rec.withdrawal, n_next_lssuing
			);

		END IF;

	END LOOP;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-返佣结算账单-代理返佣';