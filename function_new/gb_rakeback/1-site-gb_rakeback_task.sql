DROP FUNCTION IF EXISTS gb_rakeback_task(TEXT, TEXT, TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_rakeback_task(
  p_comp_url  TEXT,
	p_period 	TEXT,
	p_start_time 	TEXT,
	p_end_time 	TEXT,
	p_settle_flag 	TEXT
) RETURNS INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/06/17  Leisure   创建此函数: 返水结算账单.入口(调度)

  返回值说明：0成功，1警告，2错误
*/
DECLARE

	t_start_time 	TIMESTAMP;
	t_end_time 	TIMESTAMP;
  n_sid  INT;
  n_return_code INT := 0;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  t_start_time = clock_timestamp()::timestamp(0);

  perform gb_rakeback(p_period, p_start_time, p_end_time, p_settle_flag);

  t_end_time = clock_timestamp()::timestamp(0);

  IF p_settle_flag = 'Y' THEN

    SELECT gamebox_current_site() INTO n_sid;

    --perform dblink_close_all();
    --perform dblink_connect('master',  p_comp_url);

    SELECT t.return_code
      INTO n_return_code
      FROM
      dblink (p_comp_url,
              'SELECT * from gb_task_infomation_site( ''' || n_sid || ''', ''gb_rakeback'', ''返水结算账单'', ''' || p_period || ''', ''1'', ''' ||
               t_start_time || ''', ''' || t_end_time || ''', '''')'
             ) AS t(return_code INT);
    --perform dblink_disconnect('master');
  END IF;

  IF n_return_code <> 0 THEN
    RAISE INFO '任务记录未成功写入远端表';
  END IF;

RETURN 0;

EXCEPTION
  WHEN QUERY_CANCELED THEN
    RETURN 2;
  WHEN OTHERS THEN
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

COMMENT ON FUNCTION gb_rakeback_task( p_comp_url  TEXT, p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Leisure-返水结算账单.入口(调度)';
