-- auto gen by linsen 2018-01-29 20:12:48
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