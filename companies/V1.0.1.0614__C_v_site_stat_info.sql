-- auto gen by steffan 2018-05-15 16:21:02
-- create by cherry
DROP VIEW IF EXISTS v_site_stat_info;
CREATE OR REPLACE VIEW v_site_stat_info AS
WITH recursive
sif AS
  (SELECT parent_id comp_id, sys_user_id master_id, d.username site, s.id site_id, d.name, code, template_code,
          timezone, opening_time,
          timezone(timezone, opening_time)::date opening_date,
          timezone(timezone, opening_time)::date - replace(timezone, 'GMT', '')::interval stat_time,
          date_trunc('month', timezone(timezone, opening_time))::date stat_date_month,
          date_trunc('month', timezone(timezone, opening_time))::date - replace(timezone, 'GMT', '')::interval stat_time_month,
          d.idc, d.ip hostname, CASE WHEN d.idc = 'A' THEN d.ip ELSE d.remote_ip END host, CASE WHEN d.idc = 'A' THEN d.port ELSE d.remote_port END port, d.password,
          'host=' || rpad(CASE WHEN d.idc = 'A' THEN d.ip ELSE d.remote_ip END, 16) || ' port=' ||
          CASE WHEN d.idc = 'A' THEN d.port ELSE d.remote_port END || ' dbname=' || d.dbname || ' user=' || rpad(d.username, 12) || ' password=' || d.password AS url
    FROM sys_site s, sys_datasource d WHERE s.id = d.id ORDER BY d.ip, s.id
  ),
sir AS
  (SELECT 1::INT num, master_id, site, site_id, idc, hostname, host, port, password, url, timezone, opening_date stat_date, stat_time, stat_date_month, stat_time_month FROM sif
    UNION ALL
   SELECT num + 1, master_id, site, site_id, idc, hostname, host, port, password, url, timezone, stat_date + 1, stat_time + '1d'::interval, date_trunc('month', stat_date + 1)::date stat_date_month, date_trunc('month', stat_date + 1)::date - replace(timezone, 'GMT', '')::interval stat_time_month FROM sir
    WHERE stat_time + '2d' < now()
  ),
sinfo AS
  (SELECT num, master_id, site, site_id, idc, hostname, host, port, password, url, timezone, stat_date, stat_time, stat_time + '1d'::interval stat_time_end,
          to_char(stat_date_month, 'YYYY-MM') stat_month, stat_date_month, stat_time_month, stat_date_month + '1mon'::interval - replace(timezone, 'GMT', '')::interval stat_time_month_end
     FROM sir
  )
SELECT * FROM sinfo ORDER BY site_id, num;

COMMENT ON VIEW v_site_stat_info IS 'Laser - 站点统计相关信息';