-- auto gen by marz 2017-11-09 17:10:36
DROP FUNCTION IF EXISTS "lottery_revoke"(lottery_code text, lottery_expect text);
CREATE OR REPLACE FUNCTION "lottery_revoke"(lottery_code text, lottery_expect text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本说明
	-- 根据code,expect批量撤单
  -- lottery_code 彩种代号
  -- lottery_expect 期数
	--运行函数
	--select lottery_revoke('cqssc','2017041062')
*/

DECLARE
lottery_order_status VARCHAR:= '1';--注单待结算状态
revoke_status VARCHAR:= '3';--已取消
lottery_tranction_revoke VARCHAR:= '8';--待结撤单类型
lottery_memo text:='待结算注单撤单';--彩票备注
lottery_api_id INT:= 22;--LT游戏apiId
api_balance numeric(20,3);--钱包余额
bet_money numeric(20,3);--需要变更的额度
lotteryBetOrder RECORD;--注单数据
MSG_SUCCESS text:= 'success';--开奖成功
PARAM_ERROR text:= 'param-error';--参数丢失
DATA_NULL_ERROR text:= 'data-null-error';--无注单数据
BEGIN

IF lottery_code = ''  or lottery_expect='' THEN
return PARAM_ERROR;
END IF;
IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status=lottery_order_status ) THEN
RETURN DATA_NULL_ERROR;
END IF;
FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status=lottery_order_status
loop
		IF lotteryBetOrder.bet_amount > 0 THEN
			--获取player_api钱钱包余额
	    	SELECT COALESCE(max(pa.money), 0) FROM player_api pa WHERE pa.api_id = lottery_api_id AND pa.player_id = lotteryBetOrder.user_id into api_balance;
			--更新player_game_order对应资金记录数据状态
			update player_game_order po set order_state='cancel' FROM lottery_bet_order lo  WHERE po.api_id=lottery_api_id AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect AND order_state='pending_settle';
			--增加lottery资金记录  待结算
			bet_money = lotteryBetOrder.bet_amount-TRUNC(lotteryBetOrder.bet_amount*COALESCE(lotteryBetOrder.rebate,0),3);
			INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
		         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,lottery_tranction_revoke, bet_money ,(api_balance+bet_money),
		        now(),lotteryBetOrder.terminal,lotteryBetOrder.id,lottery_memo WHERE NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lotteryBetOrder.id  AND t.transaction_type=lottery_tranction_revoke) AND EXISTS (SELECT id FROM lottery_bet_order WHERE status=lottery_order_status AND id = lotteryBetOrder.id);
			--修改player_api钱包余额
	     UPDATE player_api SET money=(COALESCE (money,0) + bet_money) WHERE api_id = lottery_api_id AND player_id = lotteryBetOrder.user_id AND EXISTS (SELECT id FROM lottery_bet_order WHERE status=lottery_order_status AND id = lotteryBetOrder.id);
	    --更新注单状态为已取消
			UPDATE lottery_bet_order SET status=revoke_status WHERE id=lotteryBetOrder.id AND status=lottery_order_status;
		END IF;
END loop;
raise notice '调用过程结果：%',MSG_SUCCESS;
return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "lottery_revoke"(lottery_code text, lottery_expect text) IS '批量撤单';
------------------------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_revocation"(lottery_code text, lottery_expect text);
CREATE OR REPLACE FUNCTION "lottery_revocation"(lottery_code text, lottery_expect text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本说明
	-- 根据code,expect批量撤销
  -- lottery_code 彩种代号
  -- lottery_expect 期数
	--运行函数
	--select lottery_revocation('cqssc','2017041062')
*/

DECLARE
lottery_order_status VARCHAR:= '2';--注单已结算状态
revoke_status VARCHAR:= '3';--已取消
lottery_tranction_revoke VARCHAR:= '9';--已结撤销类型
lottery_memo text:='已结算注单撤销';--彩票备注
lottery_api_id INT:= 22;--LT游戏apiId
api_balance numeric(20,3);--钱包余额
bet_money numeric(20,3);--需要变更的额度
lotteryBetOrder RECORD;--注单数据
MSG_SUCCESS text:= 'success';--开奖成功
PARAM_ERROR text:= 'param-error';--参数丢失
DATA_NULL_ERROR text:= 'data-null-error';--无注单数据
BEGIN

IF lottery_code = ''  or lottery_expect='' THEN
return PARAM_ERROR;
END IF;
IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status=lottery_order_status ) THEN
RETURN DATA_NULL_ERROR;
END IF;
FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status=lottery_order_status
loop

		IF lotteryBetOrder.bet_amount > 0 THEN
			--获取player_api钱钱包余额
	    	SELECT COALESCE(max(pa.money), 0) FROM player_api pa WHERE pa.api_id = lottery_api_id AND pa.player_id = lotteryBetOrder.user_id into api_balance;
			--更新player_game_order对应资金记录数据状态
			update player_game_order po set order_state='cancel' FROM lottery_bet_order lo  WHERE po.api_id=lottery_api_id AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect AND order_state='settle';
			--增加lottery资金记录  已结算
			bet_money = lotteryBetOrder.bet_amount-TRUNC(lotteryBetOrder.bet_amount*COALESCE(lotteryBetOrder.rebate,0),3);
			IF lotteryBetOrder.payout > 0 THEN
				bet_money = bet_money-lotteryBetOrder.payout;
			END IF;
			INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
		         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,lottery_tranction_revoke, bet_money ,(api_balance+bet_money),
		        now(),lotteryBetOrder.terminal,lotteryBetOrder.id,lottery_memo WHERE NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lotteryBetOrder.id  AND t.transaction_type=lottery_tranction_revoke) AND EXISTS (SELECT id FROM lottery_bet_order WHERE status=lottery_order_status AND id = lotteryBetOrder.id);
			--修改player_api钱包余额
	     UPDATE player_api SET money=(COALESCE (money,0) + bet_money) WHERE api_id = lottery_api_id AND player_id = lotteryBetOrder.user_id AND EXISTS (SELECT id FROM lottery_bet_order WHERE status=lottery_order_status AND id = lotteryBetOrder.id);
	    --更新注单状态为已取消
			UPDATE lottery_bet_order SET status=revoke_status WHERE id=lotteryBetOrder.id AND status=lottery_order_status;
		END IF;
END loop;
raise notice '调用过程结果：%',MSG_SUCCESS;
return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "lottery_revocation"(lottery_code text, lottery_expect text) IS '批量撤销';
