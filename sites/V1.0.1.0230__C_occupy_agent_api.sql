-- auto gen by cherry 2016-08-22 15:29:28
--新增代理api占成表；修改总代占成各表注释
CREATE TABLE IF not EXISTS "occupy_agent_api" (

"id" serial4 NOT NULL,

"occupy_bill_id" int4,

"agent_id" int4,

"agent_name" varchar(32) COLLATE "default",

"api_id" int4,

"game_type" varchar(32) COLLATE "default",

"effective_transaction" numeric(20,2),

"profit_loss" numeric(20,2),

"operation_retio" numeric(4,2),

"operation_occupy" numeric(20,2),

"topagent_retio" numeric(4,2),

"topagent_occupy" numeric(20,2),

CONSTRAINT "occupy_api_copy_pkey" PRIMARY KEY ("id")

)

WITH (OIDS=FALSE);



COMMENT ON COLUMN "occupy_agent_api"."id" IS '主键';

COMMENT ON COLUMN "occupy_agent_api"."occupy_bill_id" IS '总代占成报表ID';

COMMENT ON COLUMN "occupy_agent_api"."agent_id" IS '代理ID';

COMMENT ON COLUMN "occupy_agent_api"."agent_name" IS '代理账号';

COMMENT ON COLUMN "occupy_agent_api"."api_id" IS 'API_ID';

COMMENT ON COLUMN "occupy_agent_api"."game_type" IS '二级游戏类别:game.game_type';

COMMENT ON COLUMN "occupy_agent_api"."effective_transaction" IS '有效交易量';

COMMENT ON COLUMN "occupy_agent_api"."profit_loss" IS '盈亏';

COMMENT ON COLUMN "occupy_agent_api"."operation_retio" IS '运营商占比';

COMMENT ON COLUMN "occupy_agent_api"."operation_occupy" IS '运营商占成';

COMMENT ON COLUMN "occupy_agent_api"."topagent_retio" IS '总代占比';

COMMENT ON COLUMN "occupy_agent_api"."topagent_occupy" IS '总代占成';


select redo_sqls($$
    CREATE INDEX "fk_occupy_agent_api_agent_id" ON "occupy_agent_api" USING btree ("agent_id");
    CREATE INDEX "fk_occupy_agent_api_occupy_bill_id" ON "occupy_agent_api" USING btree ("occupy_bill_id");
$$);



--代理

COMMENT ON COLUMN "occupy_agent"."occupy_bill_id" IS '占成总表ID';

COMMENT ON COLUMN "occupy_agent"."agent_id" IS '代理ID';

COMMENT ON COLUMN "occupy_agent"."agent_name" IS '代理账号';

COMMENT ON COLUMN "occupy_agent"."occupy_total" IS '总代占成（盈亏产生）';

COMMENT ON COLUMN "occupy_agent"."occupy_actual" IS '实付占成 （已扣除分摊费用）';

COMMENT ON COLUMN "occupy_agent"."recommend" IS '推荐（已纳入优惠）';

--总代

COMMENT ON COLUMN "occupy_topagent"."occupy_bill_id" IS '占成总表ID';

COMMENT ON COLUMN "occupy_topagent"."occupy_total" IS '总代占成（盈亏产生）';

COMMENT ON COLUMN "occupy_topagent"."occupy_actual" IS '实付占成 （已扣除分摊费用）';

COMMENT ON COLUMN "occupy_topagent"."recommend" IS '推荐（已纳入优惠）';

COMMENT ON TABLE "occupy_topagent" IS '总代占成-总代明细--Lins';

--总表

COMMENT ON COLUMN "occupy_bill"."period" IS '期间名称';

COMMENT ON COLUMN "occupy_bill"."occupy_total" IS '总代占成（盈亏产生）';

COMMENT ON COLUMN "occupy_bill"."occupy_actual" IS '实际占成金额（已扣除分摊费用）';

COMMENT ON COLUMN "occupy_bill"."recommend" IS '推荐（已纳入优惠）';

COMMENT ON TABLE "occupy_bill" IS '总代占成-总表--Lins';


