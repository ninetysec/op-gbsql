-- auto gen by steffan 2018-08-22 14:23:06
drop function IF EXISTS gamebox_collect_site_infor(text);
 CREATE OR REPLACE FUNCTION "gb-stat"."gamebox_collect_site_infor"("hostinfo" text)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2015/01/01  Lins    创建此函数: 收集站点相关信息
--v1.10  2017/06/29  Laser   TRUNCATE改为DELETE
--v1.11  2017/07/10  Laser   修改DBLINK连接方式，回收SU
--v1.12  2018/02/28  Laser   修改SELECT * FROM 视图这种糟糕的写法，
                             增加currency、timezone字段
--v1.13  2018/08/22   Min    去除过长的站点日志
*/
declare
  sql text:='';
  count_num int:= 0;
  rec record;

BEGIN
  --v1.01  2017/07/10  Laser
  perform dblink_connect_u('mainsite', hostinfo);

  --v1.13  2018/08/22   Min
  SELECT * into count_num from dblink('mainsite', 'SELECT count(1) from v_sys_site_info') as n (count_num INTEGER) ;
  raise notice '同步stat库站点数据,总数:%', count_num;

  --v1.02  2018/02/28  Laser
  sql:='SELECT *
          FROM dblink (''mainsite'',
                       ''SELECT siteid, sitename, masterid, mastername, usertype, subsyscode, centerid, centername,
                                operationid, operationname, operationusertype, operationsubsyscode, currency, timezone
                           FROM v_sys_site_info'')
        AS s(
             siteid int4,
             sitename VARCHAR,
             masterid int4,
             mastername VARCHAR,
             usertype VARCHAR,
             subsyscode VARCHAR,
             centerid int4,
             centername VARCHAR,
             operationid int4,
             operationname VARCHAR,
             operationusertype VARCHAR,
             operationsubsyscode VARCHAR,
             currency VARCHAR,
             timezone VARCHAR
            )';

  -- FOR rec in EXECUTE sql LOOP
  --  raise notice 'name:%', rec.sitename;
  --END LOOP;

  --v1.10  2017/06/29  Laser
  --execute 'truncate table sys_site_info';
  DELETE FROM sys_site_info;
  execute 'insert into sys_site_info '||sql;

  perform dblink_disconnect('mainsite');
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_collect_site_infor(hostinfo text)
IS 'Lins-经营报表-收集站点相关信息';