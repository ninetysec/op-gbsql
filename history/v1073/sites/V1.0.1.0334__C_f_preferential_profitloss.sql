-- auto gen by cherry 2016-11-28 20:44:23
DROP FUNCTION IF EXISTS f_preferential_profitloss(activitymessageid int4, sitecode varchar);

--优惠交易记录新增层级id、终端标志
CREATE OR REPLACE FUNCTION "f_preferential_profitloss"(activitymessageid int4, sitecode varchar)
  RETURNS "pg_catalog"."void" AS $BODY$

declare
    rec_apply           RECORD;     -- 优惠申请结果集
    rec_way             record;     -- 优惠形式结果集
    preferentialCode    VARCHAR;    -- 优惠规则代码
    activityname_json   VARCHAR := ''; -- 活动名称，所有语言版本的名称都需要存储
    order_num           int;        -- 满足的优惠档次
    preferential_value_temp NUMERIC;-- 优惠规则梯次值
    isaudit             BOOLEAN;    -- 活动是否需要审核
    orderNo             VARCHAR;
    favorable_id_temp   int;        -- 优惠记录主键
    transaction_id_temp int;        -- 订单记录主键
    isAuditFavorable    BOOLEAN := TRUE;    -- 是否优惠稽核
    auditPoints         NUMERIC;    -- 稽核点
    type_profit_loss    VARCHAR := 'profit_loss';   -- 盈亏送的activity_type
    rule_loss_ge        varchar := 'loss_ge';   -- 优惠规则：亏损
    rule_profit_ge      varchar := 'profit_ge'; -- 优惠规则：盈利
    preferential_form_regular varchar := 'regular_handsel'; -- 优惠形式:固定彩金

