-- auto gen by cherry 2017-03-07 15:08:46
UPDATE pay_api_provider
set ext_json='{"pro":{"payUrl":"http://gw.sfvipgate.com/v4.aspx","queryOrderUrl":"http://3rd.pay.api.com/sfoopay-pay/v4Query.aspx"},"test":{"payUrl":"http://gw.sfvipgate.com/v4.aspx","queryOrderUrl":"http://gw.3yzf.com/v4Query.aspx"}}'
where channel_code = 'sfoo';

UPDATE pay_api_provider
set ext_json='{"pro":{"payUrl":"http://gw.sfvipgate.com/v4.aspx","queryOrderUrl":"http://3rd.pay.api.com/sfoopay-pay/v4Query.aspx"},"test":{"payUrl":"http://gw.sfvipgate.com/v4.aspx","queryOrderUrl":"http://gw.3yzf.com/v4Query.aspx"}}'
where channel_code = 'sfoo_zfb';

UPDATE pay_api_provider
set ext_json='{"pro":{"payUrl":"http://gw.sfvipgate.com/v4.aspx","queryOrderUrl":"http://3rd.pay.api.com/sfoopay-pay/v4Query.aspx"},"test":{"payUrl":"http://gw.sfvipgate.com/v4.aspx","queryOrderUrl":"http://gw.3yzf.com/v4Query.aspx"}}'
where channel_code = 'sfoo_wx';