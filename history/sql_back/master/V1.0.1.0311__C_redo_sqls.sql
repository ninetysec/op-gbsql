-- auto gen by kevice 2016-01-06 15:38:30

DROP FUNCTION IF EXISTS redo_sqls(text);

CREATE OR REPLACE FUNCTION redo_sqls(sqls text)
  RETURNS void AS
$BODY$declare
	arr text[];
  tmp varchar[];
	s text;
	obj_name varchar;
  sql_str varchar;
	cnt int := 0;
begin
  SELECT regexp_split_to_array(sqls, ';') INTO arr;
  <<lbl1>>foreach s in array arr
  loop
     s := btrim(s, chr(10));
     s := btrim(s, chr(13));
     s := btrim(s, ' ');
     sql_str := replace(lower(s), '"', '');
     IF regexp_matches(sql_str, 'create\s+sequence \S+') is not null THEN
				obj_name := (regexp_matches(sql_str, 'create\s+sequence (\S+)'))[1];
				IF position('' in obj_name) = 1 THEN
					obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
				END IF;
				select count(*) into cnt from pg_class where relkind='S' and relname=obj_name and pg_table_is_visible(oid);
     ELSEIF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+add\s+column\s+\S+') is not null THEN
        tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+add\s+column\s+(\S+)');
        obj_name := tmp[1];
				IF position('' in obj_name) = 1 THEN
					obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
				END IF;
				select count(*) into cnt from information_schema.columns where table_schema='public' and table_name=obj_name and column_name=tmp[2];
     ELSEIF regexp_matches(sql_str, 'create(\s+\S+\s+|\s+)index\s+\S+\s+on\s+\S+') is not null THEN
        obj_name := (regexp_matches(sql_str, 'create(\s+\S+\s+|\s+)index\s+(\S+)\s+on\s+\S+'))[2];
	SELECT count(*) into cnt FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind = 'i' AND c.relname = obj_name AND n.nspname = 'public';
     ELSEIF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+add\s+constraint\s+\S+') is not null THEN
        tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+add\s+constraint\s+(\S+)');
        obj_name := tmp[1];
	IF position('' in obj_name) = 1 THEN
		obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
	END IF;
	select count(*) into cnt from information_schema.constraint_column_usage where table_schema = 'public' and table_name = obj_name and constraint_name = tmp[2];
     END IF;

     IF cnt = 0 AND s <> '' THEN
			 execute s;
		 END IF;

  end loop lbl1;

end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION redo_sqls(text)
  OWNER TO postgres;