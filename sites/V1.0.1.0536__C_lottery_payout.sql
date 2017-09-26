-- auto gen by cherry 2017-09-26 20:41:12
DROP FUNCTION IF EXISTS gamebox_contract_scheme(int);
CREATE OR REPLACE FUNCTION gamebox_contract_scheme(site_id int)
  returns hstore AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 取得站点包网方案
--v1.01  2017/08/12  Leisure  已经停运的站点依然需要取得上个月的包网
*/
DECLARE
  rec record;
BEGIN
  FOR rec IN
    select a."id",
         a.ensure_consume,
         a.maintenance_charges,
         b.id site_id
      from sys_site b,contract_scheme a
     where b.id = site_id
       --and b.status = '1'
         and b.site_net_scheme_id = a.id
       --and a.status = '1'
  LOOP
    return hstore(rec);
  END LOOP;

  RETURN NULL;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_contract_scheme(site_id int)
IS 'Lins-包网方案-方案信息';