--总代占成报表过程修改
COMMENT ON FUNCTION gamebox_occupy_api_map(start_time TIMESTAMP, end_time TIMESTAMP, occupy_grads_map hstore, net_maps hstore[])

IS 'Lins-总代占成-各API占成';



drop function if exists gb_topagent_occupy(text, text, text, text);

create or replace function gb_topagent_occupy(

	p_period 		text,

	p_start_time 	text,

	p_end_time 	text,

	p_comp_url 		text

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2016/08/15  Leisure  创建此函数: 总代占成统计—入口

*/

DECLARE



	d_start_time 	TIMESTAMP;

	d_end_time 	TIMESTAMP;



	n_bill_count		INT;

	n_bill_id 			INT;



	n_sid 				INT;--站点ID.

	c_is_max		BOOLEAN := true;

	h_net_schema_map 	hstore[];-- 包网方案map



	redo_status BOOLEAN:=false; -- 重跑标识，默认不允许重跑



BEGIN

	d_start_time = p_start_time::TIMESTAMP;

	d_end_time = p_end_time::TIMESTAMP;



	SELECT COUNT("id")

	  INTO n_bill_count

		FROM occupy_bill cb

	 WHERE cb.period = p_period

		 AND cb."start_time" = d_start_time

		 AND cb."end_time" = d_end_time;



	IF n_bill_count > 0 THEN

		IF redo_status THEN

			--DELETE FROM occupy_api WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			--DELETE FROM occupy_player WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			DELETE FROM occupy_angent_api WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			DELETE FROM occupy_agent WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			DELETE FROM occupy_topagent WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			DELETE FROM occupy_bill WHERE "id" IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

		ELSE

			raise info '已生成本期总代占成统计报表，无需重新生成。';

			RETURN;

		END IF;

	END IF;



	SELECT gamebox_current_site() INTO n_sid;



	raise info '统计站点( % )周期( % )的总代占成, 时间( %-% )', n_sid, p_period, p_start_time, p_end_time;



	raise info '总代占成.总表新增';

	SELECT gamebox_occupy_bill(p_period, d_start_time, d_end_time, n_bill_id, 'I') into n_bill_id;

	raise info 'occupy_bill.键值:%', n_bill_id;



	raise info '取得包网方案';

	SELECT * FROM dblink(p_comp_url, 'SELECT gamebox_contract('||n_sid||', '||c_is_max||')') as a(hash hstore[]) INTO h_net_schema_map;



	raise info '总代占成.代理API交易表';

	perform gb_occupy_angent_api(n_bill_id, d_start_time, d_end_time, h_net_schema_map);



	raise info '总代占成.代理贡献度.';

	perform gb_occupy_angent(n_bill_id, d_start_time, d_end_time);



	raise info '总代占成.总代明细';

	perform gamebox_occupy_topagent(n_bill_id);



	raise info '总代占成.总表更新';

	perform gamebox_occupy_bill(p_period, d_start_time, d_end_time, n_bill_id, 'U');



END;



$$ language plpgsql;

COMMENT ON FUNCTION gb_topagent_occupy(p_period text, p_start_time text, p_end_time text, url text)

IS 'Leisure-总代占成统计—入口';



DROP FUNCTION IF EXISTS gb_occupy_angent_api(INT, TIMESTAMP, TIMESTAMP, hstore[]);

create or replace function gb_occupy_angent_api(

	bill_id		INT,

	start_time		TIMESTAMP,

	end_time		TIMESTAMP,

	net_maps		hstore[]

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2016/08/15  Leisure  创建此函数: 总代占成.代理API贡献占成

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

		   AND pgo.bet_time >= start_time

		   AND pgo.bet_time < end_time

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



DROP FUNCTION IF EXISTS gb_occupy_angent(INT, TIMESTAMP, TIMESTAMP);

create or replace function gb_occupy_angent(

	p_bill_id		INT,

	p_start_time		TIMESTAMP,

	p_end_time		TIMESTAMP

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2016/08/18  Leisure  创建此函数: 总代占成.代理贡献（占成和费用）

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

		   AND pgo.bet_time >= p_start_time

		   AND pgo.bet_time < p_end_time

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



drop function if exists gamebox_occupy_topagent(INT);

create or replace function gamebox_occupy_topagent(

	bill_id INT

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数: 总代占成-总代明细

--v1.01  2016/08/20  Leisure  增加occupy_actual汇总

*/

DECLARE

	pending_lssuing text:='pending_lssuing';

	pending_pay 	text:='pending_pay';

BEGIN

	INSERT INTO occupy_topagent(

		occupy_bill_id, top_agent_id, top_agent_name,effective_agent, effective_transaction, profit_loss, preferential_value,

		rakeback, occupy_total, occupy_actual, rebate, refund_fee, recommend, apportion, lssuing_state

	)

	SELECT

				p.occupy_bill_id, a.id, a.username, COUNT(distinct p.agent_id), sum(p.effective_transaction), SUM(p.profit_loss), SUM(preferential_value),

				SUM(rakeback), SUM(occupy_total), SUM(occupy_actual), SUM(rebate), SUM(refund_fee), SUM(recommend), SUM(apportion), pending_pay

	  FROM occupy_agent p, sys_user u, sys_user a

	 WHERE p.agent_id = u.id

	   AND p.occupy_bill_id = bill_id

	   AND u.owner_id = a.id

	   AND u.user_type='23'

	   AND a.user_type='22'

	 GROUP BY p.occupy_bill_id, a.id, a.username;



	raise info '总代占成-总代明细.完成';



END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_topagent(INT)

IS 'Lins-总代占成-总代明细';



DROP FUNCTION IF EXISTS gamebox_occupy_bill(TEXT, TIMESTAMP, TIMESTAMP, INOUT BIGINT, TEXT);

create or replace function gamebox_occupy_bill(

	name 			TEXT,

	start_time 		TIMESTAMP,

	end_time 		TIMESTAMP,

	INOUT bill_id 	BIGINT,

	op 				TEXT

) returns BIGINT as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数: 总代占成-总代明细

--v1.01  2016/08/20  Leisure  增加occupy_actual汇总

*/

DECLARE

	rec 		record;

	pending_pay text:='pending_pay';

BEGIN

	IF op='I' THEN

		INSERT INTO occupy_bill(

					period, start_time, end_time,

					top_agent_count, top_agent_lssuing_count, top_agent_reject_count, occupy_total, occupy_actual,

					last_operate_time, create_time, lssuing_state

		) VALUES (

		 name, start_time, end_time,

		 0, 0, 0, 0, 0,

		 now(), now(), pending_pay

		);

		SELECT currval(pg_get_serial_sequence('occupy_bill', 'id')) into bill_id;

		raise info 'occupy_bill.完成.键值:%', bill_id;

	ELSE

		FOR rec in

			SELECT COUNT(top_agent_id)  		as top_agent_num,

			       SUM(effective_transaction) 	as effective_transaction ,

			       SUM(profit_loss) 			as profit_loss,

			       SUM(rakeback) 				as rakeback,

			       SUM(rebate) 					as rebate,

			       SUM(occupy_total) 			as occupy_total,

			       SUM(occupy_actual) 			as occupy_actual,

			       SUM(refund_fee) 				as refund_fee,

			       SUM(recommend) 				as recommend,

			       SUM(preferential_value) 		as preferential_value,

			       SUM(apportion) 				as apportion

			  FROM occupy_topagent

			 WHERE occupy_bill_id = bill_id

			 LIMIT 1

		LOOP

			UPDATE occupy_bill SET

			       top_agent_count 			= rec.top_agent_num,

			       occupy_total 			= rec.occupy_total,

			       occupy_actual 			= rec.occupy_actual,

			       effective_transaction 	= rec.effective_transaction,

			       profit_loss 				= rec.profit_loss,

			       rakeback 				= rec.rakeback,

			       rebate 					= rec.rebate,

			       refund_fee 				= rec.refund_fee,

			       recommend 				= rec.recommend,

			       preferential_value 		= rec.preferential_value,

			       apportion 				= rec.apportion

			 WHERE id = bill_id;

		END LOOP;

	END IF;



	RETURN;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, INOUT bill_id BIGINT, op TEXT)

IS 'Lins-总代占成-数据更新';