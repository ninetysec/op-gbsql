-- auto gen by cherry 2017-08-16 10:40:03
select redo_sqls($$
       ALTER TABLE lottery_bet_order ADD COLUMN odd2 numeric(20,3);
			ALTER TABLE lottery_bet_order ADD COLUMN odd3 numeric(20,3);
$$);

COMMENT ON COLUMN lottery_bet_order.odd2 is '赔率2';
COMMENT ON COLUMN lottery_bet_order.odd3 is '赔率3';