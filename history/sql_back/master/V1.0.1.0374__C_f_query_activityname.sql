-- auto gen by cherry 2016-02-02 17:11:46
CREATE OR REPLACE FUNCTION "f_query_activityname"(activitymessageid int4)

  RETURNS "pg_catalog"."text" AS $BODY$ DECLARE



	rec_activity RECORD;--活动国际化结果集

	activityname_json VARCHAR := '' ;--活动名称，所有语言版本的名称都需要存储



BEGIN



FOR rec_activity IN SELECT * FROM activity_message_i18n WHERE activity_message_id=activitymessageid

LOOP

	activityname_json = activityname_json || '"' ||rec_activity.activity_version||'":"'||rec_activity.activity_name||'",';

END LOOP;



IF length(activityname_json) > 0 THEN

	activityname_json = substring(activityname_json,  1 , length(activityname_json)-1);

	activityname_json = '{' || activityname_json  || '}';

END IF;

RETURN activityname_json;

END $BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;

COMMENT ON FUNCTION  "f_query_activityname"(activitymessageid int4) IS '查询活动名称，包含所有语言版本';

DROP FUNCTION IF EXISTS f_preferential_regist(activitymessageid int4, playerid int4, sitecode varchar);

CREATE OR REPLACE FUNCTION  "f_preferential_regist"(activitymessageid int4, playerid int4, sitecode varchar)

  RETURNS SETOF "pg_catalog"."void" AS $BODY$



declare



		rec	RECORD;--返回结果集



		startTime TIMESTAMP;--活动开始时间



		endTime TIMESTAMP;--活动结束时间



		status  VARCHAR;--活动审核状态



		activityType VARCHAR;--活动类型



		registTime TIMESTAMP;--玩家注册时间



    effectiveTime VARCHAR;--有效时间



		activityEffectiveTime TIMESTAMP;--活动有效时间=玩家注册时间+有效时间



		type_regist_send VARCHAR := 'regist_send';--注册送的activity_type



		activity_status_success VARCHAR := '1';--活动审核通过状态值



    preferential_form_percentage varchar := 'percentage_handsel';--优惠形式:比例彩金



		preferential_form_regular varchar := 'regular_handsel';--优惠形式:固定彩金



		activityname_json VARCHAR := '' ;--活动名称，所有语言版本的名称都需要存储





	  isaudit BOOLEAN;--活动是否需要审核



		orderNo VARCHAR;--订单号



		applyId INT;--玩家的优惠申请id



    favorable_id_temp int;--优惠记录主键



		transaction_id_temp int;--订单记录主键



		isAuditFavorable BOOLEAN := TRUE;--是否优惠稽核



    auditPoints NUMERIC ;--稽核点







BEGIN



SELECT * from f_query_activityname(activitymessageid) INTO activityname_json;



raise info '活动名称的JSON：%',activityname_json;





SELECT start_time,end_time,check_status,activity_type_code FROM activity_message WHERE id = activitymessageid INTO startTime,endTime,status,activityType;



raise info '活动开始时间为:%,结束时间为:%,当前审核状态为:%,活动类型为：%',startTime,endTime,status,activityType;







IF status != activity_status_success THEN



raise info '活动:%,未审核通过,立即结束计算.',activitymessageid;



RETURN;



END IF;







IF activityType != type_regist_send THEN



raise info '活动:%,不是注册送活动,立即结束计算.',activitymessageid;



RETURN;



END IF;







IF startTime > CURRENT_TIMESTAMP THEN



raise info '活动:%未开始,立即结束计算.',activitymessageid;



RETURN;



END IF;







IF endTime < CURRENT_TIMESTAMP THEN



raise info '活动:%已结束,立即结束计算.',activitymessageid;



RETURN;



END IF;







SELECT create_time FROM sys_user WHERE id=playerid INTO registTime;







SELECT



	CASE



WHEN (effective_time = 'OneDay') THEN '1'



WHEN (effective_time = 'TwoDays') THEN '2'



WHEN (effective_time = 'ThreeDays') THEN '3'



WHEN (effective_time = 'SevenDays') THEN '7'



WHEN (effective_time = 'ThirtyDays') THEN '30'



ELSE '0'



END AS effective_time FROM activity_rule WHERE activity_message_id = activitymessageid INTO effectiveTime;







