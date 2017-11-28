-- auto gen by cheery 2015-12-24 10:08:28
-- Function: f_calculator_deposit(integer, integer)

DROP FUNCTION if EXISTS f_calculator_deposit(integer, integer);

CREATE OR REPLACE FUNCTION f_calculator_deposit(playerid integer, player_recharge_id integer)
  RETURNS numeric AS
$BODY$ DECLARE
	sql_text VARCHAR ; --查询sql,获取当前玩家的有效交易量
	deposit_amount NUMERIC ; --存款金额
BEGIN
	sql_text = 'select recharge_amount from player_recharge where id= $1 and player_id= $2' ;
EXECUTE sql_text INTO deposit_amount USING player_recharge_id,
 playerid ;
 raise notice '查询玩家存款金额:%,结果:%',
	sql_text,
	deposit_amount ;
RETURN COALESCE (deposit_amount, 0) ;
END $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION f_calculator_deposit(integer, integer)
  OWNER TO postgres;
COMMENT ON FUNCTION f_calculator_deposit(integer, integer) IS '获取某玩家某次存款的金额';

-- Function: f_calculator_effective_transaction(integer, timestamp without time zone, timestamp without time zone)

DROP FUNCTION if EXISTS f_calculator_effective_transaction(integer, timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION f_calculator_effective_transaction(playerid integer, starttime timestamp without time zone, endtime timestamp without time zone)
  RETURNS numeric AS
$BODY$ DECLARE
	sql_text VARCHAR ; --查询sql,获取当前玩家的有效交易量
	effective_transaction NUMERIC ; --有效交易量
BEGIN
	sql_text = 'select sum(effective_trade_amount) from player_game_order  where player_id =$1 and payout_time >= $2 and payout_time <= $3' ;
 EXECUTE sql_text INTO effective_transaction USING playerid,
	starttime,
	endtime ;
	raise notice '查询玩家有效交易量的SQL:%,结果:%',
	sql_text,
	effective_transaction ;
RETURN COALESCE (effective_transaction, 0) ;
END $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION f_calculator_effective_transaction(integer, timestamp without time zone, timestamp without time zone)
  OWNER TO postgres;
COMMENT ON FUNCTION f_calculator_effective_transaction(integer, timestamp without time zone, timestamp without time zone) IS '计算时间范围内某玩家的有效交易量';


-- Function: f_calculator_profit_loss(integer, timestamp without time zone, timestamp without time zone)

DROP FUNCTION if EXISTS f_calculator_profit_loss(integer, timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION f_calculator_profit_loss(playerid integer, starttime timestamp without time zone, endtime timestamp without time zone)
  RETURNS numeric AS
$BODY$ DECLARE
	sql_text VARCHAR ; --查询sql,获取当前玩家的盈利金额
	profit_loss_amount NUMERIC ; --盈亏金额
BEGIN
sql_text = 'select sum(profit_amount) from player_game_order  where player_id =$1 and payout_time >= $2 and payout_time <= $3' ;
EXECUTE sql_text INTO profit_loss_amount USING playerid,
 starttime,
 endtime ;
raise notice '查询玩家盈亏情况的SQL为:%,该玩家的盈亏金额为:%',
 sql_text,
 profit_loss_amount ;
RETURN COALESCE (profit_loss_amount, 0) ;
END $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION f_calculator_profit_loss(integer, timestamp without time zone, timestamp without time zone)
  OWNER TO postgres;
COMMENT ON FUNCTION f_calculator_profit_loss(integer, timestamp without time zone, timestamp without time zone) IS '计算时间范围内某玩家的盈亏情况';


-- Function: f_calculator_total_assets(integer)

DROP FUNCTION if EXISTS f_calculator_total_assets(integer);

CREATE OR REPLACE FUNCTION f_calculator_total_assets(playerid integer)
  RETURNS numeric AS
$BODY$ DECLARE
	sql_text VARCHAR ; --查询sql,获取当前玩家的有效交易量
	total_assets NUMERIC ; --总资产
BEGIN
	sql_text = 'select total_assets from user_player where id= $1' ;
 EXECUTE sql_text INTO total_assets USING playerid;
 raise notice '查询玩家总资产的SQL:%,结果:%',
	sql_text,
	total_assets ;
RETURN COALESCE (total_assets, 0) ;
END $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION f_calculator_total_assets(integer)
  OWNER TO postgres;
COMMENT ON FUNCTION f_calculator_total_assets(integer) IS '计算某玩家当前的总资产';


-- Function: f_preferential_deposit(integer, numeric)

DROP FUNCTION if EXISTS f_preferential_deposit(integer, numeric);

CREATE OR REPLACE FUNCTION f_preferential_deposit(activitymessageid integer, money numeric)
  RETURNS SETOF record AS
$BODY$
declare
		rec	RECORD;--返回结果集
		order_num int;--满足的优惠档次
BEGIN
select order_column from activity_preferential_relation where activity_message_id = activitymessageid and preferential_value <= money ORDER BY order_column DESC LIMIT 1 into order_num;
raise info '当前存款金额%,满足的优惠档次为:',COALESCE(order_num, 0);
FOR rec IN select T.preferential_form,T.preferential_value,T.preferential_audit from activity_way_relation  t where activity_message_id = activitymessageid  and order_column = COALESCE(order_num, 0)
loop
RETURN NEXT rec;
END loop;
RETURN;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION f_preferential_deposit(integer, numeric)
  OWNER TO postgres;
COMMENT ON FUNCTION f_preferential_deposit(integer, numeric) IS '存款优惠计算入口';


-- Function: f_preferential_message(integer)

DROP FUNCTION if EXISTS f_preferential_message(integer);

CREATE OR REPLACE FUNCTION f_preferential_message(activitymessageid integer)
  RETURNS void AS
$BODY$declare
		sql_apply_text varchar;--查询sql,获取活动的申请玩家
    sql_rule_text varchar;--查询sql,获取当前活动的优惠规则
		sql_order_num_text varchar;--查询sql,获取当前规则满足的最低档次
		sql_way_text varchar;--查询sql,获取玩家满足的优惠结果,包含多种优惠形式
		sql_insert varchar;--生成玩家优惠记录的sql
		rec_apply	RECORD;--优惠申请结果集
		rec_rule record;--优惠规则结果集
		rec_way record;--优惠形式结果集
		order_num_temp int;--计算的优惠档次临时值
		order_num int = 10;--满足的优惠档次
		preferential_value NUMERIC;--优惠规则梯次值
BEGIN
sql_apply_text = 'select  a.id,a.activity_message_id,m.activity_type_code,a.user_id,a.start_time,a.end_time,a.player_recharge_id from activity_player_apply a LEFT OUTER JOIN activity_message m on a.activity_message_id=m.id where activity_message_id =$1';
sql_rule_text = 'select DISTINCT(preferential_code) from activity_preferential_relation where activity_message_id = $1' ;
FOR rec_apply IN EXECUTE sql_apply_text USING activitymessageid
loop
FOR rec_rule in EXECUTE sql_rule_text USING activitymessageid
loop
---亏损
	if rec_rule.preferential_code = 'loss_ge' THEN
	select  f_calculator_profit_loss(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) into preferential_value;
	end if;
--盈利
if rec_rule.preferential_code = 'profit_ge' THEN
	select  f_calculator_profit_loss(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) into preferential_value;
	end if;
--有效交易量(大于等于)
	if rec_rule.preferential_code = 'effective_transaction_ge' THEN
	select  f_calculator_effective_transaction(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) into preferential_value;
	end if;
--总有效交易量
	if rec_rule.preferential_code = 'total_transaction_ge' THEN
	select  f_calculator_effective_transaction(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) into preferential_value;
	end if;
--总资产(小于等于)
	if rec_rule.preferential_code = 'total_assets_le' THEN
	select  f_calculator_total_assets(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) into preferential_value;
	end if;

if rec_rule.preferential_code = 'loss_ge'  THEN
		if preferential_value > 0 then
		order_num = 0;
end if;
end if;

if rec_rule.preferential_code = 'profit_ge'  THEN
		if preferential_value < 0 then
			order_num = 0;
end if;
end if;

if 	order_num !=0 then
	sql_order_num_text = 'select order_column from activity_preferential_relation where activity_message_id = $1 and preferential_code = $2 and preferential_value <= $3 order by order_column desc LIMIT 1';
	EXECUTE sql_order_num_text into order_num_temp USING activitymessageid,rec_rule.preferential_code,preferential_value;
	if COALESCE (order_num_temp, 0) < order_num then
	order_num = order_num_temp;
	end if;
	raise info 'order_num_temp:%',order_num_temp;
end if;
END loop;

if 	order_num !=0 then
sql_way_text = 'select t.* from activity_way_relation t  where activity_message_id = $1 and order_column = $2' ;
FOR rec_way in EXECUTE sql_way_text USING activitymessageid,order_num
loop
if rec_way = 'regular_handsel' then
sql_insert = 'insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit) values('
|| rec_apply.id || ','
|| rec_apply.activity_message_id || ','
|| rec_way.preferential_form || ','
|| rec_way.preferential_value || ','
|| rec_way.preferential_audit || ')';
EXECUTE sql_insert;
end if;
end loop;
end if;

END loop;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION f_preferential_message(integer)
  OWNER TO postgres;
COMMENT ON FUNCTION f_preferential_message(integer) IS '优惠活动计算入口';


-- Function: f_preferential_player(integer, integer)

DROP FUNCTION if EXISTS f_preferential_player(integer, integer);

CREATE OR REPLACE FUNCTION f_preferential_player(activitymessageid integer, playerid integer)
  RETURNS void AS
$BODY$
declare
		activityType VARCHAR;--活动类型
		rec	RECORD;--返回结果集
		applyId int;--玩家申请id
		rechargeId int;--存款订单的id
		depositAccount NUMERIC;--存款金额
		preferentialId int;--玩家优惠id
BEGIN

select activity_type_code from activity_message where id = activitymessageid into activityType;
raise info '活动类型为:%,启动优惠计算过程',activityType;

select id,player_recharge_id from activity_player_apply where activity_message_id = activitymessageid and user_id=playerid into applyId,rechargeId;

select * from activity_player_preferential where activity_player_apply_id = applyId into preferentialId;
if COALESCE(preferentialId, 0) != 0 THEN
raise info '该玩家申请已计算完优惠,无须重复计算';
return;
end if;

if activityType='regist_send' THEN
for rec in select * from f_preferential_regist(activitymessageid,playerid) as activity_way_relation(preferential_form varchar,preferential_value numeric(20,2),preferential_audit numeric(20,2))
loop
 insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit)
values (applyId,activitymessageid,rec.preferential_form,rec.preferential_value,rec.preferential_audit);
end loop;
	ELSEIF activityType='first_deposit' or activityType='deposit_send' THEN
	select recharge_amount from player_recharge where id=rechargeId into depositAccount;
	raise info '存款订单id为:%,存款金额为:%',rechargeId,depositAccount;

for rec in select * from   f_preferential_deposit(activitymessageid,depositAccount) as activity_way_relation(preferential_form varchar,preferential_value numeric(20,2),preferential_audit numeric(20,2))
loop

	if rec.preferential_form = 'regular_handsel' THEN
raise info '当前优惠方式为固定彩金,优惠金额为:%',rec.preferential_value;
 insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit)
