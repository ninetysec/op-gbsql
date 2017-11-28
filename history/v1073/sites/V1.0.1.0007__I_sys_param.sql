-- auto gen by cherry 2016-02-05 11:52:05
INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
	SELECT  	'setting', 	'visit', 'visit.site.prompt', 	'true', 	'true', NULL, 	'是否开启允许访问站点的IP,是否需要显示提示语', NULL, 't', NULL
WHERE 'visit.site.prompt' not in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='visit' );

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 	'setting', 	'visit', 	'visit.management.center.prompt', 'true', 'true', 	NULL, 	'是否开启允许访问管理中心的IP,是否需要显示提示语', NULL, 	't', 	NULL
WHERE  'visit.management.center.prompt' not in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='visit' );

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'content', 'domain_type', 'onLinePay', '/onLinePay', '/onLinePay', '5', '支付域名', '', 't', '1'
WHERE  'onLinePay' not in(SELECT param_code FROM sys_param WHERE module='content' AND param_type='domain_type' );

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'content', 'domain_type', 'information', '/Information.html', '/information.html', '2', '资讯', '', 't', '1'
WHERE  'information' not in(SELECT param_code FROM sys_param WHERE module='content' AND param_type='domain_type' );

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'content', 'domain_type', 'detection', '/netLine/findLines.html', '/netLine/findLines.html', '3', '线路检测', '', 't', '1'
WHERE  'detection' not in(SELECT param_code FROM sys_param WHERE module='content' AND param_type='domain_type' );

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'content', 'domain_type', 'index', '/index.html', '/index.html', '1', '主页', '', 't', '1'
WHERE  'index' not in(SELECT param_code FROM sys_param WHERE module='content' AND param_type='domain_type' );

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'content', 'domain_type', 'manager', '/mcenter/index.html', '/mcenter/index.html', '4', '管理中心', '', 't', '1'
WHERE  'manager' not in(SELECT param_code FROM sys_param WHERE module='content' AND param_type='domain_type' );

INSERT INTO notice_email_interface( "id", "user_group_type", "user_group_id", "server_address", "server_port", "email_account", "account_password", "built_in", "name", 	"create_time", "update_time", 	"send_count", "status", "reply_email_account", "test_email_account")
SELECT  	'-1', 'rank', '0', '', 	'', 	'', '┼41f87b2cbe2eb0ec7c09ddf82a7c7c12', 't', '默认接口', '2015-08-26 14:14:14', NULL, 	'0', '1', NULL, NULL
WHERE '-1' NOT in(SELECT id FROM notice_email_interface);

UPDATE sys_param set param_value='[{"bulitIn":"true","id":1,"sort":1,"name":"regCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":2,"sort":2,"name":"username","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":3,"sort":3,"name":"password","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":4,"sort":4,"name":"verificationCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":5,"sort":5,"name":"defaultTimezone","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"false","id":6,"sort":6,"name":"countryCity","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":7,"sort":7,"name":"paymentPassword","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":8,"sort":8,"name":"defaultLocale","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":9,"sort":9,"name":"mainCurrency","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":10,"sort":10,"name":"303","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":11,"sort":11,"name":"201","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":12,"sort":12,"name":"nickName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":13,"sort":13,"name":"sex","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":14,"sort":14,"name":"302","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":15,"sort":15,"name":"110","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":16,"sort":16,"name":"birthday","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":17,"sort":17,"name":"realName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":18,"sort":18,"name":"301","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":19,"sort":19,"name":"serviceTerms","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":20,"sort":20,"name":"securityIssues","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":21,"sort":21,"name":"resource","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":22,"sort":22,"name":"constellation","isRequired":"1","isRegField":"1","status":"1"}]',default_value='[{"bulitIn":"true","id":1,"sort":1,"name":"regCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":2,"sort":2,"name":"username","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":3,"sort":3,"name":"password","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":4,"sort":4,"name":"verificationCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":5,"sort":5,"name":"defaultTimezone","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"false","id":6,"sort":6,"name":"countryCity","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":7,"sort":7,"name":"paymentPassword","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":8,"sort":8,"name":"defaultLocale","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":9,"sort":9,"name":"mainCurrency","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":10,"sort":10,"name":"303","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":11,"sort":11,"name":"201","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":12,"sort":12,"name":"nickName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":13,"sort":13,"name":"sex","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":14,"sort":14,"name":"302","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":15,"sort":15,"name":"110","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":16,"sort":16,"name":"birthday","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":17,"sort":17,"name":"realName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":18,"sort":18,"name":"301","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":19,"sort":19,"name":"serviceTerms","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":20,"sort":20,"name":"securityIssues","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":21,"sort":21,"name":"resource","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":22,"sort":22,"name":"constellation","isRequired":"1","isRegField":"1","status":"1"}]'
WHERE param_type='reg_setting' AND param_code='field_setting';

