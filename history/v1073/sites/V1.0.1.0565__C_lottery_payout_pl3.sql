-- auto gen by marz 2017-10-24 20:34:21
DROP FUNCTION IF EXISTS "lottery_payout_pl3"(lotteryresultjson text, lotteryparameter json);
CREATE OR REPLACE FUNCTION "lottery_payout_pl3"(lotteryresultjson text, lotteryparameter json)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lotteryResultJson 开奖结果
  -- lotteryParameter 开奖参数
*/
DECLARE
lottery_expect text;
lottery_code text;
lottery_open_code text;
lotteryBetOrder RECORD;--开奖结果
resultJson VARCHAR;--单个中奖结果JSON串

p_expect VARCHAR;--期数
p_code VARCHAR;--彩种
p_play_code VARCHAR;--玩法
p_bet_code VARCHAR;--下注内容
p_winning_num VARCHAR;--中奖号码
winning_num_arr VARCHAR(3)[]; --组选中奖号码

ERROR_PARAMETER text:='01';--参数错误
ERROR_NOT_NEED text:='02';--无需派彩
ERROR_NOT_WINNING_RECORD text:='03';--无开奖结果
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN
lottery_expect  = lotteryParameter->>'expect';
lottery_code = lotteryParameter->>'code';
lottery_open_code = lotteryParameter->>'opencode';
--判断是否需要开奖派彩
IF lottery_expect = ''  or lottery_code='' THEN
RETURN ERROR_PARAMETER;
END IF;

IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status='1' ) THEN
RETURN ERROR_NOT_NEED;
END IF;

IF lotteryResultJson is null or lotteryResultJson = '' THEN
	RETURN ERROR_NOT_WINNING_RECORD;
