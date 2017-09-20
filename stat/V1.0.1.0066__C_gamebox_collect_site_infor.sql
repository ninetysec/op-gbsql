-- auto gen by cherry 2017-09-20 21:00:32
drop function IF EXISTS gamebox_collect_site_infor(text);
create or replace function gamebox_collect_site_infor(
  hostinfo text
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 收集站点相关信息
--v1.10  2017/06/29  Leisure  TRUNCATE改为DELETE
--v1.01  2017/07/10  Leisure  修改DBLINK连接方式，回收SU
*/
declare
  sql text:='';
  rec record;

BEGIN
  --v1.01  2017/07/10
  perform dblink_connect_u('mainsite', hostinfo);

  sql:='SELECT s.siteid,         s.sitename,
         s.masterid,       s.mastername,
         s.usertype,       s.subsyscode,
           s.operationid,     s.operationname,
           s.operationusertype,   s.operationsubsyscode
        FROM dblink (''mainsite'', ''SELECT * from v_sys_site_info'')
        as s(
             siteid int4,
             sitename VARCHAR,
             masterid int4,
             mastername VARCHAR,
             usertype VARCHAR,
             subsyscode VARCHAR,
             operationid int4,
             operationname VARCHAR,
             operationusertype VARCHAR,
             operationsubsyscode VARCHAR
            )';

  FOR rec in EXECUTE sql LOOP
    raise notice 'name:%', rec.sitename;
  END LOOP;

  --v1.10  2017/06/29  Leisure
  --execute 'truncate table sys_site_info';
  DELETE FROM sys_site_info;
  execute 'insert into sys_site_info '||sql;

  perform dblink_disconnect('mainsite');
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_collect_site_infor(hostinfo text)
IS 'Lins-经营报表-收集站点相关信息';


DROP FUNCTION IF EXISTS gamebox_site_map(INT);
CREATE OR REPLACE FUNCTION gamebox_site_map(
  sid INT
) returns hstore AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 收集站点相关信息
--v1.01  2017/08/01  Leisure  TRUNCATE改为DELETE
*/
DECLARE
  rec     record;
  dict_map   hstore;
BEGIN
  FOR rec IN
    SELECT  * FROM sys_site_info WHERE siteid = sid
  LOOP
    SELECT 'site_id=>'||rec.siteid INTO dict_map;
    IF rec.sitename != null AND rec.sitename != '' THEN
      dict_map = (SELECT ('site_name=>"'||rec.sitename||'"')::hstore)||dict_map;
    END IF;
    dict_map = (SELECT ('master_id=>'||rec.masterid)::hstore)||dict_map;
    dict_map = (SELECT ('master_name=>'||rec.mastername)::hstore)||dict_map;
    dict_map = (SELECT ('center_id=>'||rec.operationid)::hstore)||dict_map;
    dict_map = (SELECT ('center_name=>'||rec.operationname)::hstore)||dict_map;
  END LOOP;
  IF dict_map is null THEN
    SELECT '-1=>-1' INTO dict_map;
  END IF;

  RETURN dict_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_map(sid INT)
IS 'Lins-站点信息';


drop function if exists gamebox_station_bill(TEXT, TEXT, TEXT, TEXT, INT);
create or replace function gamebox_station_bill(
  main_url   TEXT,
  master_url   TEXT,
  start_time   TEXT,
  end_time   TEXT,
  flag   INT
) returns TEXT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 账务(站长、总代)-入口
--v1.01  2016/06/04  Leisure  取dict_map之前，先同步site_info表,
                              如果账务日期不为1号，则取1号日期
--v1.10  2017/07/05  Leisure  改变sys_site_info同步方式
--v1.11  2017/07/10  Leisure  修改DBLINK连接方式，回收SU
*/
DECLARE
  rec     record;
  cnum     INT;

  category   TEXT:='API';
  keys     TEXT[];
  sub_keys   TEXT[];
  sub_key   TEXT:='';
  col_split   TEXT:='_';
  num_map   hstore;

  maps     hstore[];
  sys_map   hstore;    -- 优惠分摊比例
  api_map   hstore;
  expense_map hstore;
  dict_map   hstore;    -- 运营商，站长，账务类型等信息
  param     TEXT:='';
  sid     INT;    -- 站点ID.
  val     FLOAT;
  date_time   TIMESTAMP;
  c_year     INT;
  c_month   INT;

  player_num   INT;
  bill_id   INT;
  rtn     TEXT;
  bill_no   TEXT;    -- 账务流水号
BEGIN
  IF ltrim(rtrim(master_url)) = '' THEN
    RAISE EXCEPTION '-1, 站点库URL为空';
  END IF;

  perform dblink_close_all();
  --v1.11  2017/07/10  Leisure
  perform dblink_connect_u('master',  master_url);

  SELECT  * FROM dblink(
    'master', 'SELECT  * FROM gamebox_sys_param(''apportionSetting'')'
  ) as p(h hstore) INTO sys_map;

  raise info 'sys_map: %', sys_map;

  sid = (sys_map->'site_id')::INT;

  --v1.01  2016/06/04  Leisure
  --v1.10  2017/07/05  Leisure
  --perform gamebox_collect_site_infor(main_url);
  SELECT gamebox_site_map(sid) INTO dict_map;

  --v1.01  2016/06/04  Leisure
  date_time = start_time::TIMESTAMP;
  IF extract(day FROM date_time) <> '1' THEN
    date_time = date_time + '1 day';
  END IF;

  SELECT extract(year FROM date_time) INTO c_year;
  SELECT extract(month FROM date_time) INTO c_month;

  dict_map = (SELECT ('year=>'||c_year)::hstore)||dict_map;
  dict_map = (SELECT ('month=>'||c_month)::hstore)||dict_map;

  SELECT put(dict_map, 'bill_type', flag::TEXT) into dict_map;   -- 账务类型

  raise info 'dict_map: %', dict_map;

  -- raise info '运营商，站长，账务类型等信息(dict_map) = %', dict_map;

  SELECT put(sys_map, 'backwater_percent', sys_map->'topagent.rakeback.percent')     into sys_map;
  SELECT put(sys_map, 'refund_fee_percent', sys_map->'topagent.poundage.percent')   into sys_map;
  SELECT put(sys_map, 'favourable_percent', sys_map->'topagent.preferential.percent')   into sys_map;
  SELECT put(sys_map, 'rebate_percent', sys_map->'topagent.rebate.percent')       into sys_map;

  -- raise info '优惠分摊比例(sys_map) = %', sys_map;

  -- 删除重复运行记录.
  DELETE FROM station_bill_other WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT);
  DELETE FROM station_profit_loss WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT);
  DELETE FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT;

  IF flag = 1 THEN     -- 计算站长账务
    -- 站长账单流水号
    SELECT gamebox_generate_order_no('B', sid::TEXT, '03', 'master') INTO bill_no;
    SELECT put(dict_map, 'bill_no', bill_no) into dict_map;
    SELECT gamebox_station_bill_master(sys_map, dict_map, 'master', main_url, start_time, end_time) INTO rtn;
  /*
  ELSEIF flag = 2 THEN  -- 计算总代账务
    -- 总代账单流水号
    SELECT gamebox_generate_order_no('B', sid::TEXT, '04', 'master') INTO bill_no;
    SELECT put(dict_map, 'bill_no', bill_no) into dict_map;
    SELECT gamebox_station_bill_top(sys_map, dict_map, 'master', main_url, start_time, end_time) INTO rtn;
  */
  END IF;

  --关闭连接
  perform dblink_disconnect('master');

  RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill(main_url TEXT, master_url TEXT, start_time TEXT, end_time TEXT, flag INT)
