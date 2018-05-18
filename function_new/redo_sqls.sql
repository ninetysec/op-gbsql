CREATE OR REPLACE FUNCTION redo_sqls(sqls text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
/*版本更新说明
--版本   时间        作者   内容
--v1.00  2015/01/01  Will   创建此函数
--v1.10  2016/05/12  Laser  优化代码，修改查询条件限制为当前Schema
--v1.11  2017/08/16  Laser  增加对rename各种对象的支持
--v1.12  2018/01/28  Laser  改为执行原语句

*/
DECLARE
  arr TEXT[];
  tmp VARCHAR[];
  s TEXT;
  obj_name VARCHAR;
  sql_str VARCHAR;
  cnt INT := 0;

BEGIN
  SELECT regexp_split_to_array(sqls, ';') INTO arr;
  <<lbl1>>FOREACH s IN array arr
  LOOP

    --v1.12  2018/01/28  Laser
    cnt = 0;
    s := trim(s, chr(13)||chr(10));
    sql_str = s;
    sql_str := trim(sql_str, ' ');
    sql_str := lower(sql_str);
    sql_str := replace(sql_str, '"', '');

    --raise info 'sql_str: %', sql_str;
    IF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+add\s+column\s+\S+') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+add\s+column\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      --SELECT count(*) INTO cnt FROM information_schema.columns WHERE table_schema='public' AND table_name=obj_name AND column_name=tmp[2];
      SELECT count(*) INTO cnt
        FROM information_schema.columns
       WHERE table_name = obj_name
         AND column_name = tmp[2]
         AND table_schema = current_schema;

    ELSEIF regexp_matches(sql_str, 'create\s+sequence \S+') IS NOT NULL THEN
      obj_name := (regexp_matches(sql_str, 'create\s+sequence (\S+)'))[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      --SELECT count(*) INTO cnt FROM pg_class WHERE relkind='S' AND relname=obj_name AND pg_table_is_visible(oid);
      SELECT count(*) INTO cnt
        FROM pg_class
       WHERE relkind = 'S'
         AND relname = obj_name
         AND pg_table_is_visible(oid);

    ELSEIF regexp_matches(sql_str, 'create(\s+\S+\s+|\s+)index\s+\S+\s+on\s+\S+') IS NOT NULL THEN
      obj_name := (regexp_matches(sql_str, 'create(\s+\S+\s+|\s+)index\s+(\S+)\s+on\s+\S+'))[2];
      --SELECT count(*) INTO cnt FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind = 'i' AND c.relname = obj_name;
      SELECT count(*) INTO cnt
        FROM pg_class c
        JOIN pg_namespace n
          ON c.relnamespace = n.oid
       WHERE c.relkind = 'i'
         AND c.relname = obj_name
         AND n.nspname = current_schema;

    ELSEIF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+add\s+constraint\s+\S+') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+add\s+constraint\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      --SELECT count(*) INTO cnt FROM information_schema.constraint_column_usage WHERE table_name = obj_name AND constraint_name = tmp[2];
      SELECT count(*) INTO cnt
        FROM information_schema.constraint_table_usage
       WHERE table_name = obj_name
         AND constraint_name = tmp[2]
         AND constraint_schema = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+table\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      SELECT count(*) INTO cnt
        FROM information_schema.tables
       WHERE table_name = tmp[3]
         AND table_schema = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+sequence\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+sequence\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      SELECT count(*) INTO cnt
        FROM information_schema.sequences
       WHERE sequence_name = tmp[3]
         AND sequence_schema = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+index\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+index\s+(if\s+exists\s+)?(\S+)\s+rename\s+to\s+(\S+)');
      obj_name := tmp[1];
      --SELECT count(*) INTO cnt FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind = 'i' AND c.relname = obj_name;
      SELECT count(*) INTO cnt
        FROM pg_class c
        JOIN pg_namespace n
          ON c.relnamespace = n.oid
       WHERE c.relkind = 'i'
         AND c.relname = tmp[3]
         AND n.nspname = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+rename\s+constraint\s+\S+\s+to\s+\S+') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+rename\s+constraint\s+(\S+)\s+to\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      SELECT count(*) INTO cnt
        FROM information_schema.constraint_table_usage
       WHERE table_name = obj_name
         AND constraint_name = tmp[3]
         AND constraint_schema = current_schema;

    --v1.02  2017/08/16  Laser
    ELSEIF regexp_matches(sql_str, 'alter\s+table\s+\S+\s+rename\s+column\s+\S+\s+to\s+\S+') IS NOT NULL THEN
      tmp := regexp_matches(sql_str, 'alter\s+table\s+(\S+)\s+rename\s+column\s+(\S+)\s+to\s+(\S+)');
      obj_name := tmp[1];
      --IF position('public.' in obj_name) = 1 THEN
      --  obj_name := (regexp_matches(obj_name, 'public\.(\w+)'))[1];
      --END IF;
      SELECT count(*) INTO cnt
        FROM information_schema.columns
       WHERE table_name = obj_name
         AND column_name = tmp[3]
         AND table_schema = current_schema;

    END IF;

    IF cnt = 0 AND s <> '' THEN
      RAISE NOTICE '【run SQL】 : %', s;
      execute s;
    ELSEIF cnt > 0 AND s <> '' THEN
      RAISE NOTICE '【skip SQL】 : %', s;
    END IF;

  END LOOP lbl1;

END;
$function$
;
COMMENT ON FUNCTION redo_sqls(sqls text)
IS 'Will-重复执行脚本';