UPDATE sys_param set param_value='[{"bulitIn":"true","id":1,"sort":1,"name":"regCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":2,"sort":2,"name":"username","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":3,"sort":3,"name":"password","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":4,"sort":4,"name":"verificationCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":5,"sort":5,"name":"defaultTimezone","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"false","id":6,"sort":6,"name":"countryCity","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":7,"sort":7,"name":"sex","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":8,"sort":8,"name":"nickName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":9,"sort":9,"name":"defaultLocale","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":10,"sort":10,"name":"302","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":11,"sort":11,"name":"110","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":12,"sort":12,"name":"birthday","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":13,"sort":13,"name":"201","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":14,"sort":14,"name":"paymentPassword","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":15,"sort":15,"name":"realName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":16,"sort":16,"name":"301","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":17,"sort":17,"name":"serviceTerms","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":18,"sort":18,"name":"securityIssues","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":19,"sort":19,"name":"mainCurrency","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":20,"sort":20,"name":"303","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":21,"sort":21,"name":"constellation","isRequired":"1","isRegField":"1","status":"1"}]',default_value='[{"bulitIn":"true","id":1,"sort":1,"name":"regCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":2,"sort":2,"name":"username","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":3,"sort":3,"name":"password","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":4,"sort":4,"name":"verificationCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":5,"sort":5,"name":"defaultTimezone","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"false","id":6,"sort":6,"name":"countryCity","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":7,"sort":7,"name":"sex","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":8,"sort":8,"name":"nickName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":9,"sort":9,"name":"defaultLocale","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":10,"sort":10,"name":"302","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":11,"sort":11,"name":"110","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":12,"sort":12,"name":"birthday","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":13,"sort":13,"name":"201","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":14,"sort":14,"name":"paymentPassword","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":15,"sort":15,"name":"realName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":16,"sort":16,"name":"301","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":17,"sort":17,"name":"serviceTerms","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":18,"sort":18,"name":"securityIssues","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":19,"sort":19,"name":"mainCurrency","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":20,"sort":20,"name":"303","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":21,"sort":21,"name":"constellation","isRequired":"1","isRegField":"1","status":"1"}]'
WHERE param_type='reg_setting_agent' AND param_code='field_setting';

 select redo_sqls($$
      ALTER TABLE pay_account ADD COLUMN "full_rank" bool;
      $$);

COMMENT ON COLUMN pay_account.full_rank IS '全部层级';

drop view if EXISTS v_pay_account;
create or REPLACE view v_pay_account as
 SELECT pa.id,
    pa.pay_name,
    pa.account,
    pa.full_name,
    pa.disable_amount,
    pa.pay_key,
    pa.status,
    pa.create_time,
    pa.create_user,
    pa.type,
    pa.account_type,
    pa.bank_code,
    pa.pay_url,
    pa.code,
    pa.deposit_count,
    pa.deposit_total,
    pa.deposit_default_count,
    pa.deposit_default_total,
    pa.single_deposit_min,
    pa.single_deposit_max,
    pa.effective_minutes,
    pa.full_rank,
    ( SELECT count(1) AS count
           FROM ( SELECT r.pay_account_id
                   FROM (pay_rank r
                     JOIN player_rank k ON ((r.player_rank_id = k.id)))) pr
          WHERE (pr.pay_account_id = pa.id)) AS pay_rank_num,
    ( SELECT count(1) AS recharge_num
           FROM player_recharge pr
          WHERE ((pr.pay_account_id = pa.id) AND ((pr.recharge_status)::text = '2'::text))) AS recharge_num,
    ( SELECT sum(pr.recharge_amount) AS recharge_amount
           FROM player_recharge pr
          WHERE ((pr.pay_account_id = pa.id) AND ((pr.recharge_status)::text = '2'::text))) AS recharge_amount,
    ( SELECT max(COALESCE(pr.create_time, (to_date('1900-1-1'::text, 'yyyy-MM-dd'::text))::timestamp without time zone)) AS max
           FROM player_recharge pr
          WHERE ((pr.pay_account_id = pa.id) AND (((pr.recharge_status)::text = '2'::text) OR ((pr.recharge_status)::text = '5'::text)))) AS last_recharge
   FROM pay_account pa;


