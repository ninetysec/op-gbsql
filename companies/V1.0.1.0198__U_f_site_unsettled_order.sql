-- auto gen by bruce 2016-10-15 13:51:39
DROP FUNCTION if EXISTS f_site_unsettled_order();
CREATE OR REPLACE FUNCTION "f_site_unsettled_order"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare
rec_site	RECORD;
hostaddr VARCHAR;--数据库主机地址
hostport VARCHAR;--数据库端口
dbname VARCHAR;--数据库名称
dbuser VARCHAR;--用户名
dbpwd VARCHAR;--密码
dburl VARCHAR;--数据库连接
create_time TIMESTAMP;--统计时间
unsettled_sql VARCHAR;--未结算统计sql
unsettled RECORD;--数据库连接

BEGIN
create_time=now();
--统计未结算信息
unsettled_sql = 'SELECT api_id,api_type_id,count(1) as cnt FROM player_game_order  WHERE order_state=''pending_settle'' and bet_time>= ''' ||(create_time - '30d'::INTERVAL) || ''' and bet_time <= '''|| create_time ||'''  GROUP BY api_id,api_type_id';
raise notice '统计的SQL为:%',unsettled_sql;
FOR rec_site IN (SELECT ds.*,s.parent_id,u.id as master_id,u.username as master_name FROM ((sys_datasource ds LEFT OUTER JOIN sys_site  s ON ds.id=s."id") LEFT OUTER JOIN sys_user u ON s.sys_user_id=u."id"))
loop
--站点的数据库信息
hostaddr = rec_site.ip;
hostport = rec_site.port;
dbname = rec_site.dbname;
dbuser = rec_site.username;
dbpwd = rec_site.password;
dburl='host=' || hostaddr || ' port=' || hostport || ' dbname=' || dbname  || ' user='  || dbuser  || ' password=' ||dbpwd;
raise notice '统计站点:%,url:%',rec_site.id,dburl;

SELECT * FROM dblink(dburl,unsettled_sql) as unsettled_temp(api_id int,api_type_id int,cnt int) INTO unsettled;
DELETE FROM stat_site_order WHERE site_id=rec_site.id;
FOR unsettled in  (SELECT * FROM dblink(dburl,unsettled_sql) as unsettled_temp(api_id int,api_type_id int,cnt int) )
loop
INSERT INTO stat_site_order ("parent_id", "master_id", "master_name", "site_id", "api_id", "api_type_id", "unsettled_num", "create_time")
VALUES
(rec_site.parent_id,rec_site.master_id,rec_site.master_name,rec_site.id,unsettled.api_id,unsettled.api_type_id,unsettled.cnt,create_time);
END loop;
END loop;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;


DROP FUNCTION if EXISTS f_site_distribute_order();
CREATE OR REPLACE FUNCTION "f_site_distribute_order"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare
rec_site	RECORD;
hostaddr VARCHAR;--数据库主机地址
hostport VARCHAR;--数据库端口
dbname VARCHAR;--数据库名称
dbuser VARCHAR;--用户名
dbpwd VARCHAR;--密码
dburl VARCHAR;--数据库连接
create_time TIMESTAMP;--查询时间
unsettled_sql VARCHAR;--未结算统计sql
unsettled RECORD;--数据库连接

BEGIN
create_time=now();
--查询未结算信息
unsettled_sql = 'SELECT bet_id FROM player_game_order  WHERE order_state=''pending_settle'' and bet_time>= ''' ||(create_time - '7d'::INTERVAL) || ''' and bet_time <= '''|| create_time ||'''';
raise notice '查询SQL为:%',unsettled_sql;
FOR rec_site IN (SELECT ds.*,s.parent_id,u.id as master_id,u.username as master_name FROM ((sys_datasource ds LEFT OUTER JOIN sys_site  s ON ds.id=s."id") LEFT OUTER JOIN sys_user u ON s.sys_user_id=u."id"))
loop
--站点的数据库信息
hostaddr = rec_site.ip;
hostport = rec_site.port;
dbname = rec_site.dbname;
dbuser = rec_site.username;
dbpwd = rec_site.password;
dburl='host=' || hostaddr || ' port=' || hostport || ' dbname=' || dbname  || ' user='  || dbuser  || ' password=' ||dbpwd;
raise notice '站点:%,url:%',rec_site.id,dburl;
FOR unsettled in  (SELECT * FROM dblink(dburl,unsettled_sql) as unsettled_temp(bet_id VARCHAR))
loop
UPDATE api_order SET distribute_state='0' WHERE bet_id = unsettled.bet_id;
END loop;
END loop;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;