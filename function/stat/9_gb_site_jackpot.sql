DROP FUNCTION IF EXISTS gb_site_jackpot_api(comp_url text, t_api_id integer, t_jackpot_name text, t_game_id text, static_begin_time text, static_end_time text, t_static_month text);
CREATE OR REPLACE FUNCTION gb_site_jackpot_api(comp_url text, t_api_id integer, t_jackpot_name text, t_game_id text, static_begin_time text, static_end_time text, t_static_month text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/12/07  wayne     创建此函数: 彩池贡献金-API
*/
DECLARE
  rec   record;
  rec_ds record;
  site_url text;
  pc_id int;
  select_sql text;
BEGIN

  DELETE FROM site_jackpot t WHERE t.static_month = t_static_month AND t.api_id = t_api_id AND t.jackpot_name = t_jackpot_name and bill_type='api';

  FOR rec_ds IN
  SELECT comp_id, master_id, site_id, site_name, ip, port, dbname, username, password
    FROM dblink(comp_url,
                'SELECT parent_id comp_id, sys_user_id master_id, d.id site_id, d.name site_name,
                        ip, port, dbname, username, password
                   FROM sys_site s, sys_datasource d where s.id = d.id
                  ORDER BY site_id')
      AS si( comp_id INT, master_id INT, site_id INT, site_name varchar(16),
             ip varchar(32), port int4, dbname varchar(32), username varchar(32), password varchar(128)
           )
  LOOP
    site_url = 'host=' || rec_ds.ip || ' port=' || rec_ds.port || ' dbname=' || rec_ds.dbname || ' user=' || rec_ds.username || ' password=' || rec_ds.password;
    select_sql = 'SELECT SUM (contribution_amount) contribution_amount,SUM (winning_amount) winning_amount
                    FROM player_game_order
                   WHERE api_id = '|| t_api_id ||' AND order_state=''settle'' AND game_type=''Casino''
                     AND payout_time>=''' || static_begin_time::timestamp || ''' AND payout_time < ''' || static_end_time::timestamp || '''';

    IF t_game_id!='' THEN select_sql = select_sql || ' AND game_id ' || t_game_id || ''; END IF ;


    RAISE INFO '正在收集站点：%,site_url: %,select_sql: %', rec_ds.username,site_url,select_sql;
    FOR rec IN
      SELECT contribution_amount,winning_amount FROM dblink(site_url,select_sql)  AS a("contribution_amount" NUMERIC,"winning_amount" NUMERIC)
    LOOP
      raise info 'api_id = %, contribution_amount = %, winning_amount = %', t_api_id, rec.contribution_amount, rec.winning_amount;

      INSERT INTO site_jackpot
        (comp_id, master_id, site_id, site_name, api_id, jackpot_name, static_month, contribution_amount,winning_amount, bill_type,create_time)
      VALUES
        (rec_ds.comp_id, rec_ds.master_id, rec_ds.site_id, rec_ds.site_name, t_api_id, t_jackpot_name, t_static_month, rec.contribution_amount,rec.winning_amount,'api',now()) RETURNING "id" into pc_id;
      raise info 'site_jackpot.新增.键值 = %', pc_id;

    END LOOP;
  END LOOP;
  RAISE INFO '统计 % END', rec_ds.site_name;

END;

$function$
;
COMMENT ON FUNCTION gb_site_jackpot_api(comp_url text, t_api_id integer, t_jackpot_name text, t_game_id text, static_begin_time text, static_end_time text, t_static_month text)
IS '彩池贡献金-API';


DROP FUNCTION IF EXISTS gb_site_jackpot_master(comp_url text, t_api_id integer, t_jackpot_name text, t_game_id text, t_static_month text);
CREATE OR REPLACE FUNCTION gb_site_jackpot_master(comp_url text, t_api_id integer, t_jackpot_name text, t_game_id text, t_static_month text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/12/07  wayne     创建此函数: 彩池贡献金-master
*/
DECLARE
  rec   record;
  rec_ds record;
  site_url text;
  pc_id int;
  select_sql text;
BEGIN

  DELETE FROM site_jackpot t WHERE t.static_month = t_static_month AND t.api_id = t_api_id AND t.jackpot_name = t_jackpot_name and bill_type='master';

  FOR rec_ds IN
  SELECT comp_id, master_id, site_id, site_name, ip, port, dbname, username, password, start_time, end_time
    FROM dblink(comp_url,
               'SELECT parent_id comp_id, sys_user_id master_id, d.id site_id, d.name site_name,
                       ip, port, dbname, username, password, to_timestamp(''' || t_static_month || ''', ''yyyy-mm'') - replace(timezone, ''GMT'', '''')::interval start_time, to_timestamp(''' || t_static_month |
|''', ''yyyy-mm'') + ''1 month'' - replace(timezone, ''GMT'', '''')::interval end_time
                  FROM sys_site s, sys_datasource d where s.id = d.id
                 ORDER BY site_id')
      AS si( comp_id INT, master_id INT, site_id INT, site_name varchar(16),
           ip varchar(32), port int4, dbname varchar(32), username varchar(32), password varchar(128), start_time timestamp, end_time timestamp
           )
  LOOP
    site_url = 'host=' || rec_ds.ip || ' port=' || rec_ds.port || ' dbname=' || rec_ds.dbname || ' user=' || rec_ds.username || ' password=' || rec_ds.password;
    select_sql = 'SELECT SUM (contribution_amount) contribution_amount,SUM (winning_amount) winning_amount
                    FROM player_game_order
                   WHERE api_id = '|| t_api_id ||' AND order_state=''settle'' and game_type=''Casino''
                     AND payout_time>=''' || rec_ds.start_time || ''' AND payout_time < ''' || rec_ds.end_time || '''';

    IF t_game_id!='' THEN select_sql = select_sql || ' AND game_id ' || t_game_id || ''; END IF ;


    RAISE INFO '正在收集站点：%,site_url: %,select_sql: %', rec_ds.username,site_url,select_sql;
    FOR rec IN
      SELECT contribution_amount,winning_amount FROM dblink(site_url,select_sql) AS a("contribution_amount" NUMERIC,"winning_amount" NUMERIC)
    LOOP
      raise info 'api_id = %, contribution_amount = %, winning_amount = %', t_api_id, rec.contribution_amount, rec.winning_amount;

      INSERT INTO site_jackpot
        (comp_id, master_id, site_id, site_name, api_id, jackpot_name, static_month, contribution_amount,winning_amount, bill_type,create_time)
      VALUES
        (rec_ds.comp_id, rec_ds.master_id, rec_ds.site_id, rec_ds.site_name, t_api_id, t_jackpot_name, t_static_month, rec.contribution_amount,rec.winning_amount,'master',now()) RETURNING "id"
 into pc_id;
      RAISE INFO 'site_jackpot.新增.键值 = %', pc_id;

    END LOOP;
  END LOOP;
  raise info '统计 % END', rec_ds.site_name;

END;

$function$
;
COMMENT ON FUNCTION gb_site_jackpot_master(comp_url text, t_api_id integer, t_jackpot_name text, t_game_id text, t_static_month text)
IS '彩池贡献金-master';
