-- auto gen by linsen 2018-03-04 10:38:26

SELECT redo_sqls($$
ALTER TABLE api_collate_site ADD COLUMN currency VARCHAR(5);
COMMENT ON COLUMN api_collate_site.currency IS '币种';
$$);

DROP TABLE IF EXISTS sys_site_info;
CREATE TABLE IF NOT EXISTS "sys_site_info" (
"siteid" int4 PRIMARY KEY,
"sitename" TEXT,
"masterid" int4,
"mastername" varchar(32),
"usertype" varchar(5),
"subsyscode" varchar(32),
"centerid" int4,
"centername" TEXT,
"operationid" int4,
"operationname" varchar(32),
"operationusertype" varchar(5),
"operationsubsyscode" varchar(32),
"currency" varchar(5),
"timezone" varchar(15)
)
;

COMMENT ON TABLE "gb-stat"."sys_site_info" IS '站点相关资讯.Lins';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."siteid" IS '站点ID';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."sitename" IS '站点名称';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."masterid" IS '站长ID';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."mastername" IS '站长名称';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."usertype" IS '用户类型：0运维，1运营，11运营子账号，2站长，21站长子账号，22总代，221总代子账号，23代理，231代理子账号，24玩家';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."subsyscode" IS '子系统编号 mcenter 站长子账号 mcenterTopAgent 总代 mcenterAgent 代理 pcenter玩家';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."operationid" IS '运营商ID';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."operationname" IS '运营商名称';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."operationusertype" IS '用户类型：0运维，1运营，11运营子账号，2站长，21站长子账号，22总代，221总代子账号，23代理，231代理子账号，24玩家';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."operationsubsyscode" IS '子系统编号 mcenter 站长子账号 mcenterTopAgent 总代 mcenterAgent 代理 pcenter玩家';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."currency" IS '币种';
COMMENT ON COLUMN "gb-stat"."sys_site_info"."timezone" IS '时区';


drop function IF EXISTS gamebox_collect_site_infor(text);
create or replace function gamebox_collect_site_infor(
  hostinfo text
) returns void as $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2015/01/01  Lins    创建此函数: 收集站点相关信息
--v1.10  2017/06/29  Laser   TRUNCATE改为DELETE
--v1.01  2017/07/10  Laser   修改DBLINK连接方式，回收SU
--v1.02  2018/02/28  Laser   修改SELECT * FROM 视图这种糟糕的写法，
                             增加currency、timezone字段
*/
declare
  sql text:='';
  rec record;

BEGIN
  --v1.01  2017/07/10  Laser
  perform dblink_connect_u('mainsite', hostinfo);

  --v1.02  2018/02/28  Laser
  sql:='SELECT *
          FROM dblink (''mainsite'',
                       ''SELECT siteid, sitename, masterid, mastername, usertype, subsyscode, centerid, centername,
                                operationid, operationname, operationusertype, operationsubsyscode, currency, timezone
                           FROM v_sys_site_info'')
        AS s(
             siteid int4,
             sitename VARCHAR,
             masterid int4,
             mastername VARCHAR,
             usertype VARCHAR,
             subsyscode VARCHAR,
             centerid int4,
             centername VARCHAR,
             operationid int4,
             operationname VARCHAR,
             operationusertype VARCHAR,
             operationsubsyscode VARCHAR,
             currency VARCHAR,
             timezone VARCHAR
            )';

  FOR rec in EXECUTE sql LOOP
    raise notice 'name:%', rec.sitename;
  END LOOP;

  --v1.10  2017/06/29  Laser
  --execute 'truncate table sys_site_info';
  DELETE FROM sys_site_info;
  execute 'insert into sys_site_info '||sql;

  perform dblink_disconnect('mainsite');
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_collect_site_infor(hostinfo text)
IS 'Lins-经营报表-收集站点相关信息';


drop function if exists gamebox_operation_profile(TEXT, INT, DATE, TIMESTAMP, TIMESTAMP);
create or replace function gamebox_operation_profile(
	dblink_url 	TEXT,
	sid 	INT,
	stat_date 	DATE,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP
) returns INT AS $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2015/01/01  Fly     创建此函数: 经营概况
--v1.01  2016/05/12  Laser   交易时间由create_time改为bet_time
--v1.02  2016/09/11  Laser   经营概况，增加各种费用的统计
--v1.03  2016/09/12  Laser   修改single_amount由order_no获取
--v1.04  2016/09/18  Laser   增加统计日期，统计开始、结束时间，
                              统计代理增加已审核条件，
                              修正fund_type条件，
                              player_transaction表create_time改为completion_time