BEGIN
    -- 获取活动基本信息：需要站长审核状态，活动国际化名称
    SELECT is_audit FROM activity_rule WHERE activity_message_id = activitymessageid INTO isaudit;
    SELECT * from f_message_query_activityname(activitymessageid) INTO activityname_json;
    raise info '活动是否需要审核:%, 活动名称的JSON:%', isaudit, activityname_json;

    -- 获取该活动的所有申请玩家
    FOR rec_apply IN (SELECT * FROM activity_player_apply WHERE activity_message_id = activitymessageid AND check_state = '0' AND end_time <= CURRENT_TIMESTAMP)
    LOOP
    	-- 计算玩家该申领周期内的盈利亏损情况
    	SELECT f_calculator_profit_loss(rec_apply.user_id, rec_apply.start_time, rec_apply.end_time) INTO preferential_value_temp;
    	raise notice '查询玩家盈利亏损情况,结果:%',preferential_value_temp;

    	-- 负数需要取绝对值后计算当前规则满足的优惠档次
    	IF preferential_value_temp < 0 THEN
    		preferentialCode = rule_loss_ge;
    		preferential_value_temp = abs(preferential_value_temp);
    	ELSE
    		preferentialCode = rule_profit_ge;
    	END if;

    	-- 计算玩家能获取的优惠奖励档次
    	SELECT order_column
          FROM activity_preferential_relation
         WHERE activity_message_id = activitymessageid
           AND preferential_code = preferentialCode
           AND preferential_value <= preferential_value_temp
         ORDER BY order_column DESC
         LIMIT 1 into order_num;

    	order_num = COALESCE (order_num, 0);

    	-- 满足任意档次，则生成相应的优惠信息
    	IF 	order_num != 0 THEN
    		raise info '开始计算玩家:%能获得的优惠，获得的优惠档次为:%', rec_apply.user_id, order_num;

    		-- 获取所有的优惠形式，目前只支持固定彩金，如有其他形式，需要考虑相应的业务逻辑
    		FOR rec_way in SELECT t.* FROM activity_way_relation t LEFT JOIN activity_preferential_relation M ON t.activity_rule_id = M.id WHERE t.activity_message_id = activitymessageid AND m.preferential_code = preferentialCode AND t.order_column=order_num
    		LOOP
    			-- 生成玩家活动优惠记录
    			IF rec_way.preferential_form = preferential_form_regular THEN
    				INSERT INTO activity_player_preferential(
                        activity_player_apply_id,
                        activity_message_id,
                        preferential_form,
                        preferential_value,
                        preferential_audit
                    ) values (
        				rec_apply.id,
        				rec_apply.activity_message_id,
        				rec_way.preferential_form,
        				rec_way.preferential_value,
        				rec_way.preferential_audit
                    );
    			END IF;

    			-- 根据是否提交站长审核进行不同的处理
    			IF isaudit THEN
    				--更新玩家优惠申请信息的状态１待处理２成功３失败
    				UPDATE activity_player_apply set check_state = '1' WHERE id = rec_apply.id;
    			ELSE
    				--生成订单号
    				orderNo := (SELECT f_order_no(siteCode, '02'));
            			--赠送奖励是否设置了稽核
    				IF rec_way.preferential_audit = NULL THEN
    					isAuditFavorable = FALSE;
    				ELSE
    					auditPoints = rec_way.preferential_value * rec_way.preferential_audit;
    				END IF;
    				--更新玩家优惠申请信息为成功
    				UPDATE activity_player_apply set check_state = '2' WHERE id = rec_apply.id;
    				--自动生成优惠记录
    				WITH favorable AS (
    					INSERT INTO player_favorable (
                            favorable,
                            favorable_remark,
                            is_audit_favorable,
                            audit_favorable_multiple,
                            activity_message_id,
                            transaction_no,
                            favorable_source
                        ) VALUES (
                            rec_way.preferential_value,
                            '系统自动计算玩家参与优惠活动【盈亏送】',
                            isAuditFavorable,
                            rec_way.preferential_audit,
                            activitymessageid,
                            orderNo,
                            'activity_favorable'
                        )
    					RETURNING id
    				)
    				SELECT id FROM favorable INTO favorable_id_temp;
    				-- 自动生成交易订单
    				WITH playtransaction AS (
    					INSERT INTO player_transaction (
                            transaction_no,
                            create_time,
                            transaction_type,
                            remark,
                            transaction_money,
                            balance,
                            status,
                            player_id,
                            source_id,
                            favorable_audit_points,
                            is_satisfy_audit,
                            is_clear_audit,
                            fund_type,
                            transaction_way,
                            transaction_data,
														origin,
														rank_id
                        ) VALUES (
                            orderNo,
                            now(),
                            'favorable',
                            '系统自动计算玩家参与优惠活动【盈亏送】',
                            rec_way.preferential_value,
                            rec_way.preferential_value + (SELECT wallet_balance FROM user_player WHERE id = rec_apply.user_id),
                            'success',
                            rec_apply.user_id,
                            favorable_id_temp,
                            auditPoints,
                            false,
                            false,
                            'favourable',
                            type_profit_loss,
                            activityname_json,
														'PC',
														(SELECT rank_id FROM user_player WHERE id = rec_apply.user_id)
                        )
    					RETURNING id
    				)
    				SELECT id FROM playtransaction INTO transaction_id_temp;
    				-- 更新玩家优惠记录
    				UPDATE player_favorable set player_transaction_id = transaction_id_temp WHERE id = favorable_id_temp;
    				--  修改玩家余额
    				UPDATE user_player SET wallet_balance = COALESCE(wallet_balance,0) + rec_way.preferential_value WHERE id = rec_apply.user_id;
    			END IF;
    		END loop;
        ELSE
            UPDATE activity_player_apply SET check_state = '4' WHERE id = rec_apply.id;
    	END IF;
    END loop;
END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_preferential_profitloss"(activitymessageid int4, sitecode varchar) IS '盈亏送活动计算';


DROP FUNCTION IF EXISTS f_preferential_effecttransaction(activitymessageid int4, sitecode varchar);

--有效交易量优惠记录新增层级id、终端
CREATE OR REPLACE FUNCTION "f_preferential_effecttransaction"(activitymessageid int4, sitecode varchar)
  RETURNS "pg_catalog"."void" AS $BODY$

