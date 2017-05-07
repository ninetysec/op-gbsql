-- auto gen by cherry 2016-01-26 14:34:22
DROP FUNCTION IF EXISTS "dblink_close_all()()"();

CREATE OR REPLACE FUNCTION dblink_close_all()
  RETURNS void AS
$BODY$

declare dbnames varchar[];

declare dbname varchar;

BEGIN

	select dblink_get_connections() into dbname;

	if dbname is not null THEN

	raise notice '当前所有跨数据库连接名称:%',dbname;

	dbname:=replace(dbname,'{','');

	dbname:=replace(dbname,'}','');

  dbnames:=regexp_split_to_array(dbname,',');

	if array_length(dbnames,1)>0 THEN

	for i in 1..array_length(dbnames,1) loop

		raise notice '名称:%',dbnames[i];

		--perform dblink_close(dbnames[i]);

		perform dblink_disconnect(dbnames[i]);

	end loop;

	end if;

	else

		raise notice '当前没有连接';

	end if;

END

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION dblink_close_all()
  OWNER TO postgres;
COMMENT ON FUNCTION dblink_close_all() IS 'Lins-关闭所有dblink连接.';