raise info '玩家:%,的注册时间为：%,活动：%,的有效时间为：%.',playerid,registTime,activitymessageid,effectiveTime;







SELECT registTime + (effectiveTime || ' day')::interval  INTO activityEffectiveTime;







IF activityEffectiveTime < CURRENT_TIMESTAMP THEN



raise info '该玩家的有效申请日期已过期,立即结束计算.';



RETURN;



END IF;







IF NOT EXISTS(SELECT * FROM activity_player_apply WHERE user_id = playerid AND activity_message_id = activitymessageid AND check_state = '0') THEN



raise info '该玩家未申请奖励,立即结束计算.';



RETURN;



END IF;







IF EXISTS(SELECT * FROM activity_player_apply WHERE user_id = playerid AND activity_message_id = activitymessageid AND check_state = '2') THEN



raise info '该玩家已获得本活动奖励,不再重复计算,立即结束计算.';



RETURN;



END IF;







raise info '开始计算玩家：%能获得的注册送奖励：',playerid;







--每个注册送活动每个人只能申请一次,玩家优惠申请信息的状态: 0待确认１待处理２成功３失败



SELECT id FROM activity_player_apply WHERE user_id = playerid AND activity_message_id = activitymessageid AND check_state = '0' INTO applyId;







SELECT is_audit FROM activity_rule  where activity_message_id = activitymessageid INTO isaudit;



raise info '该活动的优惠是否需要审核状态为:%',isaudit;







FOR rec IN SELECT T.preferential_form,T.preferential_value,T.preferential_audit FROM activity_way_relation  t WHERE activity_message_id = activitymessageid



loop







--生成玩家优惠记录



	IF rec.preferential_form = preferential_form_regular then



	insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit)



	values(applyId,activitymessageid,rec.preferential_form,rec.preferential_value,rec.preferential_audit);



	END IF;







	IF isaudit THEN



		--该活动需要站长审核，更新审核状态为待处理



		UPDATE activity_player_apply set check_state = '1' where id = applyId;



	ELSE



		--该活动无需站长审核，直接生成优惠记录和交易订单，同时更新玩家钱包余额



		orderNo := (SELECT f_order_no(sitecode, '02'));



		UPDATE activity_player_apply set check_state = '2' where id = applyId;







		IF rec.preferential_audit = NULL THEN



			isAuditFavorable = FALSE;



		ELSE



		auditPoints = rec.preferential_value*rec.preferential_audit;



		END IF;







		WITH favorable AS (



			-- 新增优惠记录数据



			INSERT INTO player_favorable



			(favorable, favorable_remark, is_audit_favorable, audit_favorable_multiple, activity_message_id, transaction_no, favorable_source)



								VALUES



			(rec.preferential_value,'注册赠送彩金', isAuditFavorable, rec.preferential_audit, activitymessageid, orderNo, 'activity_favorable')



								RETURNING id)



		SELECT id from favorable into favorable_id_temp;







		WITH playtransaction AS (



			INSERT INTO player_transaction



			(transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data)



						VALUES



			(orderNo, now(), 'favorable', '注册赠送彩金', rec.preferential_value,



			rec.preferential_value + COALESCE((SELECT wallet_balance FROM user_player WHERE id = playerid),0), 'success',playerid, favorable_id_temp, auditPoints, false, false, 'favourable', activityType, activityname_json)



								RETURNING id)



		SELECT id from playtransaction into transaction_id_temp;







		UPDATE player_favorable set player_transaction_id = transaction_id_temp where id = favorable_id_temp;







		-- 修改玩家余额



		UPDATE user_player SET wallet_balance = COALESCE(wallet_balance,0) + rec.preferential_value WHERE id = playerid;







	END IF;



END loop;



RETURN;



END



$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

 ROWS 1000

;

COMMENT ON FUNCTION "f_preferential_regist"(activitymessageid int4, playerid int4, sitecode varchar) IS '注册送优惠计算';


DROP FUNCTION IF EXISTS f_preferential_message(activitymessageid int4, sitecode varchar);


