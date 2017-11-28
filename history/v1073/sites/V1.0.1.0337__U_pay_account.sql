-- auto gen by wayne 2016-12-03 10:04:58
UPDATE "pay_account" SET "bank_code"='ips-3' WHERE "bank_code"='ips_3';
UPDATE "pay_account" SET "bank_code"='ips-7' WHERE "bank_code"='ips_7';
UPDATE "pay_account" SET "bank_code"='bbpay-old' WHERE "bank_code"='bbpay_old';
UPDATE "pay_account" SET "bank_code"='bbpay-new' WHERE "bank_code"='bbpay_new';
UPDATE "pay_account" SET "bank_code"='allscore-s_wx' WHERE "bank_code"='allscore_s_wx';
UPDATE "pay_account" SET "bank_code"='allscore-s_zfb' WHERE "bank_code"='allscore_s_zfb';

--此次更新对应的回滚语句
--UPDATE "pay_account" SET "bank_code"='ips_3' WHERE "bank_code"='ips-3';
--UPDATE "pay_account" SET "bank_code"='ips_7' WHERE "bank_code"='ips-7';
--UPDATE "pay_account" SET "bank_code"='bbpay_old' WHERE "bank_code"='bbpay-old';
--UPDATE "pay_account" SET "bank_code"='bbpay_new' WHERE "bank_code"='bbpay-new';
--UPDATE "pay_account" SET "bank_code"='allscore_s_wx' WHERE "bank_code"='allscore-s_wx';
--UPDATE "pay_account" SET "bank_code"='allscore_s_zfb' WHERE "bank_code"='allscore-s_zfb';