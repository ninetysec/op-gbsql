-- auto gen by tom 2015-12-21 11:49:51
drop VIEW if EXISTS v_contract_scheme;

CREATE OR REPLACE VIEW "v_contract_scheme" AS
 SELECT cs.id,
    cs.ensure_consume,
    cs.maintenance_charges,
    cs.status,
    cs.create_time,
    cs.update_time,
    si.locale,
    si.value AS scheme_name,
    ( SELECT count(1) AS count
           FROM contract_api ca
          WHERE ((ca.contract_scheme_id = cs.id) AND (ca.is_assume = true))) AS t_num,
    ( SELECT count(1) AS count
           FROM contract_api ca
          WHERE ((ca.contract_scheme_id = cs.id) AND (ca.is_assume = false))) AS f_num,
    ( SELECT min(coa.ratio) AS min
           FROM (contract_api ca
             LEFT JOIN contract_occupy_api coa ON ((ca.id = coa.api_id)))
          WHERE (ca.contract_scheme_id = cs.id)) AS minratio,
    ( SELECT contract_favourable.id
           FROM contract_favourable
          WHERE ((contract_favourable.contract_scheme_id = cs.id) AND ((contract_favourable.favourable_type)::text = '1'::text))
         LIMIT 1) AS type_1_id,
    ( SELECT contract_favourable.id
           FROM contract_favourable
          WHERE ((contract_favourable.contract_scheme_id = cs.id) AND ((contract_favourable.favourable_type)::text = '2'::text))
         LIMIT 1) AS type_2_id,
    ( SELECT count(1) AS count
           FROM site_contract_scheme
          WHERE (site_contract_scheme.contract_scheme_id = cs.id)) AS center_choose_num,
    ( SELECT count(1) AS count
           FROM sys_site
          WHERE (sys_site.site_net_scheme_id = cs.id)) AS site_choose_num
   FROM (contract_scheme cs
     JOIN ( SELECT site_i18n.id,
            site_i18n.module,
            site_i18n.type,
            site_i18n.key,
            site_i18n.locale,
            site_i18n.value,
            site_i18n.site_id,
            site_i18n.remark,
            site_i18n.default_value,
            site_i18n.built_in
           FROM site_i18n
          WHERE (((site_i18n.module)::text = 'boss'::text) AND ((site_i18n.type)::text = 'contract_scheme'::text))) si ON ((cs.id = (si.key)::integer)));

ALTER TABLE "v_contract_scheme" OWNER TO "postgres";

COMMENT ON VIEW "v_contract_scheme" IS '包网方案查询视图--TOM';