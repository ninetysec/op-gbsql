-- auto gen by steffan 2018-05-24 16:19:29
DROP FUNCTION IF EXISTS gamebox_activityhall_preferential_profitloss(activitymessageid int4, sitecode varchar);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_preferential_profitloss"(activitymessageid int4, sitecode varchar)
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
		preferentialdata 	VARCHAR:= '';	-- 盈亏送有效投注额json
--v1.01  2018/04/23  kobe
	  user_name VARCHAR ; ---玩家账号
	  agentid INT ; ---代理id
	  agentname VARCHAR ; ---代理账号
	  topagentid INT ; ---总代id
	  topagentname VARCHAR ; ---总代账号

BEGIN
    -- 获取活动基本信息：需要站长审核状态，活动国际化名称
    SELECT is_audit FROM activity_rule WHERE activity_message_id = activitymessageid INTO isaudit;
    SELECT * from gamebox_activityhall_query_activityname(activitymessageid) INTO activityname_json;
    raise info '活动是否需要审核:%, 活动名称的JSON:%', isaudit, activityname_json;

    -- 获取该活动的所有申请玩家
    FOR rec_apply IN (SELECT * FROM activity_player_apply WHERE activity_message_id = activitymessageid AND check_state = '0' AND end_time <= CURRENT_TIMESTAMP)
    LOOP
      --v1.01  2018/04/23  kobe
			SELECT username FROM sys_user WHERE id = rec_apply.user_id INTO user_name ;
			SELECT user_agent_id,agent_name,general_agent_id,general_agent_name FROM user_player WHERE id = rec_apply.user_id INTO agentid,agentname,topagentid,topagentname;

    	-- 计算玩家该申领周期内的盈利亏损情况
    	SELECT gamebox_activityhall_calculator_profit_loss(rec_apply.user_id, rec_apply.start_time, rec_apply.end_time,activitymessageid) INTO preferential_value_temp;
    	raise notice '查询玩家盈利亏损情况,结果:%',preferential_value_temp;
      preferentialdata = '{' || '''profitLoss'':'  || '''' || preferential_value_temp || '''' || '}';

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
                        preferential_audit,
												preferential_data
                    ) values (
        				rec_apply.id,
        				rec_apply.activity_message_id,
        				rec_way.preferential_form,
        				rec_way.preferential_value,
        				rec_way.preferential_audit,
								preferentialdata
                    );
    			END IF;

    			-- 根据是否提交站长审核进行不同的处理
    			IF isaudit THEN
    				--更新玩家优惠申请信息的状态１待处理２成功３失败
    				UPDATE activity_player_apply set check_state = '1' WHERE id = rec_apply.id;
    			ELSE
    				--生成订单号
            orderNo := rec_apply.apply_transaction_no;
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
                            favorable_source,
														player_id,
														player_apply_id
                        ) VALUES (
                            rec_way.preferential_value,
                            '系统自动计算玩家参与优惠活动【盈亏送】',
                            isAuditFavorable,
                            rec_way.preferential_audit,
                            activitymessageid,
                            orderNo,
                            'activity_favorable',
														 rec_apply.user_id,
														 rec_apply.id
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
														rank_id,
														completion_time,
														agent_id,
														agent_username,
														topagent_id,
														topagent_username,
														user_name
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
														rec_apply.activity_terminal_type,
														(SELECT rank_id FROM user_player WHERE id = rec_apply.user_id),
														now(),
														agentid,
														agentname,
														topagentid,
														topagentname,
														user_name
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


COMMENT ON FUNCTION "gamebox_activityhall_preferential_profitloss"(activitymessageid int4, sitecode varchar) IS '盈亏送活动计算';