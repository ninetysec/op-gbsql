-- auto gen by bruce 2016-10-11 10:14:40
select redo_sqls($$
    ALTER TABLE site_api_type_relation_i18n ADD COLUMN site_id int4;
    ALTER TABLE site_api_type_relation_i18n ADD COLUMN api_id int4;
    ALTER TABLE site_api_type_relation_i18n ADD COLUMN api_type_id int4;
$$);

DROP TABLE if EXISTS stat_site_order;
CREATE TABLE stat_site_order
(
  id serial NOT NULL, -- 主键
  parent_id integer,--运营商ｉｄ
  master_id INTEGER,--站长ｉｄ
  master_name character varying(32),--站长账号
  site_id integer, -- 站点id
  api_id integer, -- apiid
  api_type_id integer, -- api分类
  unsettled_num integer, -- 未结算总条数
  create_time timestamp(6) without time zone, -- 入库时间
  CONSTRAINT stat_site_order_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE stat_site_order IS '站点未结算注单统计表';
COMMENT ON COLUMN stat_site_order.id IS '主键';
COMMENT ON COLUMN stat_site_order.parent_id IS '运营商ｉｄ';
COMMENT ON COLUMN stat_site_order.master_id IS '站长ｉｄ';
COMMENT ON COLUMN stat_site_order.master_name IS '站长账号';
COMMENT ON COLUMN stat_site_order.site_id IS '站点id ';
COMMENT ON COLUMN stat_site_order.api_id IS 'apiid';
COMMENT ON COLUMN stat_site_order.api_type_id IS 'api分类';
COMMENT ON COLUMN stat_site_order.unsettled_num IS '未结算总条数';
COMMENT ON COLUMN stat_site_order.create_time IS '入库时间';


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
unsettled_sql = 'SELECT api_id,api_type_id,count(1) as cnt FROM player_game_order  WHERE order_state=''pending_settle'' and payout_time>= ''' ||(create_time - '30d'::INTERVAL) || ''' and payout_time <= '''|| create_time ||'''  GROUP BY api_id,api_type_id';
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
IF unsettled IS NOT NULL THEN
DELETE FROM stat_site_order WHERE site_id=rec_site.id;
INSERT INTO stat_site_order ("parent_id", "master_id", "master_name", "site_id", "api_id", "api_type_id", "unsettled_num", "create_time")
VALUES
(rec_site.parent_id,rec_site.master_id,rec_site.master_name,rec_site.id,unsettled.api_id,unsettled.api_id,unsettled.api_type_id,create_time);
END IF;
END loop;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;