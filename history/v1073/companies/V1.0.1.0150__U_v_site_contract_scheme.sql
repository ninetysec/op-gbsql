-- auto gen by fei 2016-08-17 21:50:59
drop view if exists v_site_contract_scheme;
CREATE OR REPLACE VIEW "v_site_contract_scheme" AS 
 SELECT cs.id,
    cs.ensure_consume,
    cs.maintenance_charges,
    cs.status,
    cs.create_time,
    cs.update_time,
    ss.center_id,
    (SELECT count(1) AS count
           FROM contract_api
          WHERE contract_api.contract_scheme_id = cs.id AND contract_api.is_assume = true) AS t_num,
    (SELECT count(1) AS count
           FROM contract_api
          WHERE contract_api.contract_scheme_id = cs.id AND contract_api.is_assume = false) AS f_num,
    ( SELECT min(coa.ratio) AS min
           FROM contract_api ca
             LEFT JOIN contract_occupy_api coa ON ca.api_id = coa.api_id
          WHERE ca.contract_scheme_id = cs.id) AS minratio,
    (SELECT contract_favourable.id
           FROM contract_favourable
          WHERE contract_favourable.contract_scheme_id = cs.id AND contract_favourable.favourable_type = '1'
         LIMIT 1) AS type_1_id,
    (SELECT contract_favourable.id
           FROM contract_favourable
          WHERE contract_favourable.contract_scheme_id = cs.id AND contract_favourable.favourable_type = '2'
         LIMIT 1) AS type_2_id,
    (SELECT count(1) AS count
           FROM sys_site
          WHERE sys_site.site_net_scheme_id = cs.id AND sys_site.parent_id = ss.center_id) AS site_choose_num,
    (SELECT MAX(coa.ratio)
          FROM contract_occupy_grads cog 
          LEFT JOIN contract_occupy_api coa ON cog."id" = coa.contract_occupy_grads_id
          LEFT JOIN api api ON coa.api_id = api."id" 
         WHERE api.status <> 'disable'
   AND cog.contract_scheme_id = cs."id") AS maxratio
   FROM contract_scheme cs
     JOIN site_contract_scheme ss ON cs.id = ss.contract_scheme_id;

ALTER TABLE "v_site_contract_scheme" OWNER TO "gb-companies";
