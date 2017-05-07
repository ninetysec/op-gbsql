/*
* 创建站点游戏临时视图.用完就删除
* @author Lins
* @date 2015.11.17
* @参数1: dblink 连接字符串
* @参数2：视图名称
* @参数3: 站点ID.
* 调用方式：select * from gamebox_site_game('host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres','vsite_game',1);
*/
create or replace function gamebox_site_game(url text,vname text,site_id INT) returns void as $$
DECLARE
	num int:=0;
BEGIN
select count(*) from pg_views where viewname=''||vname||'' into num;
	--raise info 'num:%',num;
	if num>0 THEN
		execute 'drop view '||vname;
	END IF;
EXECUTE
'create or replace view '||vname||' as
select * from dblink('''||url||''',
''select id,game_id,api_id,game_type,game_type_parent from site_game where site_id='||site_id||''')
 as p(id int4,game_id int4,api_id int4,game_type VARCHAR,game_type_parent VARCHAR)';

END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_site_game(url text,vname text,site_id INT) IS '返佣-游戏API临时视图-Lins';
--select * from gamebox_site_game('host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres','v_site_game',1);