END IF;
raise notice '%期%开始进行派彩,中奖记录为:%', lottery_expect,lottery_code,lotteryResultJson;
for resultJson in select json_array_elements(lotteryResultJson::json)
loop
		select resultJson::json->>'expect' into p_expect;
		select resultJson::json->>'code' into p_code;
		select resultJson::json->>'play_code' into p_play_code;
		select resultJson::json->>'bet_code' into p_bet_code;
		select resultJson::json->>'winning_num' into p_winning_num;
		 IF p_play_code='pl3_group_three' THEN
    winning_num_arr = regexp_split_to_array(p_winning_num,'s*');
    p_winning_num = '%'||winning_num_arr[1]||'%'||winning_num_arr[2]||'%';
    raise notice '组选三中奖号码为:%', p_winning_num;
    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num  like p_winning_num;
    ELSEIF p_play_code='pl3_group_six' THEN
    winning_num_arr = regexp_split_to_array(p_winning_num,'s*');
    p_winning_num = '%'||winning_num_arr[1]||'%'||winning_num_arr[2]||'%'||winning_num_arr[3]||'%';
    raise notice '组选六中奖号码为:%', p_winning_num;
    UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num like p_winning_num;

 --官方玩法
    ELSEIF p_play_code='pl3_sanxing_zhixuan' THEN
			IF p_bet_code='pl3_sanxing_zhixuan_fs' THEN
				 winning_num_arr = regexp_split_to_array(p_winning_num,',');
				 p_winning_num =  '%'||winning_num_arr[1]||'%'||'|%'||winning_num_arr[2]||'%'||'|%'||winning_num_arr[3]||'%';
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code='pl3_sanxing_zhixuan_ds' THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
            ELSEIF p_bet_code in ('pl3_sanxing_zhixuan_hz')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(p_winning_num, '')::INT[] & string_to_array(bet_num, '|') :: INT[], 1) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
   ELSEIF p_play_code='pl3_sanxing_zuxuan' THEN
			IF p_bet_code in ('pl3_sanxing_zuxuan_z3fs') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_z3ds')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_z6fs') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_z6ds')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_hhzx') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE position(array_to_string(string_to_array(p_winning_num, ','), '') in bet_num)>0 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE  position(array_to_string(string_to_array(p_winning_num, ','), '') in bet_num)>0 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_sanxing_zuxuan_zxhz')  THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(ARRAY(select sum(unnest) from unnest(string_to_array(p_winning_num, ',')::INT[]))::INT[]  & string_to_array(bet_num, '|') :: INT[], 1) = 1 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=2 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =odd2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(ARRAY(select sum(unnest) from unnest(string_to_array(p_winning_num, ',')::INT[]))::INT[]  & string_to_array(bet_num, '|') :: INT[], 1) = 1 AND array_length(uniq(sort(string_to_array(p_winning_num,',')::INT[])),1)=3 AND expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
            END IF;
             ELSEIF p_play_code='pl3_erxing_zhixuan' THEN
			IF p_bet_code in ('pl3_erxing_zhixuan_qefs','pl3_erxing_zhixuan_hefs') THEN
				 winning_num_arr = regexp_split_to_array(p_winning_num,',');
				 p_winning_num = '%'||winning_num_arr[1]||'%'||'|%'||winning_num_arr[2]||'%';
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE bet_num like p_winning_num and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_erxing_zhixuan_qeds','pl3_erxing_zhixuan_heds') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
            ELSEIF p_play_code='pl3_erxing_zuxuan' THEN
			IF p_bet_code in ( 'pl3_erxing_zuxuan_qefs','pl3_erxing_zuxuan_hefs') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			ELSEIF p_bet_code in ('pl3_erxing_zuxuan_qeds','pl3_erxing_zuxuan_heds') THEN
				UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE POSITION(p_winning_num in bet_num ) > 0 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
			END IF;
            ELSEIF p_play_code='pl3_yixing' THEN
			IF p_bet_code = 'pl3_yixing_dwd' THEN
				UPDATE lottery_bet_order  SET payout =trunc(odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 3 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =trunc(odd*2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 2 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
				UPDATE lottery_bet_order  SET payout =trunc(odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),2),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE (SELECT COUNT (*) FROM (	SELECT * FROM	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(p_winning_num, ',')::VARCHAR[]) )T  	) t1
				INNER JOIN	(	SELECT "row_number"() OVER () , * FROM (SELECT  UNNEST(string_to_array(bet_num, '|')::VARCHAR[])) T	) t2
				ON t1.row_number = t2.row_number AND POSITION (t1.unnest IN t2.unnest) > 0) T) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code=p_play_code AND bet_code=p_bet_code;
			END IF;
            ELSEIF p_play_code='pl3_budingwei_sanxing' THEN
			IF p_bet_code = 'pl3_budingwei_sxym' THEN
				UPDATE lottery_bet_order  SET payout =odd*3*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 3 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
        UPDATE lottery_bet_order  SET payout =odd*2*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 2 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
        UPDATE lottery_bet_order  SET payout =odd*coalesce(multiple,1)/coalesce(bonus_model::INT,1)::NUMERIC(20,3),payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE array_length(string_to_array(bet_num, ',') ::INT[]  & string_to_array(p_winning_num, ',') :: INT[], 1) = 1 and expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code;
			END IF;
			 ELSE
      UPDATE lottery_bet_order  SET payout =bet_amount*odd,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) WHERE expect=p_expect AND code=p_code AND status='1' AND play_code= p_play_code AND bet_code=p_bet_code AND bet_num=p_winning_num;
    END IF;
END loop;

--中奖记录之外的投注派彩全部为0
UPDATE lottery_bet_order  SET payout =0,payout_time = now(), status='2',effective_trade_amount=trunc(bet_amount-bet_amount*coalesce(rebate,0),2) where expect=p_expect AND code=p_code AND status='1' ;
--派彩大于0的需要更新api余额，生成资金记录
FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0
loop
		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22 AND NOT EXISTS (SELECT id FROM lottery_transaction WHERE source_id=lotteryBetOrder.id AND transaction_type='2');
		INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
				SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,'2',lotteryBetOrder.payout,(select p.money from player_api p where p.player_id=lotteryBetOrder.user_id and p.api_id=22),
        lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'开奖派彩' WHERE NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lotteryBetOrder.id AND t.transaction_type='2');

END loop;
return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout_pl3"(lotteryresultjson text, lotteryparameter json) IS '排列3派彩';