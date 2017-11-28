-- auto gen by cherry 2016-09-06 16:27:08
UPDATE pay_account SET bank_code='jiupay' WHERE bank_code='9pay';

UPDATE pay_account SET bank_code='jiupay_wx' WHERE bank_code='9pay_wx';

UPDATE player_recharge SET payer_bank='jiupay' WHERE payer_bank='9pay';

UPDATE player_recharge SET payer_bank='jiupay_wx' WHERE payer_bank='9pay_wx';