declare
	rec_apply			RECORD;		-- 优惠申请结果集
	rec_way 			record;		-- 优惠形式结果集
	activityname_json 	VARCHAR:= '';	-- 活动名称，所有语言版本的名称都需要存储
	order_num 			int;		-- 满足的优惠档次
	preferential_value_temp NUMERIC;-- 优惠规则梯次值
	isaudit 			BOOLEAN;	-- 活动是否需要审核
	orderNo 			VARCHAR;
	favorable_id_temp 	int;		-- 优惠记录主键
	transaction_id_temp int;		-- 订单记录主键
	isAuditFavorable 	BOOLEAN:=TRUE;	-- 是否优惠稽核
	auditPoints 		NUMERIC;	-- 稽核点
	preferential_form_regular 	varchar:='regular_handsel';			-- 优惠形式:固定彩金
	type_effective_transaction 	VARCHAR:='effective_transaction';	-- 有效交易量的activity_type
	rule_total_transaction_ge 	varchar:='total_transaction_ge';	-- 优惠规则：总有效交易量

BEGIN
	-- 获取活动基本信息：需要站长审核状态，活动国际化名称
	SELECT is_audit FROM activity_rule WHERE activity_message_id = activitymessageid INTO isaudit;
	SELECT * from f_message_query_activityname(activitymessageid) INTO activityname_json;
	raise info '活动是否需要审核:%, 活动名称的JSON:%', isaudit, activityname_json;

	-- 获取该活动当前需要结算的所有申请玩家
	FOR rec_apply IN (SELECT * FROM activity_player_apply WHERE activity_message_id = activitymessageid AND check_state = '0' AND end_time <= CURRENT_TIMESTAMP)
	LOOP
		-- 计算玩家该申领周期内的总有效交易量
		SELECT f_calculator_effective_transaction(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) INTO preferential_value_temp;
		raise notice '查询玩家的总有效交易量, 结果:%', preferential_value_temp;

		-- 计算玩家能获取的优惠奖励档次
		SELECT order_column
		  FROM activity_preferential_relation
		 WHERE activity_message_id = activitymessageid
		   AND preferential_code = rule_total_transaction_ge
		   AND preferential_value <= preferential_value_temp
		 ORDER BY order_column DESC
		 LIMIT 1 INTO order_num;

		order_num = COALESCE(order_num, 0);

		-- 满足任意档次，则生成相应的优惠信息
		IF 	order_num != 0 THEN
			raise info '开始计算玩家:%能获得的优惠， 获得的优惠档次为:%', rec_apply.user_id, order_num;

			-- 获取该优惠档次所有的优惠形式，目前只支持固定彩金，如有其他形式，需要考虑相应的业务逻辑
			FOR rec_way in SELECT * FROM activity_way_relation WHERE activity_message_id = activitymessageid AND order_column = order_num
			LOOP
				-- 生成玩家活动优惠记录
				IF rec_way.preferential_form = preferential_form_regular THEN
					INSERT INTO activity_player_preferential(
						activity_player_apply_id,
						activity_message_id,
						preferential_form,
						preferential_value,
						preferential_audit
					) VALUES (
						rec_apply.id,
						rec_apply.activity_message_id,
						rec_way.preferential_form,
						rec_way.preferential_value,
						rec_way.preferential_audit
					);
				END IF;

				-- 根据是否提交站长审核进行不同的处理
				IF isaudit THEN
					-- 更新玩家优惠申请信息的状态: １-待处理, ２-成功, ３-失败
					UPDATE activity_player_apply set check_state = '1' WHERE id = rec_apply.id;
				ELSE
					-- 生成订单号
					orderNo := (SELECT f_order_no(siteCode, '02'));
					-- 赠送奖励是否设置了稽核
					IF rec_way.preferential_audit = NULL THEN
						isAuditFavorable = FALSE;
					ELSE
						auditPoints = rec_way.preferential_value * rec_way.preferential_audit;
					END IF;

					-- 更新玩家优惠申请信息为成功
					UPDATE activity_player_apply set check_state = '2' WHERE id = rec_apply.id;

					-- 自动生成优惠记录
					WITH favorable AS (
						INSERT INTO player_favorable(
							favorable,
							favorable_remark,
							is_audit_favorable,
							audit_favorable_multiple,
							activity_message_id,
							transaction_no,
							favorable_source
						) VALUES (
							rec_way.preferential_value,
							'系统自动计算玩家参与优惠活动【有效交易量】',
							isAuditFavorable,
							rec_way.preferential_audit,
							activitymessageid,
							orderNo,
							'activity_favorable'
						)
						RETURNING id
					)
					SELECT id FROM favorable INTO favorable_id_temp;

					-- 自动生成交易订单
					WITH playtransaction AS (
						INSERT INTO player_transaction(
							transaction_no,
							create_time,
							transaction_type,
							remark,
							transaction_money,
							balance,
							status,
							player_id,
							source_id,
							favorable_audit_points,
							is_satisfy_audit,
							is_clear_audit,
							fund_type,
							transaction_way,
							transaction_data,
							origin,
							rank_id
						) VALUES (
							orderNo,
							now(),
							'favorable',
							'系统自动计算玩家参与优惠活动【有效交易量】',
							rec_way.preferential_value,
							rec_way.preferential_value + (SELECT wallet_balance FROM user_player WHERE id = rec_apply.user_id), 'success',rec_apply.user_id,
							favorable_id_temp,
							auditPoints,
							false,
							false,
							'favourable',
							type_effective_transaction,
							activityname_json,
							'PC',
							(SELECT rank_id FROM user_player WHERE id = rec_apply.user_id)
						)
						RETURNING id
					)
					SELECT id FROM playtransaction INTO transaction_id_temp;

					-- 更新玩家优惠记录
					UPDATE player_favorable set player_transaction_id = transaction_id_temp WHERE id = favorable_id_temp;

					-- 修改玩家余额
					UPDATE user_player SET wallet_balance = COALESCE(wallet_balance,0) + rec_way.preferential_value WHERE id = rec_apply.user_id;

				END IF;
			END loop;
		ELSE	-- 不满足条件，更新申请状态
			UPDATE activity_player_apply SET check_state = '4' WHERE id = rec_apply.id;
		END IF;
	END loop;
