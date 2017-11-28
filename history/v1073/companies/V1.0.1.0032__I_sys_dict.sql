-- auto gen by cherry 2016-02-25 15:42:03
DELETE FROM sys_param WHERE module='setting' AND param_code='visit.management.center.prompt' AND param_type='visit';

  select redo_sqls($$
    ALTER TABLE "sys_domain_check" ADD COLUMN "agent_id" int4;
  $$);

COMMENT ON COLUMN "sys_domain_check"."agent_id" IS '代理ID';

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code",	"order_num", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'SWITCH', '552', '站点开关',NULL, 't'
WHERE 'SWITCH' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');

insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)
  SELECT 'notice', 'sitecontentcheck', 'DOCUMENT_AUDIT_SUCCESS', NULL, '文案审核成功', NULL, 't'
  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = 'DOCUMENT_AUDIT_SUCCESS');

insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)
  SELECT 'notice', 'sitecontentcheck', 'DOCUMENT_AUDIT_FAIL', NULL, '文案审核失败', NULL, 't'
  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = 'DOCUMENT_AUDIT_FAIL');

insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)
  SELECT 'notice', 'sitecontentcheck', 'LOGO_AUDIT_SUCCESS', NULL, 'LOGO审核成功', NULL, 't'
  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = 'LOGO_AUDIT_SUCCESS');

insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)
  SELECT 'notice', 'sitecontentcheck', 'LOGO_AUDIT_FAIL', NULL, 'LOGO审核失败', NULL, 't'
  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = 'LOGO_AUDIT_FAIL');

insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)
  SELECT 'notice', 'sitecontentcheck', 'ACTIVITY_AUDIT_SUCCESS', NULL, '优惠活动审核成功', NULL, 't'
  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = 'ACTIVITY_AUDIT_SUCCESS');

insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)
  SELECT 'notice', 'sitecontentcheck', 'ACTIVITY_AUDIT_FAIL', NULL, '优惠活动审核失败', NULL, 't'
  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = 'ACTIVITY_AUDIT_FAIL');

ALTER TABLE "currency_exchange_rate" ALTER COLUMN "rate" SET DEFAULT 0;
ALTER TABLE "currency_exchange_rate" ALTER COLUMN "rate" SET NOT NULL;