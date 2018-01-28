-- auto gen by cherry 2018-01-16 11:57:06
UPDATE player_recharge set recharge_type='qqwallet_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_qq';

UPDATE player_recharge set recharge_type='alipay_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_zfb';

UPDATE player_recharge set recharge_type='wechatpay_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_wx';

UPDATE player_recharge set recharge_type='union_pay_scan' where (recharge_type is NULL or recharge_type='') AND payer_bank LIKE '%_yl';