END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_preferential_effecttransaction"(activitymessageid int4, sitecode varchar) IS '有效交易量活动计算';

DROP FUNCTION IF EXISTS "f_message_calculator"(activitymessage json, playerinfo json, applyresult json);

--申请优惠注册送和救济金优惠交易记录新增层级、终端标志
CREATE OR REPLACE FUNCTION "f_message_calculator"(activitymessage json, playerinfo json, applyresult json)
  RETURNS "pg_catalog"."json" AS $BODY$

declare
	--优惠活动信息
	activitymessageid int4;--活动id
	activityType VARCHAR;--活动类型
	--活动申请信息
	applyid INT;--申请id
	applytime TIMESTAMP;--申请时间
	ordernum INT;--优惠档次
	--玩家信息
	playerid int4;--玩家id
	sitecode varchar;--站点code

	rec_way record;--优惠形式结果集
	isaudit BOOLEAN;--活动是否需要审核
	orderNo VARCHAR;--订单流水号
	favorable_id_temp int;--优惠记录主键
	transaction_id_temp int;--订单记录主键
	isAuditFavorable BOOLEAN := TRUE;--是否优惠稽核
	auditPoints NUMERIC ;--稽核点
	activityname_json VARCHAR := '' ;--活动名称，所有语言版本的名称都需要存储
	favorableremark VARCHAR;--备注信息
	result_code_array text [];--结果返回数组,由4个成员组成:resultcode(结果代码),code代码(),value(优惠金额,非必须),value值(非必须)
	result_code text;---code(操作代码)
	ACTIVITY_MEET text := '000';--满足所有优惠条件
	TYPE_REGIST_SEND VARCHAR := 'regist_send';--注册送的activity_type
	TYPE_RELIEF_FUND VARCHAR := 'relief_fund';--救济金的activity_type
	APPLY_CHECK_STATUS_PENDING VARCHAR := '1';--申请审核状态-待处理
	APPLY_CHECK_STATUS_SUCCESS VARCHAR := '2';--申请审核状态-成功
	PREFERETIAL_FORM_PERCENTAGE varchar := 'percentage_handsel';--优惠形式:比例彩金
	PREFERETIAL_FORM_REGULAR varchar := 'regular_handsel';--优惠形式:固定彩金
