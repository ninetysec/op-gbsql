DROP FUNCTION if exists gamebox_generate_order_no(TEXT, TEXT, TEXT);
create or replace function gamebox_generate_order_no(
	trans_type 	TEXT,
	site_code 	TEXT,
	order_type 	TEXT
) returns TEXT as $$

DECLARE
	currentDate VARCHAR:=(SELECT to_char(CURRENT_DATE, 'yyMMdd'));
	nextSeqNum	VARCHAR:='';
BEGIN
	site_code = lpad(site_code, 4,'0');
	IF trans_type = 'B' THEN
		IF order_type = '01' THEN		-- 01-游戏API与总控的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_api_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '02' THEN	-- 02-总控与运营商的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_boss_seq'))::VARCHAR , 7, '0');
		ELSEIF order_type = '03' THEN	-- 03-运营商与站长的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_company_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '04' THEN	-- 04-站长与总代的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_generalagent_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '05' THEN	-- 05-站长与代理的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_agent_seq'))::VARCHAR, 7, '0');
		END IF;
	ELSEIF trans_type = 'T' THEN
		IF order_type = '01' THEN		-- 01-充值
			nextSeqNum:=lpad((SELECT nextval('order_id_recharge_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '02' THEN	-- 02-优惠
			nextSeqNum:=lpad((SELECT nextval('order_id_discount_seq'))::VARCHAR , 7, '0');
		ELSEIF order_type = '03' THEN	-- 03-游戏API
			nextSeqNum:=lpad((SELECT nextval('order_id_gameapi_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '04' THEN	-- 04-返水
			nextSeqNum:=lpad((SELECT nextval('order_id_backwater_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '05' THEN	-- 05-返佣
			nextSeqNum:=lpad((SELECT nextval('order_id_rebate_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '06' THEN	-- 06-玩家取款
			nextSeqNum:=lpad((SELECT nextval('order_id_withdraw_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '07' THEN	-- 07-代理提现
			nextSeqNum:=lpad((SELECT nextval('order_id_agent_withdraw_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '08' THEN	-- 08-转账
			nextSeqNum:=lpad((SELECT nextval('order_id_transfers_seq'))::VARCHAR, 7, '0');
		END IF;
	END IF;
	RETURN trans_type||currentDate||site_code||order_type||nextSeqNum;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_generate_order_no(trans_type TEXT, site_code TEXT, order_type TEXT)
IS 'Lins-生成流水号';
