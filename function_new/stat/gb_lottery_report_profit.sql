DROP FUNCTION IF EXISTS  gb_lottery_report_profit(p_comp_url text, p_static_date text);
CREATE OR REPLACE FUNCTION gb_lottery_report_profit(
  p_comp_url text,
  p_static_date text
) RETURNS INT AS $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/09/23  Laser    创建此函数: 彩票报表统计

  返回值说明：0成功，1警告，2错误
*/
DECLARE
  rec   record;
  rec_ds record;
  site_url text;
  pc_id int;

  n_exec_num  INT := 0;
  n_error_num INT := 0;

  d_static_date DATE;
  t_static_start  TIMESTAMP;
  t_static_end    TIMESTAMP;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  d_static_date := p_static_date::DATE;

  DELETE FROM lottery_report_profit WHERE static_date = d_static_date;

  perform dblink_connect_u('mainsite', p_comp_url);

  FOR rec_ds IN
    SELECT *
      FROM dblink('mainsite',
                  'SELECT parent_id comp_id, sys_user_id master_id, d.id site_id, d.name site_name, timezone,
                          CASE idc WHEN ''A'' THEN ip ELSE remote_ip END ip, CASE idc WHEN ''A'' THEN port ELSE remote_port END port, dbname, username, password
                     FROM sys_site s, sys_datasource d WHERE s.id = d.id
                    ORDER BY site_id'
                 ) AS si( comp_id INT, master_id INT, site_id INT, site_name varchar(16), timezone varchar(16),
                          ip varchar(15), port int4, dbname varchar(32), username varchar(32), password varchar(128)
                        )
  LOOP
    n_exec_num := n_exec_num + 1;

    t_static_start := d_static_date - replace(rec_ds.timezone, 'GMT', '')::interval;
    t_static_end   := t_static_start + '1d';

    site_url = 'host=' || rec_ds.ip || ' port=' || rec_ds.port || ' dbname=' || rec_ds.dbname || ' user=' || rec_ds.username || ' password=' || rec_ds.password;

    RAISE NOTICE '正在收集站点：%', rec_ds.username;

    BEGIN
      perform dblink_connect_u('master', site_url);

      INSERT INTO lottery_report_profit ( center_id, site_id, code, play_code, bet_code, bet_amount, bet_volume, payout,
                                          static_date, static_start, static_end
      ) SELECT ssi.operationid, rec_ds.site_id, code, play_code, bet_code, bet_amount, bet_volume, payout,
               d_static_date, t_static_start, t_static_end
          FROM dblink('master',
                      'SELECT code, play_code, bet_code, SUM(bet_amount) bet_amount, COUNT(id) bet_volume,
                              SUM(payout) payout
                         FROM lottery_bet_order
                        WHERE status = ''2''
                          AND payout_time >= ''' || t_static_start || '''
                          AND payout_time <  ''' || t_static_end || '''
                        GROUP BY code, play_code, bet_code'
                     ) AS lbo( code varchar(32), play_code varchar(32), bet_code varchar(32),
                               bet_amount numeric(20,2), bet_volume INT, payout numeric(20,2)
                             )
                     JOIN sys_site_info ssi ON ssi.siteid = rec_ds.site_id;

      perform dblink_disconnect('master');
  EXCEPTION
    WHEN OTHERS THEN
      IF '{master}' IN (SELECT dblink_get_connections()) THEN
        perform dblink_disconnect('master');
      END IF;

      RAISE NOTICE '收集站点：% 出错! 继续收集下一个站点...', rec_ds.username;
      n_error_num := n_error_num + 1;
  END;

  END LOOP;

  RAISE NOTICE '收集完毕. 共收集%个站点, 其中%个失败.', n_exec_num, n_error_num;

  perform dblink_disconnect('mainsite');

  IF n_error_num <> 0 THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;

EXCEPTION

  WHEN QUERY_CANCELED THEN
    perform dblink_disconnect_all();
    RETURN 2;
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;
    perform dblink_disconnect_all();
    RETURN 2;

END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION gb_lottery_report_profit(p_comp_url text, p_static_date text) IS 'Laser-彩票报表统计';