CREATE OR REPLACE FUNCTION "f_preferential_message"(activitymessageid int4, sitecode varchar)

  RETURNS "pg_catalog"."void" AS $BODY$declare





		rec_apply	RECORD;--优惠申请结果集



		rec_preferential_code record;--优惠代码结果集



		rec_way record;--优惠形式结果集







    startTime TIMESTAMP;--活动开始时间



		endTime TIMESTAMP;--活动结束时间



		status  VARCHAR;--活动审核状态



		activitytype VARCHAR;--活动类型



		preferentialCode VARCHAR;--优惠规则代码



    activityname_json VARCHAR := '' ;--活动名称，所有语言版本的名称都需要存储







		order_num_temp int;--计算的优惠档次临时值



		order_num int = 10;--满足的优惠档次



		preferential_value_temp NUMERIC;--优惠规则梯次值



		isaudit BOOLEAN;--活动是否需要审核



		orderNo VARCHAR;



		favorable_id_temp int;--优惠记录主键



		transaction_id_temp int;--订单记录主键



    isAuditFavorable BOOLEAN := TRUE;--是否优惠稽核



    auditPoints NUMERIC ;--稽核点







    activity_status_success VARCHAR := '1';--活动审核通过状态值



		type_relief_fund VARCHAR := 'relief_fund';--救济金的activity_type



		type_effective_transaction VARCHAR := 'effective_transaction';--有效交易量的activity_type



		type_profit_loss VARCHAR := 'profit_loss';--盈亏送的activity_type







		rule_loss_ge varchar := 'loss_ge';--优惠规则：亏损



		rule_profit_ge varchar := 'profit_ge';--优惠规则：盈利



		rule_effective_transaction_ge varchar := 'effective_transaction_ge';--优惠规则：有效交易量



		rule_total_transaction_ge varchar := 'total_transaction_ge';--优惠规则：总有效交易量



		rule_total_assets_le varchar := 'total_assets_le';--优惠规则：总资产(小于等于)







		preferential_form_percentage varchar := 'percentage_handsel';--优惠形式:比例彩金



		preferential_form_regular varchar := 'regular_handsel';--优惠形式:固定彩金







BEGIN







SELECT start_time,end_time,check_status,activity_type_code FROM activity_message WHERE id = activitymessageid INTO startTime,endTime,status,activitytype;



raise info '活动开始时间为:%,结束时间为:%,当前审核状态为:%,活动类型为：%',startTime,endTime,status,activitytype;







IF status != activity_status_success THEN



raise info '活动:%,未审核通过,立即结束计算.',activitymessageid;



RETURN;



END IF;







IF startTime > CURRENT_TIMESTAMP THEN



raise info '活动:%未开始,立即结束计算.',activitymessageid;



RETURN;



END IF;







IF endTime < CURRENT_TIMESTAMP THEN



raise info '活动:%已结束,立即结束计算.',activitymessageid;



RETURN;



END IF;







SELECT is_audit FROM activity_rule WHERE activity_message_id = activitymessageid INTO isaudit;



SELECT * from f_query_activityname(activitymessageid) INTO activityname_json;



raise info '活动名称的JSON：%',activityname_json;



--获取该活动的所有申请玩家



FOR rec_apply IN (SELECT * FROM activity_player_apply WHERE activity_message_id = activitymessageid AND check_state = '0')



