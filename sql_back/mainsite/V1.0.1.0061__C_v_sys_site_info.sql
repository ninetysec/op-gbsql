-- auto gen by Lins 2015-11-04 02:45:55
/**
创建站点相关基础信息
 */
CREATE OR REPLACE VIEW "v_sys_site_info" AS
 SELECT s.id AS siteid,
    s.name AS sitename,
    u.id AS masterid,
    u.username AS mastername,
    u.user_type AS usertype,
    u.subsys_code AS subsyscode,
    op.id AS operationid,
    op.username AS operationname,
    op.user_type AS operationusertype,
    op.subsys_code AS operationsubsyscode
   FROM ((sys_site s
     JOIN sys_user u ON ((s.sys_user_id = u.id)))
     LEFT JOIN sys_user op ON ((u.owner_id = op.id)))
  WHERE ((u.user_type)::text = '2'::text);

ALTER TABLE "v_sys_site_info" OWNER TO "postgres";