BEGIN
--信息初始化
activitymessageid =  activitymessage ->> 'activitymessageid';
activitytype = activitymessage->>'activitytype';
playerid =  playerInfo ->> 'playerid';
applytime =  (playerInfo ->> 'applytime')::TIMESTAMP;
sitecode =  playerInfo ->> 'sitecode';
applyid = applyresult->>'applyId';
ordernum = applyresult->>'ordernum';
result_code_array[1] = 'resultcode';
result_code_array[2] = ACTIVITY_MEET;
--目前只有注册送和救济金需要立即计算活动优惠
IF activitytype <> TYPE_REGIST_SEND AND activitytype <> TYPE_RELIEF_FUND THEN
	raise info '活动类型：%，不需要立即计算活动优惠',activitytype;
	RETURN json_object(result_code_array);
END IF;

IF activitytype = TYPE_REGIST_SEND THEN
	favorableremark = '注册赠送彩金';
ELSEIF activitytype = TYPE_RELIEF_FUND THEN
	favorableremark = '赠送救济金';
END IF;

SELECT * from f_message_query_activityname(activitymessageid) INTO activityname_json;
SELECT is_audit FROM activity_rule  where activity_message_id = activitymessageid INTO isaudit;
raise info '该活动的优惠是否需要审核状态为:%',isaudit;
FOR rec_way in SELECT * FROM activity_way_relation WHERE activity_message_id = activitymessageid AND order_column = ordernum
loop
	--生成玩家优惠记录
	IF rec_way.preferential_form = PREFERETIAL_FORM_REGULAR THEN
		insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit)
		values(applyid,activitymessageid,rec_way.preferential_form,rec_way.preferential_value,rec_way.preferential_audit);
		result_code_array[3] = 'value';
		result_code_array[4] = rec_way.preferential_value;
	END IF;

	IF isaudit THEN
		--更新玩家优惠申请信息的状态 0待确认１待处理２成功３失败
		UPDATE activity_player_apply set check_state = APPLY_CHECK_STATUS_PENDING WHERE id = applyid;
	ELSE
		orderNo := (SELECT f_order_no(sitecode, '02'));
		IF rec_way.preferential_audit = NULL OR rec_way.preferential_audit = 0 THEN
			isAuditFavorable = FALSE;
		ELSE
			auditPoints = rec_way.preferential_value*rec_way.preferential_audit;
		END IF;
		--更新玩家优惠申请信息为成功
		UPDATE activity_player_apply set check_state = APPLY_CHECK_STATUS_SUCCESS WHERE id = applyid;
		--自动生成优惠记录
		WITH favorable AS (
			INSERT INTO player_favorable
			(favorable, favorable_remark, is_audit_favorable, audit_favorable_multiple, activity_message_id, transaction_no, favorable_source,player_id,operator_id) VALUES
			(rec_way.preferential_value,favorableremark, isAuditFavorable, rec_way.preferential_audit, activitymessageid, orderNo, 'activity_favorable',playerid,0)
			RETURNING id
		)
		SELECT id FROM favorable INTO favorable_id_temp;
		raise info '自动生成优惠记录:%',favorable_id_temp;
		--自动生成交易订单
		WITH playtransaction AS (
			INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data,origin,rank_id,completion_time) VALUES
			(orderNo, applytime, 'favorable', favorableremark, rec_way.preferential_value, rec_way.preferential_value + (SELECT wallet_balance FROM user_player WHERE id = playerid), 'success',playerid, favorable_id_temp, auditPoints, false, false, 'favourable', activitytype, activityname_json,'PC',(SELECT rank_id FROM user_player WHERE id = playerid),applytime)
			RETURNING id
		)
		SELECT id FROM playtransaction INTO transaction_id_temp;
		raise info '自动生成交易记录:%',transaction_id_temp;
		--更新玩家优惠记录
		UPDATE player_favorable set player_transaction_id = transaction_id_temp WHERE id = favorable_id_temp;
		-- 修改玩家余额
		UPDATE user_player SET wallet_balance = COALESCE(wallet_balance,0) + rec_way.preferential_value WHERE id = playerid;
	END IF;
END loop;

	RETURN json_object(result_code_array);

END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_message_calculator"(activitymessage json, playerinfo json, applyresult json) IS '立即计算优惠';