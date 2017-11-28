-- auto gen by cherry 2017-07-15 18:08:15
drop function IF EXISTS gamebox_collect_site_infor(text, int);
create or replace function gamebox_collect_site_infor(
  hostinfo   text,
  site_id   int
) returns json as $$
declare
  rec record;
BEGIN
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-收集站点相关信
--v1.10  2017/07/01  Leisure  修改DBLINK的连接方式
*/
  --v1.10  2017/07/01  Leisure
  perform dblink_connect_u('mainsite', hostinfo);

  SELECT into rec * FROM
  dblink (
    'mainsite',  -- hostinfo, --v1.01  2017/07/01  Leisure
    'SELECT * from v_sys_site_info WHERE siteid='||site_id||''
  ) AS s (
    siteid     int4,    --站点ID
    sitename   VARCHAR,    --站点名称
    masterid   int4,    --站长ID
    mastername   VARCHAR,    --站长名称
    usertype   VARCHAR,    --用户类型
    subsyscode   VARCHAR,
    operationid int4,    --运营商ID
    operationname     VARCHAR,    --运营商名称
    operationusertype   VARCHAR,
    operationsubsyscode VARCHAR
  );

  perform dblink_disconnect('mainsite');

  IF FOUND THEN
    return row_to_json(rec);
  ELSE
    return (SELECT '{"siteid": -1}'::json);
  END IF;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_collect_site_infor(hostinfo text,site_id int)
IS 'Lins-经营报表-收集站点相关信息';