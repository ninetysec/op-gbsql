-- auto gen by gamebox 2016-10-12 21:52:48
UPDATE "pay_api_provider" SET "ext_json"='{"pro":{"payUrl":"http://payment.rfupay.com/prod/commgr/control/inPayService","queryOrderUrl":"http://3rd.pay.api.com/rfupay-pay/Main/api_enquiry/orderEnquiry"},"test":{"payUrl":"http://payment.rfupay.com/prod/commgr/control/inPayService","queryOrderUrl":"http://portal.rfupay.com/Main/api_enquiry/orderEnquiry"}}' WHERE ("id"='30');

--add by Tony for VIP通道
INSERT INTO sys_param ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'content', 'domain_type', 'vip', '/passport/login.html', '/passport/login.html', '6', 'VIP', '', 't', '0'
where 'vip' not in(select param_code from sys_param where "module"='content' and param_type='domain_type');
