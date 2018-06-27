drop function if exists gamebox_current_site();
create or replace function gamebox_current_site() returns int as $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2015/01/01  Lins    创建此函数: 取得当前站点ID
--v1.01  2018/05/24  Laser   修改获取规则
*/
DECLARE
	n_id int;
BEGIN
	--SELECT site_id FROM sys_user WHERE site_id is not null LIMIT 1 INTO id;
  SELECT replace( CURRENT_SCHEMA, 'gb-site-', '')::int INTO n_id;
	return id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_current_site()
IS 'Lins-运营商占成-取得当前站点ID';
