-- auto gen by tom 2016-03-17 09:39:25
 SELECT cs.id,
    cs.ensure_consume,
    cs.maintenance_charges,
    cs.status,
    cs.create_time,
    cs.update_time,
    scs.center_id,
    ( SELECT count(1) AS count
           FROM contract_api ca
          WHERE ((ca.contract_scheme_id = cs.id) AND (ca.is_assume = true))) AS t_num,
    ( SELECT count(1) AS count
           FROM contract_api ca
          WHERE ((ca.contract_scheme_id = cs.id) AND (ca.is_assume = false))) AS f_num,
    ( SELECT min(coa.ratio) AS min
           FROM (contract_occupy_grads cog
             JOIN contract_occupy_api coa ON ((coa.contract_occupy_grads_id = cog.id)))
          WHERE (cog.contract_scheme_id = cs.id)) AS minratio,
    ( SELECT contract_favourable.id
           FROM contract_favourable
          WHERE ((contract_favourable.contract_scheme_id = cs.id) AND ((contract_favourable.favourable_type)::text = '1'::text))
         LIMIT 1) AS type_1_id,
    ( SELECT contract_favourable.id
           FROM contract_favourable
          WHERE ((contract_favourable.contract_scheme_id = cs.id) AND ((contract_favourable.favourable_type)::text = '2'::text))
         LIMIT 1) AS type_2_id,
    ( SELECT count(1) AS count
           FROM sys_site
          WHERE (sys_site.site_net_scheme_id = cs.id)) AS site_choose_num,
    ( SELECT max(coa.ratio) AS max
           FROM (contract_occupy_grads cog
             LEFT JOIN contract_occupy_api coa ON ((coa.contract_occupy_grads_id = cog.id)))
          WHERE (cog.contract_scheme_id = cs.id)) AS maxratio
   FROM (contract_scheme cs
     JOIN site_contract_scheme scs ON ((cs.id = scs.contract_scheme_id)));