values (applyId,activitymessageid,rec.preferential_form,rec.preferential_value,rec.preferential_audit);
ELSEIF rec.preferential_form = 'percentage_handsel' THEN
raise info '当前优惠方式为比例彩金,优惠金额为:%',rec.preferential_value*depositAccount;
insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit)
values (applyId,activitymessageid,rec.preferential_form,rec.preferential_value*depositAccount,rec.preferential_audit);
end if;

end loop;
end if;


END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION f_preferential_player(integer, integer)
  OWNER TO postgres;
COMMENT ON FUNCTION f_preferential_player(integer, integer) IS '玩家优惠计算统一入口';


-- Function: f_preferential_regist(integer, integer)

DROP FUNCTION if EXISTS f_preferential_regist(integer, integer);

CREATE OR REPLACE FUNCTION f_preferential_regist(activitymessageid integer, playerid integer)
  RETURNS SETOF record AS
$BODY$
declare
		rec	RECORD;--返回结果集
		startTime TIMESTAMP;--活动开始时间
		status  VARCHAR;--活动审核状态
--		effectiveTime TIMESTAMP;--有效时间

BEGIN

select start_time,check_status from activity_message where id = activitymessageid into startTime,status;
raise info '活动开始时间为:%,当前审核状态为:%',startTime,status;
if status != '1' THEN
raise info '活动id:%,未审核通过,不满足计算条件,立即结束计算.',activitymessageid;
return;
end if;
raise info '该活动已审核通过,开始计算优惠结果.';
--select effective_time from activity_rule where activity_message_id=activitymessageid into effectiveTime;
--raise info '活动的有效时间为:%',effectiveTime;
--select * from activity_player_apply where activity_message_id = activitymessageid and user_id = playerid;
FOR rec IN select T.preferential_form,T.preferential_value,T.preferential_audit from activity_way_relation  t where activity_message_id = activitymessageid
loop
RETURN NEXT rec;
END loop;
RETURN;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION f_preferential_regist(integer, integer)
  OWNER TO postgres;
COMMENT ON FUNCTION f_preferential_regist(integer, integer) IS '注册送优惠计算';
