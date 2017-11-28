-- auto gen by wayne 2016-12-03 10:04:58
UPDATE "bank" SET "bank_name"='ips-3' WHERE "bank_name"='ips_3';
UPDATE "bank" SET "bank_name"='ips-7' WHERE "bank_name"='ips_7';
UPDATE "bank" SET "bank_name"='bbpay-old' WHERE "bank_name"='bbpay_old';
UPDATE "bank" SET "bank_name"='bbpay-new' WHERE "bank_name"='bbpay_new';
UPDATE "bank" SET "bank_name"='allscore-s_wx' WHERE "bank_name"='allscore_s_wx';
UPDATE "bank" SET "bank_name"='allscore-s_zfb' WHERE "bank_name"='allscore_s_zfb';

--此次更新对应的回滚语句
--UPDATE "bank" SET "bank_name"='ips_3' WHERE "bank_name"='ips-3';
--UPDATE "bank" SET "bank_name"='ips_7' WHERE "bank_name"='ips-7';
--UPDATE "bank" SET "bank_name"='bbpay_old' WHERE "bank_name"='bbpay-old';
--UPDATE "bank" SET "bank_name"='bbpay_new' WHERE "bank_name"='bbpay-new';
--UPDATE "bank" SET "bank_name"='allscore_s_wx' WHERE "bank_name"='allscore-s_wx';
--UPDATE "bank" SET "bank_name"='allscore_s_zfb' WHERE "bank_name"='allscore-s_zfb';