-- auto gen by steffan 2018-10-03 14:19:54
--更新短信接口参数
update sms_interface set ext_json = '{"sms.username":"","sms.password":"","sms.dataKey":"","sms.signature":""}' where id=1;
update sms_interface set ext_json = '{"sms.appId":"","sms.dataKey":"","sms.signature":""}' where id=2;