-- auto gen by george 2018-01-28 10:33:14
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
*/
DECLARE

  rtn text:='';
  tmp text:='';
  v_static_date  varchar;
  v_start_time   varchar;
  v_end_time     varchar;

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
    SELECT gb_api_collate_site_create('master', p_siteid, v_static_date, v_start_time, v_end_time) into tmp;
    rtn = rtn||'||'||tmp;
    perform dblink_disconnect('master');

    rtn = rtn||chr(13)||chr(10)||'    ┗收集完毕';
  END LOOP;

  return rtn;
EXCEPTION
  WHEN QUERY_CANCELED THEN
    perform dblink_close_all();
    RETURN 2;
  WHEN OTHERS THEN
    perform dblink_close_all();

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
CREATE OR REPLACE FUNCTION gb_api_collate_site_create(
  p_conn   TEXT,
  p_siteid  TEXT,
  p_curday   TEXT,
  start_time   TEXT,
  end_time     TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2018/01/19  Lins     创建此函数: API注单核对-站点报表
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
    site_id, site_name, center_id, center_name, master_id, master_name, player_num,
    api_id, api_type_id, game_type,
    static_date, static_time, static_time_end, create_time,
    transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  ) SELECT
      s.siteid, s.sitename, s.operationid, s.operationname, s.masterid, s.mastername, acp.players_num,
      acp.api_id, acp.api_type_id, acp.game_type,
      d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
      acp.transaction_order, acp.transaction_volume, acp.effective_transaction,
      acp.transaction_profit_loss,  winning_amount, contribution_amount
    FROM
      dblink (p_conn,
              'SELECT site_id, api_id, game_type, api_type_id,
                      COUNT (player_id)           as players_num,
                      SUM (transaction_order)     as transaction_order,
                      SUM (transaction_volume)    as transaction_volume,
                      SUM (effective_transaction) as effective_transaction,
                      SUM (profit_loss)           as transaction_profit_loss,
                      SUM(winning_amount)         as winning_amount,
                      SUM(contribution_amount)    as contribution_amount
                 FROM api_collate_player
                WHERE static_date = ''' || p_curday || '''
                GROUP BY site_id,api_id,game_type,api_type_id
              '
              )
    AS acp (
            site_id int,
            api_id int,
            game_type varchar,
            api_type_id int,
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

COMMENT ON FUNCTION gb_api_collate_site_create( p_conn TEXT, p_siteid TEXT, p_curday TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-经营报表-站点报表';


DROP FUNCTION IF EXISTS gamebox_station_profit_loss(hstore);
CREATE OR REPLACE FUNCTION gamebox_station_profit_loss(
    map hstore
) RETURNS void AS $$
/*版本更新说明
  版本   时间        作者   内容
--v1.00  2015/01/01  Lins   创建此函数: 站点账务-API
--v1.01  2017/03/22  Laser  增加api_type_id
--v1.02  2018/01/25  Laser  增加api_type_id=5
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
  api_type_id = CASE game_type WHEN 'LiveDealer' THEN 1 WHEN 'Casino' THEN 2 WHEN 'Sportsbook' THEN 3
                               WHEN 'Lottery' THEN 4 WHEN 'SixLottery' THEN 4 WHEN 'Fish' THEN 2
                               WHEN 'Chess' THEN 5 END;

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


DROP FUNCTION IF EXISTS gb_pay_account_collect(comp_url text);
CREATE OR REPLACE FUNCTION gb_pay_account_collect(comp_url text)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2016/09/21  Chan    创建此函数: 收集各站点pay_account
--v1.01  2016/10/24  Laser   关联sys_site，增加comp_id, master_id字段
--v1.02  2017/07/01  Laser   拼数据源时增加了机房的判断
--v1.03  2017/07/10  Laser   修改DBLINK连接方式，回收SU
--v1.04  2018/01/25  Laser   修改DBLINK连接方式，回收SU
*/
DECLARE
  rec   record;
  rec_ds record;
  site_url text;
  pc_id int;

BEGIN

  --v1.04  2018/01/25  Laser
  perform dblink_disconnect_all();

  TRUNCATE TABLE pay_account_collection;

  --v1.03  2017/07/10  Laser
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

    --v1.04  2018/01/25  Laser
    perform dblink_connect_u('master', site_url);

    FOR rec IN
      SELECT "id", pay_name, account, full_name, disable_amount, pay_key,
        status, create_time, create_user, type, account_type, bank_code, pay_url,
        code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
        effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
        full_rank, custom_bank_name, open_acount_name, qr_code_url, remark
      FROM dblink('master',
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

    --v1.04  2018/01/25  Laser
    perform dblink_disconnect('master');
  END LOOP;

  perform dblink_disconnect('mainsite');
  raise info '统计 % END', rec_ds.site_name;

END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;

COMMENT ON FUNCTION gb_pay_account_collect(comp_url text) IS 'Chan-收集各站点收款账户';