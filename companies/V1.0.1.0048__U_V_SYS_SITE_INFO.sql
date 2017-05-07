-- auto gen by tom 2016-03-08 15:59:06
drop view if EXISTS v_sys_site_info;
CREATE OR REPLACE VIEW "v_sys_site_info" AS
 SELECT ss.id AS siteid,
    (( SELECT si.value
           FROM site_i18n si
          WHERE (((((si.site_id = ss.id) AND (si.locale = (um.default_locale)::bpchar)) AND ((si.type)::text = 'site_name'::text)) AND ((si.module)::text = 'setting'::text)) AND ((si.key)::text = 'name'::text))
         LIMIT 1))::character varying(100) AS sitename,
    um.id AS masterid,
    um.username AS mastername,
    um.user_type AS usertype,
    um.subsys_code AS subsyscode,
    uc.id AS operationid,
    uc.username AS operationname,
    uc.user_type AS operationusertype,
    uc.subsys_code AS operationsubsyscode
   FROM ((sys_site ss
     LEFT JOIN sys_user um ON ((ss.sys_user_id = um.id)))
     LEFT JOIN sys_user uc ON ((ss.parent_id = uc.id)))
  WHERE (((um.user_type)::text = '2'::text) AND (((uc.user_type)::text = '1'::text) OR ((uc.user_type)::text = '11'::text)))
  ORDER BY ss.id;

ALTER TABLE "v_sys_site_info" OWNER TO "postgres";

COMMENT ON VIEW "v_sys_site_info" IS '站点信息视图 — Fly';
