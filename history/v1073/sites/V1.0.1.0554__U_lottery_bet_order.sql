-- auto gen by marz 2017-10-12 12:10:58
UPDATE lottery_bet_order SET bonus_model = '1' WHERE bonus_model = null OR bonus_model = '0' OR bonus_model = '';
COMMENT ON COLUMN "lottery_bet_order"."bonus_model" IS '奖金模式：1:元,10:角,100:分';
