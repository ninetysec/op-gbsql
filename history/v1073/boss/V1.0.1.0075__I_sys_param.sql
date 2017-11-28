-- auto gen by admin 2016-06-27 14:51:40
INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active, site_id)

SELECT 'setting', 'sys_tone_transfer', 'transfer', 'musics/transfer/progress.ogg', 'musics/transfer/progress.ogg', 1, '转账异常提醒铃声', null, true, 0

 WHERE 'transfer' not in(select param_code from sys_param where module='setting' and param_type = 'sys_tone_transfer' and param_code = 'transfer');

INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active, site_id)

SELECT 'setting', 'sys_tone_order', 'order', 'musics/order/promotion.mp3', 'musics/order/promotion.mp3', 1, 'API注单进度监控', null, true, 0

 WHERE 'order' not in(select param_code from sys_param where module='setting' and param_type = 'sys_tone_order' and param_code = 'order');


INSERT INTO monitor_config (id, type_name, method_name, vo_name, priority, create_time, is_invoked, is_sync, rule_instance, delay_sec)

SELECT 7, 'so.wwb.gamebox.iservice.company.setting.IApiOrderLogService', 'updateApiOrderLogByAsync', 'so.wwb.gamebox.model.company.setting.vo.ApiOrderLogVo', 1,  now(), 0, 1, 'gatherProcess', 10

 WHERE NOT EXISTS(SELECT id FROM monitor_config WHERE id = 7);

 INSERT INTO monitor_config_relation(config_id, parent_config_id, config_group_id, "desc", push_type)

 SELECT 7, NULL, 10007, 'API注单采集进度', 0

  WHERE NOT EXISTS (SELECT config_id FROM monitor_config_relation WHERE config_id = 7);


 INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)

 SELECT '510', '注单异常数据', 'report/gameTransaction/exceptionOrder.html', 'API注单异常数据处理', 5, NULL, 10, 'boss', 'maintenance:order', 1, NULL, false, true, true

  WHERE not exists(SELECT id FROM sys_resource WHERE id = 510);

DROP VIEW IF EXISTS v_sys_role;

CREATE OR REPLACE VIEW v_sys_role AS

	SELECT sr."id",

	       sr."name",

		   sr.site_id,

	       sr.subsys_code,

	       sr.built_in,

	       COALESCE(user_count, 0) as user_count

	  FROM sys_role sr

	  LEFT JOIN (SELECT role_id,

	                    count(1) as user_count

	               FROM sys_user_role

	              GROUP BY role_id) user_role ON role_id = sr."id";

COMMENT ON VIEW v_sys_role IS '角色视图 - jeff';

DROP VIEW IF EXISTS v_sub_account;

CREATE OR REPLACE VIEW v_sub_account AS

SELECT su.user_type,

       su.id,

       su.username,

       su.status,

       su.create_time,

       su.real_name,

       su.nickname,

       array_to_json(ARRAY(SELECT name FROM sys_role WHERE id IN (SELECT role_id FROM sys_user_role WHERE user_id = su.id))) as roles,

       array_to_json(ARRAY(SELECT id FROM sys_role WHERE id IN (SELECT role_id FROM sys_user_role WHERE user_id = su.id))) as role_ids,

       (SELECT CASE WHEN (count(1) > 0) THEN true ELSE false END as built_in

          FROM sys_role WHERE (id IN (SELECT role_id FROM sys_user_role WHERE user_id = su.id) AND built_in)) as built_in,

       su.owner_id,

	   su.site_id

  FROM sys_user su

 WHERE su.user_type = '01' AND su.status = ANY (ARRAY['1', '2']);

COMMENT ON VIEW v_sub_account IS 'Jeff - 子账户视图';