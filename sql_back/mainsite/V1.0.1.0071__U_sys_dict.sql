-- auto gen by cheery 2015-11-10 13:44:01
update sys_dict SET dict_code = 'favourable',remark ='资金类型:优惠' where module = 'common' AND "dict_type" = 'fund_type' AND dict_code = 'rebate';

UPDATE sys_dict set dict_code = 'error_recharge' WHERE "module"='fund' and dict_type='withdraw_type' and dict_code ='errorRecharge';

UPDATE sys_dict set dict_code = 'negative' WHERE "module"='fund' and dict_type='withdraw_type' and dict_code ='negativeNumber';

UPDATE sys_dict set dict_code = 'Illegal_trade' WHERE "module"='fund' and dict_type='withdraw_type' and dict_code ='illegalTrade';

UPDATE sys_dict set dict_code = 'artificial_draw' WHERE "module"='fund' and dict_type='withdraw_type' and dict_code ='artificialWithdraw';

UPDATE sys_dict set dict_code = 'abandon_favourable' WHERE "module"='fund' and dict_type='withdraw_type' and dict_code ='abandonFavourable';

UPDATE sys_dict SET dict_code = 'cbc' WHERE module='common' AND dict_type='bankname' AND dict_code='ccb';

UPDATE sys_dict SET dict_code = 'integrated_deposit' WHERE module = 'fund' AND dict_type = 'recharge_type' AND  dict_code = 'artificial_deposit';

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'fund_type', 'refund_fee', '11', '资金类型：返还手续费', NULL, 't'
  WHERE 'refund_fee' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'fund_type');
