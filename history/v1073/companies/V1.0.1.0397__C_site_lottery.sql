-- auto gen by cherry 2017-08-18 20:43:44

  select redo_sqls($$
     ALTER TABLE lottery_winning_record ADD COLUMN create_time timestamp(6);
      $$);
COMMENT on COLUMN lottery_winning_record.create_time is '创建时间';

CREATE TABLE  IF not EXISTS site_lottery(
	id serial4 not NULL PRIMARY key,
	site_id int4 not NULL,
code varchar(32),
status varchar(16),
order_num int4,
terminal varchar(2),
type varchar(32)
);
COMMENT on TABLE site_lottery is '站点彩票';
comment on COLUMN site_lottery.id is '主键';
comment on COLUMN site_lottery.site_id is '站点id';
comment on COLUMN site_lottery.code is '彩种';
comment on COLUMN site_lottery.order_num is '顺序';
comment on COLUMN site_lottery.terminal is '终端';
comment on COLUMN site_lottery.type is '彩种类型';

DROP FUNCTION if EXISTS f_init_lottery(siteid int4);
CREATE OR REPLACE FUNCTION f_init_lottery(siteid int4)
	RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
	INSERT INTO "site_lottery" ("site_id", "code", "status", "order_num", "terminal","type")
		SELECT siteid, code, status, order_num, terminal,type FROM lottery l
		WHERE not EXISTS (SELECT sl.id from site_lottery sl where site_id=siteid and sl.code=l.code);
		GET DIAGNOSTICS v_count = ROW_COUNT;
		raise notice '同步站点彩种:%,执行%条',siteid,v_count;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT on FUNCTION f_init_lottery(siteid int4) is '根据站点同步彩种';

CREATE OR REPLACE FUNCTION "f_update_site_lottery"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare

rec_site	RECORD;
BEGIN

FOR rec_site IN (SELECT * FROM sys_site where status='1' and id >0)
loop
  PERFORM f_init_lottery(rec_site.id);
END loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT on FUNCTION f_update_site_lottery() is '同步彩种';
