-- auto gen by cherry 2016-07-15 14:07:15
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use","order_num", "pay_type", "website")
SELECT  '47', 'dinpay_wx', NULL, 'CN', '3', '智付-微信支付', NULL, '智付', 't',  NULL, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='dinpay_wx');

UPDATE game_i18n set name='美式扑克' where  game_id =(select id from game where api_id=6 and code='amvp') AND locale='zh_CN';

UPDATE game_i18n set name='美式撲克' where  game_id =(select id from game where api_id=6 and code='amvp') AND locale='zh_TW';