--v1.05  2016/09/20  Laser   bet_time改为payout_time，增加删除记录日志
--v1.06  2016/09/21  Laser   存取款不再包含手动存取款，新增代理状态包含123
--v1.07  2016/09/25  Laser   抛弃for循环，交易量从经营报表获取
--v1.08  2016/09/29  Laser   存取款，包含手动存取
--v1.09  2016/10/01  Laser   增加取款总额，存款总额统计
--v1.10  2016/10/02  Laser   优惠不包含返手续费、修正反水条件（人工反水不属于人工存款）
--v1.11  2018/02/06  Laser   修改DBLINK连接方法
*/
DECLARE
	rec 	record;
	gs_id 	INT;
	n_count 	INT;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN
	IF ltrim(rtrim(dblink_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	raise info '清除 % 号统计数据...', stat_date;
	DELETE FROM operation_profile WHERE site_id = sid AND static_date = stat_date;
	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次删除记录数 %', n_count;

	raise info '统计 % 号经营数据.START', stat_date;

  --v1.11  2018/02/06  Laser
  perform dblink_connect_u('master', dblink_url);

	SELECT s.operationid, s.masterid, s.siteid, o.new_player, o.new_agent, o.new_player_deposit, o.deposit_new_player,
				 o.deposit_player, o.deposit_amount, o.deposit_total, o.withdrawal_player, o.withdrawal_amount, o.withdrawal_total,
				 o.rakeback_amount + o.favorable_amount + o.recommend_amount + o.refund_amount + o.rebate_amount as expenditure,
				 o.rakeback_player, o.rakeback_amount, o.favorable_player, o.favorable_amount,
				 o.recommend_player, o.recommend_amount, o.refund_player, o.refund_amount,
				 o.rebate_player, o.rebate_amount, o.transaction_player,
				 so.effective_transaction_volume, so.transaction_profit_loss, so.single_amount
		INTO rec
		FROM dblink ('master',
				'SELECT (SELECT gamebox_current_site()) 	as site_id, --站点ID
				(SELECT COUNT(1) FROM sys_user
				  WHERE user_type = ''24''
				    AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''') as new_player, --新增玩家
				(SELECT COUNT(1) FROM sys_user
				  WHERE user_type = ''23''
				    AND status IN (''1'', ''2'', ''3'')
				    AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''') as new_agent, --新增代理

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE player_id IN (SELECT id FROM sys_user WHERE user_type = ''24'' AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''')
				    AND completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND (fund_type <> ''artificial_deposit'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as new_player_deposit, --新玩家存款人数

				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE player_id IN (SELECT id FROM sys_user WHERE user_type = ''24'' AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''')
				    AND completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND (fund_type <> ''artificial_deposit'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as deposit_new_player, --新增玩家存款（包含人工存款——人工存取）

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND (fund_type <> ''artificial_deposit'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as deposit_player, --当日存款人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND (fund_type <> ''artificial_deposit'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as deposit_amount, --当日存款（包含人工存款——人工存取）
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND status = ''success'') 		as deposit_total, --当日存款总额（包含所有人工存款）

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''withdrawals''
				    AND (fund_type <> ''artificial_withdraw'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as withdrawal_player, --当日取款人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''withdrawals''
				    AND (fund_type <> ''artificial_withdraw'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as withdrawal_amount, --当日取款（包含人工取款——人工存取）
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''withdrawals''
				    AND status = ''success'') 		as withdrawal_total, --当日取款（包含所有人工取款）

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND (transaction_type = ''backwater'' OR
				        --包含人工反水
				         (transaction_type = ''favorable'' AND transaction_way = ''manual_rakeback''))
				    AND status = ''success'') 		as rakeback_player, --反水人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND (transaction_type = ''backwater'' OR
				       --包含人工反水
				         (transaction_type = ''favorable'' AND transaction_way = ''manual_rakeback''))
				    AND status = ''success'') 		as rakeback_amount, --反水金额

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND (transaction_type = ''favorable''
				         --包含人工存入优惠，不包含人工反水、返手续费
				         AND fund_type <> ''refund_fee''
				         AND transaction_way <> ''manual_rakeback'')
				    AND status = ''success'') 		as favorable_player, --优惠人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND (transaction_type = ''favorable''
				         --包含人工存入优惠，不包含人工反水、返手续费
				         AND fund_type <> ''refund_fee''
				         AND transaction_way <> ''manual_rakeback'')
				    AND status = ''success'') 		as favorable_amount, --优惠金额

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND fund_type = ''recommend''
				    AND status = ''success'') 		as recommend_player, --推荐人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND fund_type = ''recommend''
				    AND status = ''success'') 		as recommend_amount, --推荐金额

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND fund_type = ''refund_fee''
				    AND status = ''success'') 		as refund_player, --返手续费人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND fund_type = ''refund_fee''
				    AND status = ''success'') 		as refund_amount, --返手续费金额

				(SELECT COUNT(DISTINCT ra.agent_id)
				   FROM rebate_agent ra
				  WHERE ra.settlement_time >= '''||start_time||''' AND ra.settlement_time < '''||end_time||'''
				    AND ra.settlement_state = ''lssuing'') 		as rebate_player, --返佣人数
				(SELECT COALESCE(SUM(ra.rebate_actual), 0.00)
				   FROM rebate_agent ra
				  WHERE ra.settlement_time >= '''||start_time||''' AND ra.settlement_time < '''||end_time||'''
				    AND ra.settlement_state = ''lssuing'') 		as rebate_amount, --返佣金额

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_game_order
				  WHERE payout_time >= '''||start_time||''' AND payout_time < '''||end_time||'''
				    AND order_state = ''settle'') as transaction_player --当日交易玩家数
				')
