-- auto gen by steffan 2018-10-09 22:04:33
DROP FUNCTION IF EXISTS gb_api_collate_player(TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_api_collate_player(
  p_comp_url   TEXT,
  p_curday     TEXT,
  p_apis       TEXT
) RETURNS text AS $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2018/01/12  Laser   创建此函数: API注单核对-玩家报表
--v1.01  2018/02/28  Laser   增加currency字段（撤销修改）
--v1.02  2018/10/09  steffan     api=12单独处理
*/
DECLARE
  sif     JSON;
  rtn     TEXT:='';
  n_count    INT:=0;
  n_site_id   INT;
  n_master_id   INT;
  n_center_id   INT;
  c_site_name   TEXT:='';
  c_master_name TEXT:='';
  c_center_name TEXT:='';
  --c_currency    TEXT:=''; --v1.01  2018/02/28  Laser
  d_static_date DATE;
  rec RECORD;
  d_start_time TIMESTAMP;
  d_end_time   TIMESTAMP;

BEGIN

	--收集当前所有运营站点相关信息.
  SELECT gamebox_collect_site_infor(p_comp_url, gamebox_current_site()) into sif;
  IF sif->>'siteid' = '-1' THEN
    rtn = '运营商库中不存在当前站点的相关信息,请确保此站点是否合法.';
    raise info '%', rtn;
    return rtn;
  END IF;

  rtn = rtn||chr(13)||chr(10)||'        ┣1.正在收集玩家下单信息：';

  --开始执行玩家经营报表信息收集
  n_site_id   = COALESCE((sif->>'siteid')::INT, -1);
  c_site_name  = COALESCE(sif->>'sitename', '');
  n_master_id  = COALESCE((sif->>'masterid')::INT, -1);
  c_master_name  = COALESCE(sif->>'mastername', '');
  n_center_id  = COALESCE((sif->>'operationid')::INT, -1);
  c_center_name  = COALESCE(sif->>'operationname', '');
  --v1.01  2018/02/28  Laser
  --c_currency = COALESCE(sif->>'currency', '');
  d_static_date := to_date(p_curday, 'YYYY-MM-DD');

  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||chr(13)||chr(10)||'          |清除当天的统计数据，保证每天只作一次统计||';
  --delete from api_collate_player WHERE to_char(static_time, 'YYYY-MM-dd') = p_curday;
  DELETE FROM api_collate_player WHERE static_date = d_static_date AND ( COALESCE(p_apis, '') = '' OR api_id = ANY ( regexp_split_to_array(p_apis, ',')::INT[]) );

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice '本次删除记录数 %', n_count;
  rtn = rtn||'|执行完毕，删除记录数: '||n_count||' 条||';

  /*
  FOR rec IN
    SELECT timezone, array_agg(api_id) apis
      FROM ( VALUES ('GMT-04:00',5),  ('GMT-04:00',7),  ('GMT-04:00',9),  ('GMT-04:00',10), ('GMT-04:00',12), ('GMT-04:00',17), ('GMT-04:00',19), ('GMT-04:00',23), ('GMT-04:00',24),
                    ('GMT+08:00',1),  ('GMT+08:00',2),  ('GMT+08:00',4),  ('GMT+08:00',6),  ('GMT+08:00',15), ('GMT+08:00',16), ('GMT+08:00',20), ('GMT+08:00',25), ('GMT+08:00',28),
                    ('GMT+08:00',31), ('GMT+08:00',32), ('GMT+08:00',33),
                    ('GMT+00:00',3),  ('GMT+00:00',21), ('GMT+00:00',22), ('GMT+00:00',26), ('GMT+00:00',27)
           ) AS t (timezone, api_id )
     WHERE ( COALESCE(p_apis, '') = '' OR api_id = ANY ( regexp_split_to_array(p_apis, ',')::INT[]) )
     GROUP BY timezone ORDER BY timezone
  LOOP
  */
  perform dblink_connect_u('mainsite', p_comp_url);

  FOR rec IN
    SELECT *
    	FROM dblink('mainsite',
    							'SELECT * from (SELECT timezone, array_agg(id) apis
    								 FROM api
                    WHERE ( COALESCE('''|| p_apis || ''', '''') = '''' OR id = ANY ( regexp_split_to_array(''' || p_apis ||''', '','')::INT[]) ) and id != 12
    								GROUP BY timezone ORDER BY timezone ) a
                  union
                  SELECT * from (
                  SELECT timezone, array_agg(id) apis
    								 FROM api
                    WHERE ( COALESCE('''|| p_apis || ''', '''') = '''' OR id = ANY ( regexp_split_to_array(''' || p_apis ||''', '','')::INT[]) ) and id = 12
    								GROUP BY timezone ORDER BY timezone) b')
    		AS a ( timezone VARCHAR(16), apis INT[])--v1.02  2018/10/09  steffan     api=12单独处理
  LOOP

    d_start_time := d_static_date - replace(rec.timezone, 'GMT', '')::interval;
    d_end_time   := d_start_time + interval '1d';

    raise notice '正在收集api:%, 开始时间:%, 结束时间:%', rec.apis, d_start_time, d_end_time;

	IF  12 = ANY ( rec.apis::INT[] )  THEN
    INSERT INTO api_collate_player(
      center_id, center_name, master_id, master_name, --currency, --v1.01  2018/02/28  Laser
      site_id, site_name, topagent_id, topagent_name,
      agent_id, agent_name, player_id, player_name,
      api_id, api_type_id, game_type,
      static_date, static_time, static_time_end, create_time,
      transaction_order, transaction_volume, effective_transaction,
      profit_loss, winning_amount, contribution_amount
    ) SELECT
          n_center_id, c_center_name, n_master_id, c_master_name, --c_currency, --v1.01  2018/02/28  Laser
          n_site_id, c_site_name, u.topagent_id, u.topagent_name,
          u.agent_id, u.agent_name, u.id, u.username,
          p.api_id, p.api_type_id, p.game_type,
          d_static_date, d_start_time::TIMESTAMP, d_end_time::TIMESTAMP, now(),
          p.transaction_order, p.transaction_volume, p.effective_transaction,
          p.profit_loss, p.winning_amount, p.contribution_amount
        FROM (SELECT
                  player_id, api_id, api_type_id, game_type,
                  COUNT(order_no)                as transaction_order,
                  COALESCE(SUM(single_amount), 0.00)      as transaction_volume,
                  COALESCE(SUM(profit_amount), 0.00)      as profit_loss,
                  COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
                  COALESCE(SUM(winning_amount), 0.00) as winning_amount,
                  COALESCE(SUM(contribution_amount), 0.00) as contribution_amount
               FROM player_game_order
              WHERE stat_time >= d_start_time::TIMESTAMP
                AND stat_time < d_end_time::TIMESTAMP
                AND api_id = ANY ( rec.apis::INT[] )
                AND order_state = 'settle'
              GROUP BY player_id, api_id, api_type_id, game_type
              ) p, v_sys_user_tier u
        WHERE p.player_id = u.id;
	END IF;--v1.02  2018/10/09  steffan     api=12单独处理


	IF  12 != ANY ( rec.apis::INT[] )  THEN
	    INSERT INTO api_collate_player(
      center_id, center_name, master_id, master_name, --currency, --v1.01  2018/02/28  Laser
      site_id, site_name, topagent_id, topagent_name,
      agent_id, agent_name, player_id, player_name,
      api_id, api_type_id, game_type,
      static_date, static_time, static_time_end, create_time,
      transaction_order, transaction_volume, effective_transaction,
      profit_loss, winning_amount, contribution_amount
    ) SELECT
          n_center_id, c_center_name, n_master_id, c_master_name, --c_currency, --v1.01  2018/02/28  Laser
          n_site_id, c_site_name, u.topagent_id, u.topagent_name,
          u.agent_id, u.agent_name, u.id, u.username,
          p.api_id, p.api_type_id, p.game_type,
          d_static_date, d_start_time::TIMESTAMP, d_end_time::TIMESTAMP, now(),
          p.transaction_order, p.transaction_volume, p.effective_transaction,
          p.profit_loss, p.winning_amount, p.contribution_amount
        FROM (SELECT
                  player_id, api_id, api_type_id, game_type,
                  COUNT(order_no)                as transaction_order,
                  COALESCE(SUM(single_amount), 0.00)      as transaction_volume,
                  COALESCE(SUM(profit_amount), 0.00)      as profit_loss,
                  COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
                  COALESCE(SUM(winning_amount), 0.00) as winning_amount,
                  COALESCE(SUM(contribution_amount), 0.00) as contribution_amount
               FROM player_game_order
              WHERE payout_time >= d_start_time::TIMESTAMP
                AND payout_time < d_end_time::TIMESTAMP
                AND api_id = ANY ( rec.apis::INT[] )
                AND order_state = 'settle'
              GROUP BY player_id, api_id, api_type_id, game_type
              ) p, v_sys_user_tier u
        WHERE p.player_id = u.id;
	END IF;


	  GET DIAGNOSTICS n_count = ROW_COUNT;
	  raise notice '本次插入数据量 %', n_count;
	  rtn = rtn||chr(13)||chr(10)||'          |api:'||rec.apis::TEXT||'执行完毕,新增记录数: '||n_count||' 条||';

  END LOOP;

  perform dblink_disconnect('mainsite');
  return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gb_api_collate_player(p_comp_url TEXT, p_curday TEXT, p_apis TEXT)
IS 'Laser-API注单核对-玩家报表';