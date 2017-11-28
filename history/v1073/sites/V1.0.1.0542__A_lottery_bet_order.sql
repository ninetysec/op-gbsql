-- auto gen by marz 2017-10-05 21:39:46
 select redo_sqls($$
ALTER TABLE lottery_bet_order ADD COLUMN bonus_model VARCHAR(2);
ALTER TABLE lottery_bet_order ADD COLUMN play_model VARCHAR(2);
ALTER TABLE lottery_bet_order ADD COLUMN rebate numeric(20,3);
ALTER TABLE lottery_bet_order ADD COLUMN multiple int4;
ALTER TABLE lottery_bet_order ADD COLUMN bet_count int4;
ALTER TABLE lottery_bet_order ALTER COLUMN bet_num TYPE text;
$$);

COMMENT ON COLUMN "lottery_bet_order"."bonus_model" IS '奖金模式：0:元,1:角,2:分';
COMMENT ON COLUMN "lottery_bet_order"."play_model" IS '玩法模式：1-官方玩法 null或者0-表示双面玩法';
COMMENT ON COLUMN "lottery_bet_order"."rebate" IS '返点比例';
COMMENT ON COLUMN "lottery_bet_order"."multiple" IS '倍数';
COMMENT ON COLUMN "lottery_bet_order"."bet_count" IS '注数';
COMMENT ON COLUMN "lottery_bet_order"."odd" IS '赔率或奖金';
COMMENT ON COLUMN "lottery_bet_order"."odd2" IS '赔率2或奖金2';
COMMENT ON COLUMN "lottery_bet_order"."odd3" IS '赔率3或奖金3';