IS 'Lins-账务(站长、总代)-入口';


drop function if exists gamebox_station_bill_master(hstore, hstore, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_station_bill_master(
  sys_map   hstore,    -- 优惠分摊比例
  dict_map   hstore,    -- 运营商，站长，站点，年，月，账务类型
  url_name   TEXT,
  main_url   TEXT,
  start_time   TEXT,
  end_time   TEXT
) returns TEXT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点账务-API
--v1.01  2016/05/20  Leisure  改用新的运营商占成函数
--v1.02  2016/05/25  Leisure  上期未结需要计算应付和实付
--v1.03  2016/05/28  Leisure  bill_other增加api占成总金额
--v1.04  2016/06/09  Leisure  如果未设置返还盈利、减免维护费，则不生成station_profit_loss记录
--v1.05  2016/10/29  Leisure  包网方案修改，对于BBIN和视讯类游戏，允许API互抵
--v1.06  2016/11/01  Leisure  未设置减免维护费，依然需要计算维护费
--v10.7  2017/08/01  Leisure  API盈亏由经营报表取，增加占成比率
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
  occupy_tatol  FLOAT:=0.00;  -- API占成总金额 --v1.03  2016/05/28  Leisure
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
  SELECT  * FROM dblink(main_url, 'SELECT gamebox_contract('||sid||', '||is_max||')') as a(hash hstore[]) INTO net_maps;

  net_map = net_maps[1];
  occupy_map = net_maps[2];
  --assume_map = net_maps[3]; --v1.05  2016/10/29  Leisure
  charge_map = net_maps[4];
  favorable_map = net_maps[5];

  amount = 0.00;
  SELECT put(dict_map, 'op', 'I') into dict_map;
  -- 准备station_bill.
  SELECT gamebox_station_bill(dict_map) INTO bill_id;

  -- 每个API的占成
  --v10.7  2017/08/01  Leisure
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
    --v1.05  2016/10/29  Leisure
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
      --v10.7  2017/08/01  Leisure
      occupy_proportion = 0;
      IF profilt_amount <> 0 THEN
        occupy_proportion = occupy / profilt_amount * 100;
      END IF;

      --v1.01
      raise info 'api_id = %, game_type = %, 盈亏 = %, 占成 = %', api, game_type, profilt_amount, occupy;

      --BBIN和视讯类特殊处理 --v1.05  2016/10/29  Leisure
      IF rec.api_id = 10 OR game_type = 'LiveDealer' THEN
        occupy_live = occupy_live + COALESCE(occupy, 0.00);
      ELSE
        -- 盈亏不共担时且占成金额为负时，计0
        IF assume = FALSE AND occupy < 0.00 THEN
          occupy = 0.00;
        END IF;

        -- 累计占成金额
        --amount = amount + COALESCE(occupy, 0.00);
        occupy_tatol = occupy_tatol + COALESCE(occupy, 0.00); --v1.03  2016/05/28  Leisure
        --RAISE INFO 'occupy_tatol: %', occupy_tatol;

      END IF;

      SELECT put(map, 'api_id', api) into map;      -- API_ID
      SELECT put(map, 'game_type', game_type) into map;  -- API二级分类
      SELECT put(map, 'amount_payable', occupy::TEXT) into map;     --应付金额
      SELECT put(map, 'occupy_proportion', occupy_proportion::TEXT) into map; --占成百分比 --v10.7  2017/08/01  Leisure
      SELECT put(map, 'profit_loss', profilt_amount::TEXT) into map;  --盈亏总和
      SELECT put(map, 'bill_id', bill_id::TEXT) into map;
      -- 新增各API占成金额
      perform gamebox_station_profit_loss(map);

    END IF;
    FETCH cur INTO rec;
  END LOOP;

  CLOSE cur;

  --v1.05  2016/10/29  Leisure
  IF occupy_live < 0 THEN
    occupy_live = 0.00;
  END IF;

  --amount := amount + occupy_tatol; --v1.03  2016/05/28  Leisure
  amount := amount + occupy_live + occupy_tatol; --v1.05  2016/10/29  Leisure

  -- 计算其它费用.
  -- raise info '------ 各API盈亏(amount) = %', amount;
  SELECT put(map, 'bill_id', bill_id::TEXT) into map;
  SELECT put(map, 'occupy_tatol', occupy_tatol::TEXT) into map; --v1.03  2016/05/28  Leisure
  SELECT put(map, 'payable', '0') into map;
  SELECT put(map, 'actual', '0') into map;
  SELECT put(map, 'apportion', '0') into map;

  --------- 上期未结费用.START
  code = 'pending';
  bill_year = (dict_map->'year')::INT;
  bill_month = (dict_map->'month')::INT;
  SELECT gamebox_station_bill_prev(sid, bill_year, bill_month, '1') INTO prev_map;
  no_bill = COALESCE(prev_map->'no_bill_actual', '0.00');  --v1.02  2016/05/25  Leisure
  operator = prev_map->'operator';
  SELECT put(map, 'name', operator) into map;
  SELECT put(map, 'code', code) into map;
  SELECT put(map, 'payable', prev_map->'no_bill_payable'::TEXT) into map;  --v1.02  2016/05/25  Leisure
  SELECT put(map, 'actual', prev_map->'no_bill_actual'::TEXT) into map;  --v1.02  2016/05/25  Leisure
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

  -- 维护费 --v1.05  2016/10/29  Leisure
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
  END IF; --v1.05  2016/10/29  Leisure
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
  --END IF; --v1.05  2016/10/29  Leisure
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

  RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_master(sys_map hstore, dict_map hstore, url_name TEXT, main_url TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-站点账务-API';


DROP FUNCTION IF EXISTS gamebox_station_profit_loss(hstore);
CREATE OR REPLACE FUNCTION gamebox_station_profit_loss(
    map hstore
) RETURNS void AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点账务-API
--v1.01  2017/03/22  Leisure  增加api_type_id
*/
DECLARE
  api_id     INT;
  game_type   TEXT;
  profit_loss FLOAT;
  occupy_proportion FLOAT;
  amount_payable FLOAT;
  bill_id   INT;
  api_type_id INT;
BEGIN
  api_id = (map->'api_id')::INT;
  game_type = (map->'game_type')::TEXT;
  profit_loss = (map->'profit_loss')::FLOAT;
  occupy_proportion = (map->'occupy_proportion')::FLOAT;
  amount_payable = (map->'amount_payable')::FLOAT;
  bill_id = (map->'bill_id')::INT;
  api_type_id = CASE game_type WHEN 'LiveDealer' THEN 1 WHEN 'Casino' THEN 2 WHEN 'Sportsbook' THEN 3 WHEN 'Lottery' THEN 4 WHEN 'SixLottery' THEN 4 END;

  INSERT INTO station_profit_loss(
    station_bill_id, api_id, profit_loss,
    amount_payable, game_type, occupy_proportion, api_type_id
  ) VALUES (
    bill_id, api_id, profit_loss,
    amount_payable, game_type, occupy_proportion, api_type_id
  );
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_profit_loss( map hstore) IS 'Lins-站点账务-API';


DROP FUNCTION IF EXISTS gb_operation_occupy_api(INT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_operation_occupy_api(
  sid INT,
  start_time TIMESTAMP,
  end_time TIMESTAMP
) RETURNS refcursor AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/08/01  Lins     创建此函数: Leisure-站点账务.API盈亏

*/
DECLARE
  cur refcursor;
BEGIN
  /*
  OPEN cur FOR
  SELECT * FROM dblink(
    url,
    'SELECT o.api_id,
            o.game_type,
            COALESCE(sum(-o.profit_amount), 0.00)       as profit_amount,
            COALESCE(sum(o.effective_trade_amount), 0.00)    as trade_amount
       FROM player_game_order o
      --WHERE o.bet_time >='''||start_time||'''
      --  AND o.bet_time < '''||end_time||'''
      --v1.02  2016/10/05  Leisure
      WHERE o.order_state = ''settle''
        --v1.03  2017/02/07  Leisure
        --AND o.is_profit_loss = TRUE
        AND o.payout_time >='''||start_time||'''
        AND o.payout_time < '''||end_time||'''
      GROUP BY o.api_id, o.game_type '
  ) as p(api_id INT, game_type VARCHAR, profit_amount NUMERIC, trade_amount NUMERIC);
  */
  OPEN cur FOR
  SELECT api_id, game_type, -SUM(profit_loss) profit_amount, SUM(effective_transaction) trade_amount
    FROM site_operate
   WHERE site_id = sid
     AND static_time >= start_time
     AND static_time_end <= end_time
   GROUP BY api_id, game_type;

  return cur;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_operation_occupy_api( sid INT, start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Leisure-站点账务.API盈亏';


drop function IF EXISTS gb_operations_statement_master(text, text, text, text, text, text, text, text, int);
create or replace function gb_operations_statement_master(
  p_comp_url    text,
  p_master_id   text,
  p_static_date text,
  p_site_urls   text,
  p_start_times text,
  p_end_times   text,
  p_siteids     text,
  p_splitchar   text,
  p_stat_days   int
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/02/23  Leisure  创建此函数: 经营报表-入口
--v1.10  2017/06/29  Leisure  改变sys_site_info同步方式
--v1.20  2017/08/01  Leisure  不再搜集站长，运营商报表
*/
DECLARE
  v_site_urls     varchar[];
  v_start_times   varchar[];
  v_end_times     varchar[];
  v_siteids       varchar[];
  n_center_id     int;
  tmp             text:='';
  rtn             text:='';

  v_static_date  varchar;
  v_start_time   varchar;
  v_end_time     varchar;

BEGIN
  IF p_comp_url is null or trim(p_comp_url) = '' THEN
    raise info '运营商库信息没有设置';
    return '运营商库信息没有设置';
  END IF;

  IF p_site_urls is null or trim(p_site_urls) = '' THEN
    raise info '站点库信息没有设置';
    return '站点库信息没有设置';
  END IF;

  --关闭所有链接.
  perform dblink_close_all();
  --v1.10  2017/06/29  Leisure
  --收集当前所有运营站点相关信息.
  --perform gamebox_collect_site_infor(p_comp_url);

  --获取当前运营商id
  SELECT operationid INTO n_center_id FROM sys_site_info WHERE masterid = p_master_id::INT LIMIT 1;
  IF n_center_id is null or n_center_id = 0 THEN
    raise info '获取运营商id失败';
    return '获取运营商id失败';
  END IF;

  --拆分所有站点数据库信息.
  v_site_urls:=regexp_split_to_array(p_site_urls, p_splitchar);
  v_start_times :=regexp_split_to_array(p_start_times, p_splitchar);
  v_end_times   :=regexp_split_to_array(p_end_times, p_splitchar);
  v_siteids    :=regexp_split_to_array(p_siteids, p_splitchar);

  rtn = '【开始执行经营报表】';
  rtn = rtn || '站长ID：' || p_master_id || '，运营商ID：' || n_center_id::TEXT;

  IF array_length(v_siteids, 1) > 0 THEN
    FOR i_day IN 0..p_stat_days-1 LOOP

      v_static_date := (p_static_date::DATE + (i_day||'day')::INTERVAL)::DATE::TEXT;
      rtn = rtn||chr(13)||chr(10)||' ┣1.开始执行日期['|| v_static_date ||']站点经营报表  ';

      FOR i_site in 1..array_length(v_siteids, 1)
      LOOP

        v_start_time  := (v_start_times[i_site]::TIMESTAMP + (i_day||'day')::INTERVAL)::TEXT;
        v_end_time    := (v_end_times[i_site]::TIMESTAMP + (i_day||'day')::INTERVAL)::TEXT;

        SELECT gb_operations_statement_site(p_comp_url, v_static_date, v_site_urls[i_site], v_start_time, v_end_time, v_siteids[i_site], 1) into tmp;
        rtn = rtn || tmp;
      END LOOP;

      --v1.20  2017/08/01  Leisure
      --rtn = rtn||chr(13)||chr(10)||' ┣2.开始执行站长经营报表  ';
      --SELECT gamebox_operation_master(p_master_id, v_static_date) into tmp;
      --rtn = rtn||'||'||tmp;

      --v1.20  2017/08/01  Leisure
      --rtn = rtn||chr(13)||chr(10)||' ┗3.开始执行运营商经营报表';
      --SELECT gamebox_operation_company(n_center_id::TEXT, v_static_date) into tmp;
      --rtn = rtn||'||'||tmp||chr(13)||chr(10);

    END LOOP;
  END IF;

  rtn = rtn||chr(13)||chr(10)||'【执行经营报表完毕】'||chr(13)||chr(10);

  --raise info '%', rtn;
  return rtn;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gb_operations_statement_master(p_comp_url text, p_master_id text, p_static_date  text, p_site_urls text, p_start_times text, p_end_times text, p_siteids text, p_splitchar text, p_stat_days  int)
IS 'Leisure-经营报表-入口';


DROP FUNCTION IF EXISTS gb_pay_account_collect(comp_url text);
CREATE OR REPLACE FUNCTION gb_pay_account_collect(comp_url text)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/09/21  Chan     创建此函数: 收集各站点pay_account
--v1.01  2016/10/24  Leisure  关联sys_site，增加comp_id, master_id字段
--v1.02  2017/07/01  Leisure  拼数据源时增加了机房的判断
--v1.03  2017/07/10  Leisure  修改DBLINK连接方式，回收SU
*/
DECLARE
  rec   record;
  rec_ds record;
  site_url text;
  pc_id int;

BEGIN

  TRUNCATE TABLE pay_account_collection;

  --v1.03  2017/07/10  Leisure
  perform dblink_connect_u('mainsite', comp_url);

  FOR rec_ds IN
    SELECT comp_id, master_id, site_id, site_name, ip, port, dbname, username, password
      FROM dblink('mainsite',
                  'SELECT parent_id comp_id, sys_user_id master_id, d.id site_id, d.name site_name,
                          CASE idc WHEN ''A'' THEN ip ELSE remote_ip END, CASE idc WHEN ''A'' THEN port ELSE remote_port END, dbname, username, password
                     FROM sys_site s, sys_datasource d where s.id = d.id
                    ORDER BY site_id')
        AS si( comp_id INT, master_id INT, site_id INT, site_name varchar(16),
               ip varchar(15), port int4, dbname varchar(32), username varchar(32), password varchar(128)
             )
  LOOP
    site_url = 'host=' || rec_ds.ip || ' port=' || rec_ds.port || ' dbname=' || rec_ds.dbname || ' user=' || rec_ds.username || ' password=' || rec_ds.password;

    RAISE INFO '正在收集站点：%', rec_ds.username;
    FOR rec IN
      SELECT "id", pay_name, account, full_name, disable_amount, pay_key,
        status, create_time, create_user, type, account_type, bank_code, pay_url,
        code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
        effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
        full_rank, custom_bank_name, open_acount_name, qr_code_url, remark
      FROM dblink(site_url,
        'select id, pay_name, account, full_name, disable_amount, pay_key,
        status, create_time, create_user, type, account_type, bank_code, pay_url,
        code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
        effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
        full_rank, custom_bank_name, open_acount_name, qr_code_url, remark from pay_account')
            AS a("id" int4, pay_name varchar(100), account varchar(200), full_name varchar(200), disable_amount int4, pay_key varchar(200),
        status varchar, create_time timestamp(6), create_user int4, type varchar(50), account_type varchar(50), bank_code varchar(50), pay_url varchar(200),
        code varchar(10), deposit_count int4, deposit_total numeric(20,2), deposit_default_count int4, deposit_default_total numeric(20,2),
        effective_minutes int4, single_deposit_min int4, single_deposit_max int4, frozen_time timestamp(6), channel_json text,
        full_rank bool, custom_bank_name varchar(32), open_acount_name varchar(100), qr_code_url varchar(200), remark varchar(512))

    LOOP
      raise info 'id = %, pay_name = %', rec."id", rec.pay_name;

      INSERT INTO pay_account_collection (comp_id, master_id, site_id, site_name, pay_account_id, pay_name, account, full_name, disable_amount, pay_key,
        status, create_time, create_user, type, account_type, bank_code, pay_url,
        code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
        effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
        full_rank, custom_bank_name, open_acount_name, qr_code_url, remark
      ) VALUES (
        rec_ds.comp_id, rec_ds.master_id, rec_ds.site_id, rec_ds.site_name, rec.id, rec.pay_name, rec.account, rec.full_name, rec.disable_amount, rec.pay_key,
        rec.status, rec.create_time, rec.create_user, rec.type, rec.account_type, rec.bank_code, rec.pay_url,
        rec.code, rec.deposit_count, rec.deposit_total, rec.deposit_default_count, rec.deposit_default_total,
        rec.effective_minutes, rec.single_deposit_min, rec.single_deposit_max, rec.frozen_time, rec.channel_json,
        rec.full_rank, rec.custom_bank_name, rec.open_acount_name, rec.qr_code_url, rec.remark
      ) RETURNING "id" into pc_id;
      raise info 'pay_account_collection.新增.键值 = %', pc_id;

    END LOOP;
  END LOOP;

  perform dblink_disconnect('mainsite');
  raise info '统计 % END', rec_ds.site_name;

END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;

COMMENT ON FUNCTION gb_pay_account_collect(comp_url text) IS 'Chan-收集各站点收款账户';


DROP FUNCTION IF EXISTS gb_topagent_occupy_create(TEXT, INT, TEXT, INT, INT);
CREATE OR REPLACE FUNCTION gb_topagent_occupy_create(
  p_site_url   TEXT,
  p_site_id    INT,
  p_occupy_bill_no TEXT,
  p_occupy_year   INT,
  p_occupy_month  INT
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Leisure  创建此函数: 总代占成账单-生成账单记录
--v1.01  2017/08/21  Leisure  适应多级代理返佣调整
--v1.02  2017/09/03  Leisure  numeric(4,2)溢出问题

*/
DECLARE

  rec_to record;
  rec_si record;
  --n_occupy_bill_no TEXT;
  n_station_bill_id INT;
  n_amount_payable FLOAT := 0;

  v_sql TEXT;

BEGIN

  perform dblink_connect_u('master',  p_site_url);

  FOR rec_to IN
    --v1.01  2017/08/21  Leisure
    SELECT * FROM
       dblink( 'master',
              'SELECT topagent_id, topagent_name, profit_amount, operation_occupy, topagent_occupy,
                      favorable, favorable_ratio, rakeback, rakeback_ratio, rebate, rebate_ratio, apportion_value
                 FROM topagent_occupy WHERE occupy_bill_no =''' || p_occupy_bill_no || ''''
             )
       AS t ( topagent_id int4,
              topagent_name varchar(32),
              profit_amount numeric(20,2),
              operation_occupy numeric(20,2),
              topagent_occupy numeric(20,2),
              --poundage numeric(20,2),
              favorable numeric(20,2),
              favorable_ratio numeric(5,2),
              --recommend numeric(20,2),
              --refund_fee numeric(20,2),
              rakeback numeric(20,2),
              rakeback_ratio numeric(5,2),
              rebate numeric(20,2),
              rebate_ratio numeric(5,2),
              --apportion_ratio numeric(20,2),
              apportion_value numeric(20,2)
            )
  LOOP

    n_amount_payable = rec_to.topagent_occupy - rec_to.apportion_value;

    SELECT operationid center_id,
           operationname center_name,
           masterid master_id,
           mastername master_name,
           siteid site_id,
           sitename site_name
      INTO rec_si
      FROM sys_site_info WHERE siteid = p_site_id;

    INSERT INTO station_bill ( bill_num, center_id, center_name, master_id, master_name, site_id, site_name, topagent_id, topagent_name,
      bill_type, bill_year, bill_month, amount_payable, amount_actual, create_time)
    VALUES ( p_occupy_bill_no, rec_si.center_id, rec_si.center_name, rec_si.master_id, rec_si.master_name, rec_si.site_id, rec_si.site_name, rec_to.topagent_id, rec_to.topagent_name,
      '2', p_occupy_year, p_occupy_month, n_amount_payable, n_amount_payable, now()
    ) RETURNING id INTO n_station_bill_id;

    --手续费
    --INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    --VALUES (n_station_bill_id, 'poundage', rec_to.poundage*rec_to.apportion_ratio/100, rec_to.poundage*rec_to.apportion_ratio/100, rec_to.apportion_ratio);

    --优惠
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'favorable', rec_to.favorable*rec_to.favorable_ratio/100, rec_to.favorable*rec_to.favorable_ratio/100, rec_to.favorable_ratio);

    --推荐
    --INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    --VALUES (n_station_bill_id, 'recommend', rec_to.recommend*rec_to.apportion_ratio/100, rec_to.recommend*rec_to.apportion_ratio/100, rec_to.apportion_ratio);

    --返手续费
    --INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    --VALUES (n_station_bill_id, 'refund_fee', rec_to.refund_fee*rec_to.apportion_ratio/100, rec_to.refund_fee*rec_to.apportion_ratio/100, rec_to.apportion_ratio);

    --返水
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'backwater', rec_to.rakeback*rec_to.rakeback_ratio/100, rec_to.rakeback*rec_to.rakeback_ratio/100, rec_to.rakeback_ratio);

    --返佣
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'rebate', rec_to.rebate*rec_to.rebate_ratio/100, rec_to.rebate*rec_to.rebate_ratio/100, rec_to.rebate_ratio);

    v_sql = 'SELECT api_id, api_type_id, game_type, profit_amount, occupy_ratio, occupy_value
                   FROM topagent_occupy_api
                  WHERE occupy_bill_no = ''' || p_occupy_bill_no || ''' AND topagent_id =' || rec_to.topagent_id;
    RAISE INFO 'SQL: %', v_sql;

    --v1.02  2017/08/21  Leisure
    INSERT INTO station_profit_loss ( station_bill_id, api_id, api_type_id, game_type, profit_loss, occupy_proportion, amount_payable)
    SELECT
      n_station_bill_id, api_id, api_type_id, game_type, profit_amount, occupy_ratio, occupy_value
      FROM
        dblink( 'master',
                'SELECT api_id, api_type_id, game_type, profit_amount, occupy_ratio, occupy_value
                   FROM topagent_occupy_api
                  WHERE occupy_bill_no = ''' || p_occupy_bill_no || ''' AND topagent_id =' || rec_to.topagent_id
        )
        AS t ( api_id int4,
               api_type_id int4,
               game_type varchar(32),
               profit_amount numeric(20,2),
               occupy_ratio numeric(5,2),
               occupy_value numeric(20,2)
             );
  END LOOP;

  --关闭连接
  perform dblink_disconnect('master');

  RETURN 0;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_topagent_occupy_create( p_site_url TEXT, p_site_id INT, p_occupy_bill_no TEXT, p_occupy_year INT, p_occupy_month INT)
IS 'Leisure-总代占成账单-生成账单记录';

DROP FUNCTION IF EXISTS gb_operations_statement_site(text, text, text, text, text, text, int);
CREATE OR REPLACE FUNCTION gb_operations_statement_site(
  p_comp_url    text,
  p_static_date text,
  p_site_url    text,
  p_start_time  text,
  p_end_time    text,
  p_siteid      text,
  p_stat_days   int
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/02/23  Laser    创建此函数: 经营报表-站点报表
--v1.01  2017/09/18  Laser    修改dblink的连接方式
*/
DECLARE

  rtn text:='';
  tmp text:='';
  v_static_date  varchar;
  v_start_time   varchar;
  v_end_time     varchar;

BEGIN

  FOR i IN 0..p_stat_days - 1 LOOP

    v_static_date := (p_static_date::DATE + (i||'day')::INTERVAL)::DATE::TEXT;
    v_start_time  := (p_start_time::TIMESTAMP + (i||'day')::INTERVAL)::TEXT;
    v_end_time    := (p_end_time::TIMESTAMP + (i||'day')::INTERVAL)::TEXT;

    RAISE INFO '%, %, %', v_static_date, v_start_time, v_end_time;

    --raise notice '当前站点库信息：%', p_site_url;
    IF p_site_url is null OR trim(p_site_url) = '' THEN
      return '站点库信息不能为空';
    END IF;

    --连接站点库
    perform dblink_connect_u('master', p_site_url);

    tmp = '    ┗ 开始收集站点id['||p_siteid||'],日期['|| v_static_date ||']经营报表';
    raise notice '%', tmp;
    --执行玩家经营报表
    rtn = rtn||chr(13)||chr(10)||tmp;
    SELECT P .msg
      FROM
      dblink ('master', --p_site_url, --v1.01  2017/09/18  Laser
              'SELECT * from gamebox_operations_statement('''||p_comp_url||''', '||p_siteid||', '''||v_static_date||''', '''||v_start_time||''', '''||v_end_time||''')'
      ) AS P (msg TEXT)
      INTO tmp ;
    rtn = rtn||tmp;
    raise notice '收集完毕';
    --收集站点经营报表
    rtn = rtn||chr(13)||chr(10)||'        ┗4.正在执行站点经营报表';
    SELECT gamebox_operation_site('master', p_siteid, v_static_date, v_start_time, v_end_time) into tmp;
    rtn = rtn||'||'||tmp;
    perform dblink_disconnect('master');

    rtn = rtn||chr(13)||chr(10)||'    ┗收集完毕';
  END LOOP;

  return rtn;

END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gb_operations_statement_site(p_comp_url text, p_static_date  text, p_site_url text, p_start_time text, p_end_time text, p_siteid text, p_stat_days  int)
IS 'Laser-经营报表-站点经营报表';


drop function IF EXISTS gamebox_operation_site(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_operation_site(
  conn   TEXT,
  siteid  TEXT,
  curday   TEXT,
  start_time   TEXT,
  end_time     TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-站点报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取，
                              站点报表增加参数startTime TEXT, endTime TEXT
--v1.02  2016/07/07  Leisure  增加参数siteid，清除数据时，只清除当前站点的数据
--v1.03  2016/07/08  Leisure  优化输出日志
--v1.04  2016/09/18  Leisure  增加彩金字段统计
*/
DECLARE
  rtn   text:='';
  v_count  int:=0;
  d_static_date DATE; --v1.01  2016/05/31
BEGIN
  --v1.01  2016/05/31  Leisure
  d_static_date := to_date(curday, 'YYYY-MM-DD');
  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';

  --delete from site_operate where to_char(static_time, 'YYYY-MM-DD') = to_char(curday, 'YYYY-MM-DD');
  --v1.02  2016/07/07  Leisure
  --DELETE FROM site_operate WHERE static_date = d_static_date;
  DELETE FROM site_operate WHERE static_date = d_static_date AND site_id = siteid::INT;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  raise notice '本次删除记录数 %',  v_count;
  rtn = rtn||'|执行完毕,删除记录数: '||v_count||' 条||';

  --开始执行站点经营报表信息收集
  rtn = rtn||'|开始执行'||curday||'站点经营报表||';
  INSERT INTO site_operate(
    site_id, site_name, center_id, center_name, master_id, master_name, player_num,
    api_id, api_type_id, game_type,
    --static_time, create_time, --v1.01  2016/05/31  Leisure
    static_date, static_time, static_time_end, create_time,
    transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  ) SELECT
      s.siteid, s.sitename, s.operationid, s.operationname, s.masterid, s.mastername, a.players_num,
      a.api_id, a.api_type_id, a.game_type,
      --current_date, now(), --v1.01  2016/05/31  Leisure
      d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
      a.transaction_order, a.transaction_volume, a.effective_transaction_volume,
      a.transaction_profit_loss,  winning_amount, contribution_amount
    FROM
      dblink (conn,
              'SELECT * from gamebox_operations_site('''||curday||''')
               AS q(siteid int, api_id int, game_type varchar, api_type_id int, players_num bigint,
                    transaction_order NUMERIC, transaction_volume NUMERIC,
                    effective_transaction_volume NUMERIC, transaction_profit_loss NUMERIC,
                    winning_amount NUMERIC, contribution_amount NUMERIC
                   )
              '
              )
    AS a(
          siteid int,
          api_id int,
          game_type varchar,
          api_type_id int,
          players_num bigint ,
          transaction_order NUMERIC ,
          transaction_volume NUMERIC,
          effective_transaction_volume NUMERIC,
          transaction_profit_loss NUMERIC,
          winning_amount NUMERIC,
          contribution_amount NUMERIC
        ) left join sys_site_info s on a.siteid = s.siteid;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  raise notice '本次插入数据量 %', v_count;
    rtn = rtn||'|执行完毕,新增记录数: '||v_count||' 条||';
  return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_site(  conn TEXT, siteid TEXT, curday TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-经营报表-站点报表';