/*--v1.07  2016/09/25  Laser
				(SELECT COALESCE(SUM(effective_trade_amount), 0.00)
				   FROM player_game_order
				  WHERE payout_time >= '''||start_time||''' AND payout_time < '''||end_time||'''
				    AND order_state = ''settle'') as effective_transaction_volume, --当日有效交易量

				(SELECT COALESCE(SUM(profit_amount), 0.00)
				   FROM player_game_order
				  WHERE payout_time >= '''||start_time||''' AND payout_time < '''||end_time||'''
				    AND order_state = ''settle'') as transaction_profit_loss, --当日盈亏

				(SELECT COUNT(order_no)
				   FROM player_game_order
				  WHERE payout_time >= '''||start_time||''' AND payout_time < '''||end_time||'''
				    AND order_state = ''settle'') 		as single_amount --交易单量
*/

			AS o(site_id int, new_player int, new_agent int, new_player_deposit int, deposit_new_player numeric,
				 deposit_player int, deposit_amount numeric, deposit_total numeric, withdrawal_player int, withdrawal_amount numeric, withdrawal_total numeric,
				 rakeback_player int, rakeback_amount numeric, favorable_player int, favorable_amount numeric,
				 recommend_player int, recommend_amount numeric, refund_player int, refund_amount numeric,
				 rebate_player int, rebate_amount numeric, transaction_player int)
				 /*,--v1.07  2016/09/25  Laser
				 effective_transaction_volume numeric, transaction_profit_loss numeric, single_amount numeric
				 */
		LEFT JOIN sys_site_info s ON o.site_id = s.siteid
		LEFT JOIN (SELECT site_id 	siteid,
										  master_id masterid,
										  center_id 	operationid,
										  --SUM(transaction_volume) 	transaction_volume,
										  SUM(effective_transaction) 	effective_transaction_volume,
										  SUM(profit_loss) 	transaction_profit_loss,
										  SUM(transaction_order) 	single_amount
								 FROM site_operate so
								WHERE site_id = sid
								  AND static_date = stat_date
								GROUP BY site_id, master_id, center_id) so
		ON o.site_id = so.siteid;

	INSERT INTO operation_profile (
	  center_id, master_id, site_id, static_time,
	  new_agent, new_player, new_player_deposit, deposit_new_player,
	  deposit_player, deposit_amount, deposit_total, withdrawal_player, withdrawal_amount, withdrawal_total,
	  expenditure, rakeback_player, rakeback_amount, favorable_player, favorable_amount,
	  recommend_player, recommend_amount, refund_player, refund_amount,
	  rebate_player, rebate_amount, single_amount, static_date, static_time_end, transaction_player,
	  effective_transaction_volume, transaction_profit_loss
	) VALUES (
	  rec.operationid, rec.masterid, rec.siteid, start_time,
	  rec.new_agent, rec.new_player, rec.new_player_deposit, rec.deposit_new_player,
	  rec.deposit_player, rec.deposit_amount, rec.deposit_total, rec.withdrawal_player, rec.withdrawal_amount, rec.withdrawal_total,
	  rec.expenditure, rec.rakeback_player, rec.rakeback_amount, rec.favorable_player, rec.favorable_amount,
	  rec.recommend_player, rec.recommend_amount, rec.refund_player, rec.refund_amount,
	  rec.rebate_player, rec.rebate_amount, rec.single_amount, stat_date, end_time, rec.transaction_player,
	  rec.effective_transaction_volume, rec.transaction_profit_loss
	) RETURNING id into gs_id;

	raise info 'operation_profile.新增.键值 = %', gs_id;

	raise info '统计 % 号经营数据.END', stat_date;

  perform dblink_disconnect('master');

  RETURN 0;

