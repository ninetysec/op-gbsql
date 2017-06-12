-- auto gen by cherry 2017-06-10 17:47:22
CREATE SEQUENCE if not EXISTS "bank_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 180
 CACHE 1;
ALTER TABLE "bank" ALTER COLUMN "id" SET DEFAULT nextval('bank_id_seq'::regclass);


INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'caimao_wy', NULL, 'CN', '3', '财猫支付-网银支付', NULL, '财猫支付', 't', '031', '1', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='caimao_wy');



INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'caimao_wx', NULL, 'CN', '3', '财猫支付-微信支付', NULL, '财猫支付', 't', '032', '2', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='caimao_wx');



INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'caimao_zfb', NULL, 'CN', '3', '财猫支付-支付宝', NULL, '财猫支付', 't', '033', '3', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='caimao_zfb');