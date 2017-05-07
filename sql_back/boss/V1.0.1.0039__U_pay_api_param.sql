-- auto gen by cheery 2015-12-23 20:12:34
UPDATE pay_api_param SET param_value='${payDomain}/pcenter/fund/playerRecharge/doPayFrontCallback.html?channel_code=gopay&merchant_id=${merchantID}'
WHERE channel_code='gopay' AND api_type='pay' AND param_name='frontMerUrl';

UPDATE pay_api_param SET param_value='${payDomain}/pcenter/fund/playerRecharge/doPayBackCallback.html?channel_code=gopay&merchant_id=${merchantID}'
WHERE channel_code='gopay' AND api_type='pay' AND param_name='backgroundMerUrl';

UPDATE pay_api_param SET param_value='${payDomain}/pcenter/fund/playerRecharge/doPayFrontCallback.html?channel_code=baofoo&merchant_id=${MemberID}'
WHERE channel_code='gopay' AND api_type='pay' AND param_name='backgroundMerUrl';

UPDATE pay_api_param SET param_value='${payDomain}/pcenter/fund/playerRecharge/doPayFrontCallback.html?channel_code=baofoo&merchant_id=${MemberID}'
WHERE channel_code='baofoo' AND api_type='pay' AND param_name='PageUrl';

UPDATE pay_api_param SET param_value='${payDomain}/pcenter/fund/playerRecharge/doPayBackCallback.html?channel_code=baofoo&merchant_id=${MemberID}'
WHERE channel_code='baofoo' AND api_type='pay' AND param_name='ReturnUrl';

UPDATE pay_api_param SET param_value='${payDomain}/pcenter/fund/playerRecharge/doPayBackCallback.html?channel_code=yeepay&merchant_id=${p1_MerId}'
WHERE channel_code='yeepay' AND api_type='pay' AND param_name='p8_Url';

UPDATE pay_api_param SET param_value='${payDomain}/pcenter/fund/playerRecharge/doPayFrontCallback.html?channel_code=ips&merchant_id=${Mer_code}'
WHERE channel_code='ips' AND api_type='pay' AND param_name='Merchanturl';

UPDATE pay_api_param SET param_value='${payDomain}/pcenter/fund/playerRecharge/doPayBackCallback.html?channel_code=ips&merchant_id=${Mer_code}'
WHERE channel_code='ips' AND api_type='pay' AND param_name='ServerUrl';