-- auto gen by cherry 2017-06-24 14:19:01
drop function if exists gb_task_infomation_site(INT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gb_task_infomation_site(
  p_site_id INT,
  p_task_type TEXT,
  p_task_name  TEXT,
	p_task_period 	TEXT,
	p_task_status 	TEXT,
  p_start_time  TEXT,
	p_end_time 	TEXT,
	p_remark 	TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/06/17  Leisure   创建此函数: 任务信息日志-站点

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
IS 'Leisure-任务信息日志-站点';

CREATE TABLE IF NOT EXISTS task_infomation (
id SERIAL4 PRIMARY KEY,
site_id INT,
task_type VARCHAR(20),
task_name VARCHAR(20),
task_period VARCHAR(20),
task_status VARCHAR(20),
start_time TIMESTAMP,
end_time TIMESTAMP,
remark VARCHAR(50),
is_effective BOOLEAN
);

COMMENT ON TABLE task_infomation IS '调度任务执行信息';
COMMENT ON COLUMN task_infomation.id IS '主键';
COMMENT ON COLUMN task_infomation.task_type IS '任务类型';
COMMENT ON COLUMN task_infomation.task_name IS '任务名';
COMMENT ON COLUMN task_infomation.task_period IS '任务区间（YYYY-MM-DD/YYYY-MM）';
COMMENT ON COLUMN task_infomation.task_status IS '任务状态（1：已生成；2：已结算）';
COMMENT ON COLUMN task_infomation.start_time IS '任务开始时间';
COMMENT ON COLUMN task_infomation.end_time IS '任务结束时间';
COMMENT ON COLUMN task_infomation.remark IS '备注';
COMMENT ON COLUMN task_infomation.is_effective IS '是否是有效记录';

DROP VIEW v_sys_site_manage;

SELECT redo_sqls($$
ALTER TABLE sys_datasource ADD COLUMN remote_ip VARCHAR(32);
ALTER TABLE sys_datasource ADD COLUMN remote_port INTEGER;
ALTER TABLE sys_datasource ALTER COLUMN ip TYPE VARCHAR(32);
$$);

CREATE OR REPLACE VIEW v_sys_site_manage AS
 SELECT ss.id,
    ss.sys_user_id,
    u.username,
    ss.theme,
    ss.sso_theme,
    ss.status,
    ss.is_buildin,
    ss.postfix,
    ss.short_name,
    i18n_center.value AS parent_name,
    i18n_site.value AS site_name,
    ss.main_currency,
    ss.main_language,
    ss.web_site,
    ss.opening_time,
    ss.timezone,
    ss.traffic_statistics,
    ss.code,
    ss.logo_path,
    ss.site_classify_key,
    ss.site_net_scheme_id,
    ss.max_profit,
    u.owner_id,
    u.site_id AS center_id,
    ss.deposit,
    ss.template_code,
    ss.import_players_time,
    ss.maintain_start_time,
    ss.maintain_end_time,
    (((ds.ip::text || '|'::text) || ds.dbname::text) || '|'::text) || ds.username::text AS db,
    (((replace(replace(ds.report_url::text, ':5432/gb-sites?characterEncoding=UTF-8'::text, ''::text), 'jdbc:postgresql://'::text, ''::text) || '|'::text) || ds.dbname::text) || '|'::text) || ds.username::text
AS backupdb,
    ss.main_language AS locale,
    ( SELECT m.domain
           FROM sys_domain m
          WHERE m.site_id = ss.id AND m.subsys_code::text = 'msites'::text AND m.page_url::text = '/'::text
         LIMIT 1) AS domain,
    ss.remark,
    ss.belong_to_idc
   FROM sys_user u
     LEFT JOIN sys_site ss ON u.id = ss.sys_user_id
     LEFT JOIN sys_datasource ds ON ss.id = ds.id
     LEFT JOIN site_i18n i18n_center ON u.site_id = i18n_center.site_id AND i18n_center.type::text = 'site_name'::text AND i18n_center.locale = u.default_locale::bpchar
     LEFT JOIN site_i18n i18n_site ON ss.id = i18n_site.site_id AND i18n_site.type::text = 'site_name'::text AND i18n_site.locale = ss.main_language::bpchar
  WHERE u.user_type::text = '2'::text;