loop



	raise info '开始计算玩家:%能获得的优惠',rec_apply.user_id;



	--获取当前活动的优惠规则



	FOR rec_preferential_code in SELECT DISTINCT(preferential_code) FROM activity_preferential_relation WHERE activity_message_id = activitymessageid



	loop



		--亏损



		IF rec_preferential_code.preferential_code = rule_loss_ge THEN



			SELECT  f_calculator_profit_loss(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) INTO preferential_value_temp;



			raise notice '查询玩家盈利亏损情况,结果:%',preferential_value_temp;



		END IF;



		--盈利



		IF rec_preferential_code.preferential_code = rule_profit_ge THEN



			SELECT  f_calculator_profit_loss(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) INTO preferential_value_temp;



			raise notice '查询玩家盈利亏损情况,结果:%',preferential_value_temp;



		END IF;



		--有效交易量(大于等于)



		IF rec_preferential_code.preferential_code = rule_effective_transaction_ge THEN



			SELECT  f_calculator_effective_transaction(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) INTO preferential_value_temp;



			raise notice '查询玩家的有效交易量,结果:%',preferential_value_temp;



		END IF;



		--总有效交易量



		IF rec_preferential_code.preferential_code = rule_total_transaction_ge THEN



			SELECT  f_calculator_effective_transaction(rec_apply.user_id,rec_apply.register_time,rec_apply.apply_time) INTO preferential_value_temp;



			raise notice '查询玩家的总有效交易量,结果:%',preferential_value_temp;



		END IF;



		--总资产(小于等于)



		IF rec_preferential_code.preferential_code = rule_total_assets_le THEN



			SELECT  f_calculator_total_assets(rec_apply.user_id) into preferential_value_temp;



			raise notice '查询玩家的总资产,结果:%',preferential_value_temp;



		END IF;







		--盈亏送活动 亏损与盈利规则为或的关系



		IF activitytype = type_profit_loss THEN



			IF rec_preferential_code.preferential_code = rule_loss_ge AND preferential_value_temp >0 THEN



				raise info '该玩家当前盈利,不能获得亏损优惠';



				CONTINUE;



			END IF;







			IF rec_preferential_code.preferential_code = rule_profit_ge AND preferential_value_temp <0 THEN



				raise info '该玩家当前亏损,不能获得盈利优惠';



				CONTINUE;



			END IF;



		END IF;







		IF rec_preferential_code.preferential_code = rule_loss_ge AND preferential_value_temp > 0 THEN



			order_num = 0;



			raise info '计算玩家亏损情况:该玩家当前盈利，不能获得该优惠';



		END IF;







		IF rec_preferential_code.preferential_code = rule_profit_ge AND preferential_value_temp < 0   THEN



			order_num = 0;



			raise info '计算玩家盈利情况:该玩家当前亏损，不能获得该优惠';



		END IF;







		IF rec_preferential_code.preferential_code = rule_total_assets_le THEN



			SELECT order_column FROM activity_preferential_relation WHERE activity_message_id = activitymessageid and preferential_code = rec_preferential_code.preferential_code and preferential_value >= preferential_value_temp order by order_column desc LIMIT 1 into order_num_temp;



			IF COALESCE (order_num_temp, 0) < order_num then



				order_num = order_num_temp;



			END IF;



		ELSE



			--负数需要取绝对值后计算当前规则满足的优惠档次



			IF preferential_value_temp <0 THEN



				preferential_value_temp = abs(preferential_value_temp);



			END if;







			SELECT order_column FROM activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = rec_preferential_code.preferential_code AND preferential_value <= preferential_value_temp order by order_column desc LIMIT 1 into order_num_temp;



			IF COALESCE (order_num_temp, 0) < order_num THEN



				order_num = order_num_temp;



			END IF;







		END IF;



	END loop;







	IF 	order_num !=0 THEN



  raise info '玩家:%获得的优惠档次为:%',rec_apply.user_id,order_num;



	FOR rec_way in SELECT * FROM activity_way_relation WHERE activity_message_id = activitymessageid AND order_column = order_num



	loop



	  --盈亏送活动 亏损与盈利规则为或的关系



		SELECT preferential_code FROM activity_preferential_relation WHERE id = rec_way.activity_rule_id INTO preferentialCode;



		IF activitytype = type_profit_loss AND preferentialCode <> rec_preferential_code.preferential_code THEN



			CONTINUE;



		END IF;







		--生成玩家优惠记录



		IF rec_way.preferential_form = preferential_form_regular THEN



			insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit) values(



			rec_apply.id,



			rec_apply.activity_message_id,



			rec_way.preferential_form,



			rec_way.preferential_value,



			rec_way.preferential_audit);



		END IF;







		IF isaudit THEN



			raise info '当前活动优惠需要提交站长进行审核.';



			--更新玩家优惠申请信息的状态１待处理２成功３失败



			UPDATE activity_player_apply set check_state = '1' WHERE id = rec_apply.id;



		ELSE



			raise info '当前活动优惠不需要提交站长进行审核.';



			orderNo := (SELECT f_order_no(siteCode, '02'));



      IF rec_way.preferential_audit = NULL THEN



				isAuditFavorable = FALSE;



			ELSE



				auditPoints = rec_way.preferential_value*rec_way.preferential_audit;



			END IF;



			--更新玩家优惠申请信息为成功



			UPDATE activity_player_apply set check_state = '2' WHERE id = rec_apply.id;



			--自动生成优惠记录



			WITH favorable AS (



				INSERT INTO player_favorable



				(favorable, favorable_remark, is_audit_favorable, audit_favorable_multiple, activity_message_id, transaction_no, favorable_source) VALUES



				(rec_way.preferential_value,'系统自动计算玩家优惠', isAuditFavorable, rec_way.preferential_audit, activitymessageid, orderNo, 'activity_favorable')



				RETURNING id



			)



			SELECT id FROM favorable INTO favorable_id_temp;



			--自动生成交易订单



			WITH playtransaction AS (



				INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data) VALUES



				(orderNo, now(), 'favorable', '系统自动计算玩家优惠', rec_way.preferential_value, rec_way.preferential_value + (SELECT wallet_balance FROM user_player WHERE id = rec_apply.user_id), 'success',rec_apply.user_id, favorable_id_temp, auditPoints, false, false, 'favourable', activitytype, activityname_json)



				RETURNING id



			)



			SELECT id FROM playtransaction INTO transaction_id_temp;



			--更新玩家优惠记录



			UPDATE player_favorable set player_transaction_id = transaction_id_temp WHERE id = favorable_id_temp;



			-- 修改玩家余额



			UPDATE user_player SET wallet_balance = COALESCE(wallet_balance,0) + rec_way.preferential_value WHERE id = rec_apply.user_id;



		END IF;







	END loop;



	END IF;







