-- auto gen by cherry 2016-01-24 13:49:50
UPDATE sys_resource SET name='平台参数' WHERE id=601;

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
 SELECT '60103', '新增域名', 'sysDomainOperator/create.html', '', '601', '', '1', 'ccenter', 'test:view', '2', '', 't', 't', 't'
WHERE 60103 NOT in(SELECT id FROM sys_resource);

INSERT INTO "site_customer_service" ( "site_id", "code", "name", "parameter", "status", "create_time", "create_user", "built_in")
SELECT  '0', 'K001', '默认客服', NULL, 't', '2016-01-18 07:19:04.719', '0', 't'
WHERE 'K001' NOT in(SELECT code FROM site_customer_service WHERE site_id='0');

INSERT INTO "site_customer_service" ( "site_id", "code", "name", "parameter", "status", "create_time", "create_user", "built_in")
SELECT  '-1', 'K001', '默认客服', NULL, 't', '2016-01-19 08:02:36.911', '241', 't'
WHERE 'K001' NOT in (SELECT code FROM site_customer_service WHERE site_id='-1');

COMMENT ON COLUMN "sys_domain"."resolve_status" IS '域名绑定状态:1 待绑定，2绑定中，3待解绑，4解绑中，5完成，6失败';

UPDATE sys_param SET param_value ='/manager.html', default_value ='/manager.html', order_num ='4', remark ='管理中心', parent_code ='', active ='t', site_id ='0'
WHERE  module ='content' AND param_type ='domain_type' AND param_code ='manager';

UPDATE sys_param SET  param_value ='/Information.html', default_value ='/information.html', order_num ='2', remark ='资讯', parent_code ='', active ='t', site_id='0'
WHERE module ='content' AND param_type ='domain_type' AND  param_code ='information';

UPDATE sys_param SET  param_value ='/detection.html', default_value ='/detection.html', order_num ='3', remark ='线路检测', parent_code =NULL, active ='t', site_id='0'
WHERE module ='content' AND param_type ='domain_type' AND param_code ='detection';

UPDATE sys_param SET  param_value ='/index.html', default_value ='/index.html', order_num ='1', remark ='主页', parent_code =NULL, active ='t', site_id ='0'
WHERE module ='content' AND param_type ='domain_type' AND param_code ='index';


