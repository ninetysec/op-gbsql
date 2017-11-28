-- auto gen by tony 2015-12-25 07:35:55
DROP VIEW v_sys_user_resource;

CREATE OR REPLACE VIEW v_sys_user_resource AS
 SELECT distinct res.id,
    u.id AS user_id,
    u.username,
    u.user_type,
    u.subsys_code,
    u.site_id,
    res.url AS resource_url,
    res.remark AS resource_remark,
    res.parent_id AS resource_parent_id,
    res.structure AS resource_structure,
    res.sort_num AS resource_sort_num,
    res.resource_type,
    res.permission,
    res.name AS resource_name,
    res.icon AS resource_icon,
    res.privilege,
    res.status
   FROM sys_user u
     LEFT JOIN sys_user_role ur ON u.id = ur.user_id
     LEFT JOIN sys_role r ON ur.role_id = r.id
     LEFT JOIN sys_role_resource rr ON r.id = rr.role_id
     LEFT JOIN sys_resource res ON rr.resource_id = res.id;

ALTER TABLE v_sys_user_resource
  OWNER TO postgres;