END loop;



END







$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;


COMMENT ON FUNCTION "f_preferential_message"(activitymessageid int4, sitecode varchar) IS '周期性优惠活动计算入口';


CREATE TABLE IF NOT EXISTS  "rakeback_api_base" (

"id"  SERIAL4 NOT NULL,

"top_agent_id" int4,

"agent_id" int4,

"player_id" int4,

"api_id" int4,

"api_type_id" int4,

"game_type" varchar(32) COLLATE "default",

"effective_transaction" numeric(20,2),

"profit_loss" numeric(20,2),

"rakeback" numeric(20,2),

"rakeback_time" timestamp(6),

CONSTRAINT "rakeback_api_base_pkey" PRIMARY KEY ("id")

)

WITH (OIDS=FALSE)

;

COMMENT ON TABLE  "rakeback_api_base" IS 'API返水基础表--susu';

COMMENT ON COLUMN  "rakeback_api_base"."id" IS '主键';

COMMENT ON COLUMN  "rakeback_api_base"."top_agent_id" IS '总代ID';

COMMENT ON COLUMN  "rakeback_api_base"."agent_id" IS '代理ID';

COMMENT ON COLUMN  "rakeback_api_base"."player_id" IS '玩家ID';

COMMENT ON COLUMN  "rakeback_api_base"."api_id" IS 'API表id';

COMMENT ON COLUMN "rakeback_api_base"."api_type_id" IS 'api分类';

COMMENT ON COLUMN "rakeback_api_base"."game_type" IS '二级游戏类别:game.game_type';

COMMENT ON COLUMN "rakeback_api_base"."effective_transaction" IS '有效交易量';

COMMENT ON COLUMN "rakeback_api_base"."profit_loss" IS '盈亏';

COMMENT ON COLUMN "rakeback_api_base"."rakeback" IS '贡献返水';

COMMENT ON COLUMN "rakeback_api_base"."rakeback_time" IS '返水日期';

DROP INDEX IF EXISTS fk_rakeback_api_base_agent_id;
CREATE INDEX "fk_rakeback_api_base_agent_id" ON "rakeback_api_base" USING btree (agent_id);

DROP INDEX IF EXISTS fk_rakeback_api_base_api_id;
CREATE INDEX "fk_rakeback_api_base_api_id" ON "rakeback_api_base" USING btree (api_id);

DROP INDEX IF EXISTS fk_rakeback_api_base_api_type_id;
CREATE INDEX "fk_rakeback_api_base_api_type_id" ON "rakeback_api_base" USING btree (api_type_id);

DROP INDEX IF EXISTS fk_rakeback_api_base_player_id;
CREATE INDEX "fk_rakeback_api_base_player_id" ON "rakeback_api_base" USING btree (player_id);

DROP INDEX IF EXISTS fk_rakeback_api_base_top_agent_id;
CREATE INDEX "fk_rakeback_api_base_top_agent_id" ON  "rakeback_api_base" USING btree (top_agent_id);