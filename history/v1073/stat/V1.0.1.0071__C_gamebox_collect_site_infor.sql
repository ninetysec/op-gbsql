-- auto gen by george 2017-10-13 20:16:09
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
    raise notice '% : %', rpad(rec.siteid::TEXT, 4), rec.sitename;
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