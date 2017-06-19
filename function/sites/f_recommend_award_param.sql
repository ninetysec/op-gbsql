DROP FUNCTION IF EXISTS f_recommend_award_param();
CREATE OR REPLACE FUNCTION f_recommend_award_param ()
RETURNS hstore as $$
DECLARE
	singleReward 	BOOLEAN;  		-- 是否启用单次奖励
	rewardWay 		INTEGER:=1;		-- 奖励方式: 1-奖励双方,2-奖励推荐人,3-奖励被推荐人
	deposit 		NUMERIC:=0.00;	-- 单次奖励存款金额
	rewardAmount 	NUMERIC:=0.00;	-- 奖励金额
	rewardMultiple 	NUMERIC:=0.00;	-- 单次奖励优惠稽核倍数
	rewardPoint 	NUMERIC:=0.00; 	-- 优惠稽核点

	bonusReward 	BOOLEAN;		-- 是否启用推荐红利
	effeTrade 		NUMERIC:=0.00;	-- 推荐红利有效玩家交易量
	toplimit 		NUMERIC:=0.00;	-- 红利上限

	paramhash 		hstore;

BEGIN
	SELECT active FROM sys_param WHERE param_type = 'recommended' AND param_code = 'reward' INTO singleReward;

	SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0' ELSE param_value END FROM sys_param 
	 WHERE param_type = 'recommended' AND param_code = 'reward' INTO rewardWay;

	SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param 
	 WHERE param_type = 'recommended' AND param_code = 'reward.theWay' INTO deposit;

	SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param 
	 WHERE param_type = 'recommended' AND param_code = 'reward.money' INTO rewardAmount;

	SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param 
	 WHERE param_type = 'recommended' AND param_code = 'audit' INTO rewardMultiple;

	rewardPoint = rewardAmount * rewardMultiple;

	SELECT active FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus' INTO bonusReward;

	SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param 
	 WHERE param_type = 'recommended' AND param_code = 'bonus.trading' INTO effeTrade;

	SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param 
	WHERE param_type = 'recommended' AND param_code = 'bonus.bonusMax' INTO toplimit;

	SELECT 'singleReward=>'||singleReward INTO paramhash;
	paramhash = paramhash||(SELECT ('rewardWay=>'||rewardWay)::hstore);
	paramhash = paramhash||(SELECT ('deposit=>'||deposit)::hstore);
	paramhash = paramhash||(SELECT ('rewardAmount=>'||rewardAmount)::hstore);
	paramhash = paramhash||(SELECT ('rewardMultiple=>'||rewardMultiple)::hstore);
	paramhash = paramhash||(SELECT ('rewardPoint=>'||rewardPoint)::hstore);

	paramhash = paramhash||(SELECT ('bonusReward=>'||bonusReward)::hstore);
	paramhash = paramhash||(SELECT ('effeTrade=>'||effeTrade)::hstore);
	paramhash = paramhash||(SELECT ('toplimit=>'||toplimit)::hstore);

	RETURN paramhash;

END;

$$ language plpgsql;
COMMENT ON FUNCTION f_recommend_award_param()
IS 'Fei-玩家推荐奖励参数';





