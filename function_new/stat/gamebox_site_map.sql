DROP FUNCTION IF EXISTS gamebox_site_map(INT);
CREATE OR REPLACE FUNCTION gamebox_site_map(
  sid INT
) returns hstore AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 收集站点相关信息
--v1.01  2017/08/01  Leisure  TRUNCATE改为DELETE
*/
DECLARE
  rec     record;
  dict_map   hstore;
BEGIN
  FOR rec IN
    SELECT  * FROM sys_site_info WHERE siteid = sid
  LOOP
    SELECT 'site_id=>'||rec.siteid INTO dict_map;
    IF rec.sitename != null AND rec.sitename != '' THEN
      dict_map = (SELECT ('site_name=>"'||rec.sitename||'"')::hstore)||dict_map;
    END IF;
    dict_map = (SELECT ('master_id=>'||rec.masterid)::hstore)||dict_map;
    dict_map = (SELECT ('master_name=>'||rec.mastername)::hstore)||dict_map;
    dict_map = (SELECT ('center_id=>'||rec.operationid)::hstore)||dict_map;
    dict_map = (SELECT ('center_name=>'||rec.operationname)::hstore)||dict_map;
  END LOOP;
  IF dict_map is null THEN
    SELECT '-1=>-1' INTO dict_map;
  END IF;

  RETURN dict_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_map(sid INT)
IS 'Lins-站点信息';