EXCEPTION
  WHEN QUERY_CANCELED THEN
    perform dblink_disconnect_all();
    RETURN 2;
  WHEN OTHERS THEN
    perform dblink_disconnect_all();

    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    RETURN 2;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_profile(dblink_url TEXT, sid INT, stat_date DATE, start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Fly-经营概况';


drop function if exists gamebox_station_bill_master(hstore, hstore, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_station_bill_master(
  sys_map   hstore,    -- 优惠分摊比例
  dict_map   hstore,    -- 运营商，站长，站点，年，月，账务类型
  url_name   TEXT,
  main_url   TEXT,
  start_time   TEXT,
  end_time   TEXT
) returns INT AS $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2015/01/01  Lins    创建此函数: 站点账务-API
--v1.01  2016/05/20  Laser   改用新的运营商占成函数
--v1.02  2016/05/25  Laser   上期未结需要计算应付和实付
--v1.03  2016/05/28  Laser   bill_other增加api占成总金额
--v1.04  2016/06/09  Laser   如果未设置返还盈利、减免维护费，则不生成station_profit_loss记录
--v1.05  2016/10/29  Laser   包网方案修改，对于BBIN和视讯类游戏，允许API互抵
--v1.06  2016/11/01  Laser   未设置减免维护费，依然需要计算维护费
--v10.7  2017/08/01  Laser   API盈亏由经营报表取，增加占成比率
--v10.8  2018/02/06  Laser   修改DBLINK连接方法
*/
DECLARE
  net_maps   hstore[];
  api_id     INT;
  api     TEXT;
  game_type   TEXT;
  profit_loss FLOAT;
  occupy_proportion FLOAT;
  amount_payable FLOAT;

  bill_id   INT;
  bill_year   INT;
  bill_month   INT;

  id       INT;
  name     TEXT;
  val     TEXT;    -- 单个API单个GameType占成方案
  vals     TEXT[];
  sval     TEXT[];
  keys     TEXT[];
  key_name   TEXT:='';

  map     hstore;
  cost_map   hstore;

  category   TEXT:='';
  value     FLOAT;
  h_keys     TEXT[]:=array['-1'];  -- 记录已存在ID.
  amount     FLOAT:=0.00;      -- 应付总额（各API盈亏(盈利)）
  expense   FLOAT:=0.00;      -- 分摊费用.
  lower_values FLOAT[];        -- 梯度数组 --v1.01
  limit_values FLOAT[];        -- 梯度数组
  retios     FLOAT[];        -- 占成数组

  is_max     boolean:=false;
  sid     INT;           -- 站点ID.
  cur     refcursor;        -- 每个API的占成
  rec     record;
  trade_amount FLOAT:=0.00;
  profilt_amount FLOAT:=0.00;

  occupy     FLOAT:=0.00;      -- API占成（除视讯）
  occupy_tatol  FLOAT:=0.00;  -- API占成总金额 --v1.03  2016/05/28  Laser
  occupy_live  FLOAT:=0.00;  -- 视讯类API占成

  assume     BOOLEAN:=false;      -- 单个API是否盈亏共担
  fee     FLOAT:=0.00;      -- 费用
  no_bill   FLOAT:=0.00;      -- 上期未结金额
  maintenance_charges FLOAT:=0.00;  -- 维护费
  ensure_consume FLOAT:=0.00;      -- 保底消费
  reduction_maintenance_fee FLOAT:=0.00;     -- 减免维护费
  redu_main_fee_actual FLOAT:=0.00;  -- 减免维护费（最高=维护费）
  actual_maintenance_charges FLOAT:=0.00;    -- 实际维护费
  return_profit FLOAT:=0.00;      -- 返盈利
  actual_return_profit FLOAT:=0.00;  -- 实际返盈利

  net_map   hstore;    -- 包网方案map
  occupy_map   hstore;    -- API占成梯度map
  assume_map   hstore;    -- 盈亏共担map.
  charge_map   hstore;   -- 维护费用map.
  favorable_map hstore;  -- 优惠map
  code     TEXT:='';  -- 其它项目代码（maintenance_charges：维护费，ensure_consume：保底费，return_profit：反盈利，reduction_maintenance_fee：减免维护费，pending：上期未结，rakeback_offers：返水优惠，offers_recommended：优惠急推荐，back_charges：返手续费，rebate：佣金）
  sys_config   hstore;    -- 系统变量
  prev_map  hstore;    -- 上期信息（未结金额，经办人）
  operator  TEXT:='';  -- 上期未结算经办人

  sp       TEXT:='@';
  rs       TEXT:='\~';
  cs       TEXT:='\^';
  rs_a     TEXT:='';
  cs_a     TEXT:='';
  sp_a     TEXT:='';

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN
  -- 取得系统变量
  SELECT sys_config() INTO sys_config;
  sp = sys_config->'sp_split';
  rs = sys_config->'row_split';
  cs = sys_config->'col_split';
  sp_a = sys_config->'sp_split_a';
  rs_a = sys_config->'row_split_a';
  cs_a = sys_config->'col_split_a';
  rs_a = '\^&\^';
  cs_a = '\^';

  -- 取得当前站点的包网方案
  sid = sys_map->'site_id';

  --v10.8  2018/02/06  Laser
  perform dblink_connect_u('mainsite', main_url);
  SELECT  * FROM dblink('mainsite', 'SELECT gamebox_contract('||sid||', '||is_max||')') as a(hash hstore[]) INTO net_maps;
  perform dblink_disconnect('mainsite');

  net_map = net_maps[1];
  occupy_map = net_maps[2];
  --assume_map = net_maps[3]; --v1.05  2016/10/29  Laser
  charge_map = net_maps[4];
  favorable_map = net_maps[5];

  amount = 0.00;
  SELECT put(dict_map, 'op', 'I') into dict_map;
  -- 准备station_bill.
  SELECT gamebox_station_bill(dict_map) INTO bill_id;

  -- 每个API的占成
  --v10.7  2017/08/01  Laser
  --SELECT gamebox_operation_occupy_api(url_name, start_time, end_time) INTO cur;
  SELECT gb_operation_occupy_api(sid, start_time::timestamp, end_time::timestamp) INTO cur;
  FETCH cur into rec;
  -- raise info '每个API的占成(rec) = %', rec;

  WHILE FOUND
  LOOP
    api       = rec.api_id::TEXT;
    game_type     = rec.game_type;
    profilt_amount   = rec.profit_amount;
    trade_amount   = rec.trade_amount;
    --v1.05  2016/10/29  Laser
    --assume       = COALESCE((assume_map->api)::BOOLEAN, FALSE); -- 是否盈亏共担
    assume       = FALSE; --目前没有盈亏共担一说
    key_name     = api||'_'||game_type;
    val       = COALESCE((occupy_map->key_name)::TEXT, '');
    IF val != '' THEN
      --v1.01
      SELECT gamebox_operation_occupy_to_array(val, 1) INTO lower_values;  -- 梯度
      SELECT gamebox_operation_occupy_to_array(val, 2) INTO limit_values;  -- 梯度
      SELECT gamebox_operation_occupy_to_array(val, 3) INTO retios;
      --raise info 'lower_values = %', lower_values;
      --raise info 'limit_values = %', limit_values;
      --raise info 'retios = %', retios;
      SELECT gamebox_operation_occupy_calculate(lower_values, limit_values, retios, profilt_amount, assume) INTO occupy;
      --v10.7  2017/08/01  Laser
      occupy_proportion = 0;
      IF profilt_amount <> 0 THEN
        occupy_proportion = occupy / profilt_amount * 100;
      END IF;

      --v1.01
      raise info 'api_id = %, game_type = %, 盈亏 = %, 占成 = %', api, game_type, profilt_amount, occupy;

      --BBIN和视讯类特殊处理 --v1.05  2016/10/29  Laser
      IF rec.api_id = 10 OR game_type = 'LiveDealer' THEN
        occupy_live = occupy_live + COALESCE(occupy, 0.00);
      ELSE
        -- 盈亏不共担时且占成金额为负时，计0
        IF assume = FALSE AND occupy < 0.00 THEN
          occupy = 0.00;
        END IF;

        -- 累计占成金额
        --amount = amount + COALESCE(occupy, 0.00);
        occupy_tatol = occupy_tatol + COALESCE(occupy, 0.00); --v1.03  2016/05/28  Laser
        --RAISE INFO 'occupy_tatol: %', occupy_tatol;

      END IF;

      SELECT put(map, 'api_id', api) into map;      -- API_ID
      SELECT put(map, 'game_type', game_type) into map;  -- API二级分类
      SELECT put(map, 'amount_payable', occupy::TEXT) into map;     --应付金额
      SELECT put(map, 'occupy_proportion', occupy_proportion::TEXT) into map; --占成百分比 --v10.7  2017/08/01  Laser
      SELECT put(map, 'profit_loss', profilt_amount::TEXT) into map;  --盈亏总和
      SELECT put(map, 'bill_id', bill_id::TEXT) into map;
      -- 新增各API占成金额
      perform gamebox_station_profit_loss(map);

    END IF;
    FETCH cur INTO rec;
  END LOOP;

  CLOSE cur;

  --v1.05  2016/10/29  Laser
  IF occupy_live < 0 THEN
    occupy_live = 0.00;
  END IF;

  --amount := amount + occupy_tatol; --v1.03  2016/05/28  Laser
  amount := amount + occupy_live + occupy_tatol; --v1.05  2016/10/29  Laser

  -- 计算其它费用.
  -- raise info '------ 各API盈亏(amount) = %', amount;
  SELECT put(map, 'bill_id', bill_id::TEXT) into map;
  SELECT put(map, 'occupy_tatol', occupy_tatol::TEXT) into map; --v1.03  2016/05/28  Laser
  SELECT put(map, 'payable', '0') into map;
  SELECT put(map, 'actual', '0') into map;
  SELECT put(map, 'apportion', '0') into map;

  --------- 上期未结费用.START
  code = 'pending';
  bill_year = (dict_map->'year')::INT;
  bill_month = (dict_map->'month')::INT;
  SELECT gamebox_station_bill_prev(sid, bill_year, bill_month, '1') INTO prev_map;
  no_bill = COALESCE(prev_map->'no_bill_actual', '0.00');  --v1.02  2016/05/25  Laser
  operator = prev_map->'operator';
  SELECT put(map, 'name', operator) into map;
  SELECT put(map, 'code', code) into map;
  SELECT put(map, 'payable', prev_map->'no_bill_payable'::TEXT) into map;  --v1.02  2016/05/25  Laser
  SELECT put(map, 'actual', prev_map->'no_bill_actual'::TEXT) into map;  --v1.02  2016/05/25  Laser
  SELECT put(map, 'fee', '0.00') into map;
  perform gamebox_station_bill_other(map);
  --------- 上期未结费用.END

  SELECT put(map, 'name', '~') into map;

  --------- 保底费用.START
  ensure_consume = COALESCE((net_map->'ensure_consume')::FLOAT, 0.00);
  code = 'ensure_consume';
  SELECT put(map, 'code', code) into map;
  SELECT put(map, 'payable', ensure_consume::TEXT) into map;
  IF amount > ensure_consume THEN -- 盈亏大于保底费，不收保底费
    ensure_consume = 0.00;
  END IF;
  SELECT put(map, 'actual', ensure_consume::TEXT) into map;
  SELECT put(map, 'fee', ensure_consume::TEXT) into map;
  perform gamebox_station_bill_other(map);
  --------- 保底费用.END

  -- 维护费 --v1.05  2016/10/29  Laser
  maintenance_charges = COALESCE((net_map->'maintenance_charges')::FLOAT, 0.00);
  --RAISE INFO '维护费：%', maintenance_charges;
  --------- 减免维护费.START
  IF charge_map is not null THEN --v1.04  2016/06/09
    code = 'reduction_maintenance_fee';
    SELECT gamebox_operation_favorable_calculate(charge_map, amount) INTO cost_map;

    IF amount > 0 THEN
      reduction_maintenance_fee = COALESCE((cost_map->'value')::FLOAT, 0.00);
    ELSE
      reduction_maintenance_fee = 0.00;
    END IF;

    -- 减免维护费上限 = 全部维护费
    redu_main_fee_actual = reduction_maintenance_fee;
    IF redu_main_fee_actual > maintenance_charges THEN
      redu_main_fee_actual = maintenance_charges;
    END IF;

    SELECT put(map, 'code', code) into map;
    SELECT put(map, 'payable', reduction_maintenance_fee::TEXT) into map;
    SELECT put(map, 'actual', redu_main_fee_actual::TEXT) into map;
    SELECT put(map, 'fee', '0.00') into map;
    SELECT put(map, 'value', reduction_maintenance_fee::TEXT) into map;
    SELECT put(map, 'grads', COALESCE(cost_map->'grads', '0')) into map;
    SELECT put(map, 'way', COALESCE(cost_map->'way', '0')) into map;
    SELECT put(map, 'limit', COALESCE(cost_map->'limit', '0')) into map;

    map = cost_map||map;
    perform gamebox_station_bill_other(map);
    --------- 减免维护费.END
  END IF; --v1.05  2016/10/29  Laser
    --------- 维护费.START
    code = 'maintenance_charges';
    actual_maintenance_charges = maintenance_charges - redu_main_fee_actual;
    SELECT put(map, 'payable', maintenance_charges::TEXT) into map;
    SELECT put(map, 'actual', actual_maintenance_charges::TEXT) into map;
    SELECT put(map, 'code', code) into map;
    SELECT put(map, 'fee', maintenance_charges::TEXT) into map;
    SELECT put(map, 'value', '0') into map;
    SELECT put(map, 'grads', '0') into map;
    SELECT put(map, 'way', '0') into map;
    SELECT put(map, 'limit', '0') into map;
    perform gamebox_station_bill_other(map);
  --END IF; --v1.05  2016/10/29  Laser
  --------- 维护费.END

  --------- 返盈利.START
  IF charge_map is not null THEN --v1.04  2016/06/09
    code = 'return_profit';
    SELECT gamebox_operation_favorable_calculate(favorable_map, amount) INTO cost_map;
    IF amount > 0 THEN
      return_profit = COALESCE((cost_map->'value')::FLOAT, 0.00);
    ELSE
      return_profit = 0.00;
    END IF;
    actual_return_profit = COALESCE(cost_map->'actual', '0');
    SELECT put(map, 'code', code) into map;
    SELECT put(map, 'payable', return_profit::TEXT) into map;
    SELECT put(map, 'actual', actual_return_profit::TEXT) into map;
    SELECT put(map, 'fee', '0.00') into map;
    SELECT put(map, 'value', return_profit::TEXT) into map;
    SELECT put(map, 'grads', COALESCE(cost_map->'grads', '0')) into map;
    SELECT put(map, 'way', COALESCE(cost_map->'way', '0')) into map;
    SELECT put(map, 'limit', COALESCE(cost_map->'limit', '0')) into map;
    --------- 返盈利.END

    map = map||cost_map;
    perform gamebox_station_bill_other(map);
  END IF;

  IF amount < 0 THEN          -- 各API盈亏为负
    amount = amount + ensure_consume;
  ELSEIF amount < ensure_consume THEN  -- 各API盈亏小于保底消费
    amount = ensure_consume;
  END IF;

  -- 站长付给运营商账务 = 各API盈亏 + 上期未结 + 维护费 - 实付减免维护费 - 实付返盈利
  fee = amount + no_bill +  maintenance_charges - redu_main_fee_actual - actual_return_profit;
  -- raise info '-------- API占成 = %', amount;
  -- raise info '-------- 应付金额 = %', fee;
  --更新账务.
  SELECT put(dict_map, 'bill_id', bill_id::TEXT) INTO dict_map;
  SELECT put(dict_map, 'op', 'U') INTO dict_map;
  SELECT put(dict_map, 'amount', fee::TEXT) into dict_map;
  -- raise info '------ dict_map = %', dict_map;
  SELECT gamebox_station_bill(dict_map) INTO bill_id;

  RETURN 0;

EXCEPTION
  WHEN QUERY_CANCELED THEN
    perform dblink_disconnect_all();
    RETURN 2;
  WHEN OTHERS THEN
    perform dblink_disconnect_all();

    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    RETURN 2;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_master(sys_map hstore, dict_map hstore, url_name TEXT, main_url TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-站点账务-API';


DROP FUNCTION IF EXISTS gb_api_collate_site(TEXT, TEXT, TEXT, TEXT, TEXT, INT);
CREATE OR REPLACE FUNCTION gb_api_collate_site(
  p_comp_url    TEXT,
  p_static_date TEXT,
  p_siteid      TEXT,
  p_site_url    TEXT,
  p_apis        TEXT,
  p_stat_days   INT
) returns text as $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2018/01/18  Laser   API注单核对: API注单核对-站点报表
--v1.01  2018/01/29  Laser   删除无用参数
--v1.02  2018/02/06  Laser   修改关闭连接的方法

参数说明 p_apis: 执行哪些api，多个用','分隔，如'1,2,3,4'，输入空串''表示执行所有api
*/
DECLARE

  rtn text:='';
  tmp text:='';
  v_static_date  varchar;
  --v_start_time   varchar;
  --v_end_time     varchar;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  FOR i IN 0..p_stat_days - 1 LOOP

    v_static_date := (p_static_date::DATE + (i||'day')::INTERVAL)::DATE::TEXT;

    RAISE INFO '%.', v_static_date;

    --raise notice '当前站点库信息：%', p_site_url;
    IF p_site_url is null OR trim(p_site_url) = '' THEN
      return '站点库信息不能为空';
    END IF;

    --连接站点库
    perform dblink_connect_u('master', p_site_url);

    tmp = '    ┗ 开始收集站点id['||p_siteid||'],日期['|| v_static_date ||']API核对报表：';
    raise notice '%', tmp;
    --执行玩家API报表
    rtn = rtn||chr(13)||chr(10)||tmp;
    SELECT P .msg
      FROM
      dblink ('master',
              'SELECT * FROM gb_api_collate_player('''||p_comp_url||''', '''||v_static_date||''', '''||p_apis||''')'
      ) AS P (msg TEXT)
      INTO tmp ;
    rtn = rtn||tmp;
    raise notice '收集完毕';
    --收集站点API报表
    rtn = rtn||chr(13)||chr(10)||'        ┗2.正在执行站点API核对报表：';
    SELECT gb_api_collate_site_create('master', p_siteid, v_static_date) into tmp; --v1.01  2018/01/29  Laser
    rtn = rtn||'||'||tmp;
    perform dblink_disconnect('master');

    rtn = rtn||chr(13)||chr(10)||'    ┗收集完毕';
  END LOOP;

  return rtn;
EXCEPTION
  WHEN QUERY_CANCELED THEN
    --v1.02  2018/02/06  Laser
    --perform dblink_close_all();
    perform dblink_disconnect_all();
    RETURN 2;
  WHEN OTHERS THEN
    --perform dblink_close_all();
    perform dblink_disconnect_all();

    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    RETURN 2;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gb_api_collate_site(p_comp_url text, p_static_date  text, p_siteid text, p_site_url text, p_apis text, p_stat_days  int)
IS 'Laser-API注单核对-站点经营报表';


DROP FUNCTION IF EXISTS gb_api_collate_site_create(TEXT, TEXT, TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS gb_api_collate_site_create(TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_api_collate_site_create(
  p_conn   TEXT,
  p_siteid  TEXT,
  p_curday   TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2018/01/19  Laser    创建此函数: API注单核对-站点报表
--v1.01  2018/01/19  Laser    增加时间分组条件，删除无用参数start_time、end_time
--v1.02  2018/02/28  Laser   增加currency字段
*/
DECLARE
  rtn   text:='';
  v_count  int:=0;
  d_static_date DATE;
BEGIN

  d_static_date := to_date(p_curday, 'YYYY-MM-DD');
  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||chr(13)||chr(10)||'          |清除当天的统计数据，保证每天只作一次统计||';
  DELETE FROM api_collate_site WHERE static_date = d_static_date AND site_id = p_siteid::INT;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  raise notice '本次删除记录数 %',  v_count;
  rtn = rtn||'|执行完毕，删除记录数: '||v_count||' 条||';

  --开始执行站点经营报表信息收集
  rtn = rtn||chr(13)||chr(10)||'          |开始汇总API经营报表';
  INSERT INTO api_collate_site(
    site_id, site_name, center_id, center_name, master_id, master_name,  currency, --v1.02  2018/02/28  Laser
    player_num, api_id, api_type_id, game_type,
    static_date, static_time, static_time_end, create_time,
    transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  ) SELECT
      s.siteid, s.sitename, s.operationid, s.operationname, s.masterid, s.mastername, s.currency, --v1.02  2018/02/28  Laser
      acp.players_num, acp.api_id, acp.api_type_id, acp.game_type,
      d_static_date, static_time, static_time_end, now(),
      acp.transaction_order, acp.transaction_volume, acp.effective_transaction,
      acp.transaction_profit_loss,  winning_amount, contribution_amount
    FROM
      dblink (p_conn,
              'SELECT site_id, api_id, game_type, api_type_id, static_time, static_time_end,
                      COUNT (player_id)           as players_num,
                      SUM (transaction_order)     as transaction_order,
                      SUM (transaction_volume)    as transaction_volume,
                      SUM (effective_transaction) as effective_transaction,
                      SUM (profit_loss)           as transaction_profit_loss,
                      SUM(winning_amount)         as winning_amount,
                      SUM(contribution_amount)    as contribution_amount
                 FROM api_collate_player
                WHERE static_date = ''' || p_curday || '''
                GROUP BY site_id,api_id,game_type,api_type_id, static_time, static_time_end
              '
              )
    AS acp (
            site_id int,
            api_id int,
            game_type varchar,
            api_type_id int,
            static_time timestamp,
            static_time_end timestamp,
            players_num bigint ,
            transaction_order NUMERIC ,
            transaction_volume NUMERIC,
            effective_transaction NUMERIC,
            transaction_profit_loss NUMERIC,
            winning_amount NUMERIC,
            contribution_amount NUMERIC
           ) LEFT JOIN sys_site_info s ON acp.site_id = s.siteid;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  raise notice '本次插入数据量 %', v_count;
    rtn = rtn||'|执行完毕，新增记录数: '||v_count||' 条||';
  return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gb_api_collate_site_create( p_conn TEXT, p_siteid TEXT, p_curday TEXT)
IS 'Lins-经营报表-站点报表';


CREATE OR REPLACE FUNCTION redo_sqls(sqls text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
/*版本更新说明
--版本   时间        作者   内容
--v1.00  2015/01/01  Will   创建此函数
--v1.10  2016/05/12  Laser  优化代码，修改查询条件限制为当前Schema
--v1.11  2017/08/16  Laser  增加对rename各种对象的支持
--v1.12  2018/01/28  Laser  改为执行原语句

*/
DECLARE
  arr TEXT[];
  tmp VARCHAR[];
  s TEXT;
  obj_name VARCHAR;
  sql_str VARCHAR;
  cnt INT := 0;

BEGIN
  SELECT regexp_split_to_array(sqls, ';') INTO arr;
  <<lbl1>>FOREACH s IN array arr
  LOOP

    --v1.12  2018/01/28  Laser
    cnt = 0;
    s := trim(s, chr(13)||chr(10));
    sql_str = s;
    sql_str := trim(sql_str, ' ');
    sql_str := lower(sql_str);
    sql_str := replace(sql_str, '"', '');

    --raise info 'sql_str: %', sql_str;
    IF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+add\s+column\s+\S+') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+add\s+column\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      --SELECT count(*) INTO cnt FROM information_schema.columns WHERE table_schema='public' AND table_name=obj_name AND column_name=tmp[2];
      SELECT count(*) INTO cnt
        FROM information_schema.columns
       WHERE table_name = obj_name
         AND column_name = tmp[2]
         AND table_schema = current_schema;

    ELSEIF regexp_matches(sql_str, 'create\s+sequence \S+') IS NOT NULL THEN
      obj_name := (regexp_matches(sql_str, 'create\s+sequence (\S+)'))[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      --SELECT count(*) INTO cnt FROM pg_class WHERE relkind='S' AND relname=obj_name AND pg_table_is_visible(oid);
      SELECT count(*) INTO cnt
        FROM pg_class
       WHERE relkind = 'S'
         AND relname = obj_name
         AND pg_table_is_visible(oid);

    ELSEIF regexp_matches(sql_str, 'create(\s+\S+\s+|\s+)index\s+\S+\s+on\s+\S+') IS NOT NULL THEN
      obj_name := (regexp_matches(sql_str, 'create(\s+\S+\s+|\s+)index\s+(\S+)\s+on\s+\S+'))[2];
      --SELECT count(*) INTO cnt FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind = 'i' AND c.relname = obj_name;
      SELECT count(*) INTO cnt
        FROM pg_class c
        JOIN pg_namespace n
          ON c.relnamespace = n.oid
       WHERE c.relkind = 'i'
         AND c.relname = obj_name
         AND n.nspname = current_schema;

    ELSEIF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+add\s+constraint\s+\S+') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+add\s+constraint\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      --SELECT count(*) INTO cnt FROM information_schema.constraint_column_usage WHERE table_name = obj_name AND constraint_name = tmp[2];
      SELECT count(*) INTO cnt
        FROM information_schema.constraint_table_usage
       WHERE table_name = obj_name
         AND constraint_name = tmp[2]
         AND constraint_schema = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+table\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      SELECT count(*) INTO cnt
        FROM information_schema.tables
       WHERE table_name = tmp[3]
         AND table_schema = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+sequence\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+sequence\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      SELECT count(*) INTO cnt
        FROM information_schema.sequences
       WHERE sequence_name = tmp[3]
         AND sequence_schema = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+index\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+index\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)');
      obj_name := tmp[1];
      --SELECT count(*) INTO cnt FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind = 'i' AND c.relname = obj_name;
      SELECT count(*) INTO cnt
        FROM pg_class c
        JOIN pg_namespace n
          ON c.relnamespace = n.oid
       WHERE c.relkind = 'i'
         AND c.relname = tmp[3]
         AND n.nspname = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+rename\s+constraint\s+\S+\s+to\s+\S+') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+rename\s+constraint\s+(\S+)\s+to\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      SELECT count(*) INTO cnt
        FROM information_schema.constraint_table_usage
       WHERE table_name = obj_name
         AND constraint_name = tmp[3]
         AND constraint_schema = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+rename\s+column\s+\S+\s+to\s+\S+') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+rename\s+column\s+(\S+)\s+to\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      SELECT count(*) INTO cnt
        FROM information_schema.columns
       WHERE table_name = obj_name
         AND column_name = tmp[3]
         AND table_schema = current_schema;

    END IF;

    IF cnt = 0 AND s <> '' THEN
      RAISE NOTICE '【run SQL】 : %', s;
      execute s;
    ELSEIF cnt > 0 AND s <> '' THEN
      RAISE NOTICE '【skip SQL】 : %', s;
    END IF;

  END LOOP lbl1;

END;
$function$
;
COMMENT ON FUNCTION redo_sqls(sqls text)
IS 'Will-重复执行脚本';
