-- auto gen by marz 2017-10-25 09:48:43
SELECT redo_sqls($$
ALTER TABLE lottery_report_profit ADD rebate_amount numeric(20,3);
ALTER table lottery_report_profit ALTER  COLUMN  bet_amount  type numeric(20,3);
ALTER table lottery_report_profit ALTER  COLUMN  payout  type numeric(20,3);
$$);