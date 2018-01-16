-- auto gen by cherry 2018-01-16 19:00:20
UPDATE player_recharge set recharge_type='qqwallet_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_qqwap';
UPDATE player_recharge set recharge_type='qqwallet_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_qqh5';

UPDATE player_recharge set recharge_type='alipay_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_zfbwap';
UPDATE player_recharge set recharge_type='alipay_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_zfbh5';

UPDATE player_recharge set recharge_type='wechatpay_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_wxwap';
UPDATE player_recharge set recharge_type='wechatpay_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_wxh5';
UPDATE player_recharge set recharge_type='wechatpay_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_wxfkm';
UPDATE player_recharge set recharge_type='union_pay_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_ylwap';