DROP FUNCTION IF EXISTS gb_task_infomation_site(INT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_task_infomation_site(
  p_site_id INT,
  p_task_type TEXT,
  p_task_name  TEXT,
	p_task_period 	TEXT,
	p_task_status 	TEXT,
  p_start_time  TEXT,
	p_end_time 	TEXT,
	p_remark 	TEXT
) RETURNS INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/06/17  Laser     创建此函数: 任务信息日志-站点

  返回值说明：0成功，1警告，2错误
*/
DECLARE

	t_start_time 	TIMESTAMP;
	t_end_time 	TIMESTAMP;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  t_start_time = P_start_time::TIMESTAMP;
  t_end_time   = P_end_time::TIMESTAMP;

  UPDATE task_infomation SET is_effective = FALSE WHERE site_id = p_site_id AND task_type = p_task_type AND task_period = p_task_period AND is_effective = TRUE;

  INSERT INTO task_infomation(site_id, task_type, task_name, task_period, task_status, start_time, end_time, remark, is_effective)
                       VALUES(p_site_id, p_task_type, p_task_name, p_task_period, p_task_status, t_start_time, t_end_time, p_remark, TRUE);

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

COMMENT ON FUNCTION gb_task_infomation_site( p_site_id INT, p_task_type TEXT, p_task_name TEXT,	p_task_period TEXT, p_task_status TEXT, p_start_time TEXT, p_end_time TEXT, p_remark TEXT)
IS 'Laser-任务信息日志-站点';
