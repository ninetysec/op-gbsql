-- auto gen by cherry 2017-09-04 19:13:48
DROP FUNCTION if EXISTS "lottery_payout"(lottery_expect text, lottery_code text, p_com_url text);

DROP FUNCTION if EXISTS "lottery_payout_k3"(lotteryResultJson text,lotteryParameter json);

DROP FUNCTION IF EXISTS "lottery_payout_keno"(lotteryResultJson text,lotteryParameter json);

DROP FUNCTION if EXISTS "lottery_payout_lhc"(lotteryResultJson text,lotteryParameter json);

DROP FUNCTION IF EXISTS "lottery_payout_pk10"(lotteryResultJson text,lotteryParameter json);

DROP FUNCTION IF EXISTS "lottery_payout_pl3"(lotteryResultJson text,lotteryParameter json);

DROP FUNCTION IF EXISTS "lottery_payout_sfc"(lotteryResultJson text,lotteryParameter json);

DROP FUNCTION IF EXISTS "lottery_payout_ssc"(lotteryResultJson text,lotteryParameter json);

DROP FUNCTION IF EXISTS "lottery_payout_xy28"(lotteryResultJson text,lotteryParameter json);