-- auto gen by cherry 2016-02-04 14:37:00
UPDATE pay_api_param SET param_value = "replace"(param_value, 'pcenter/fund/playerRecharge', 'onlinePay') WHERE param_value LIKE '${payDomain}%';

