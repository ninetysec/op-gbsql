-- auto gen by admin 2016-06-27 14:44:19
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
 WHERE su.user_type = '11' AND su.status = ANY (ARRAY['1', '2']);

ALTER TABLE v_sub_account OWNER TO "gb-companies";
COMMENT ON VIEW v_sub_account IS 'Jeff - 子账户视图';

INSERT INTO site_i18n("module", "type", "key", locale, "value", site_id, remark, default_value, built_in)
SELECT 'setting', 'site_name', 'name', 'zh_CN', '宏图', '-2', '运营商名称zh_CN', NULL, 'f'
WHERE '宏图' NOT IN (SELECT value FROM site_i18n where module = 'setting' AND type = 'site_name' AND locale = 'zh_CN');
INSERT INTO site_i18n("module", "type", "key", locale, "value", site_id, remark, default_value, built_in)
SELECT 'setting', 'site_name', 'name', 'zh_TW', '宏圖', '-2', '运营商名称zh_TW', NULL, 'f'
WHERE '宏圖' NOT IN (SELECT value FROM site_i18n where module = 'setting' AND type = 'site_name' AND locale = 'zh_TW');
INSERT INTO site_i18n("module", "type", "key", locale, "value", site_id, remark, default_value, built_in)
SELECT 'setting', 'site_name', 'name', 'en_US', 'HongTu', '-2', '运营商名称en_US', NULL, 'f'
WHERE 'HongTu' NOT IN (SELECT value FROM site_i18n where module = 'setting' AND type = 'site_name' AND locale = 'en_US');