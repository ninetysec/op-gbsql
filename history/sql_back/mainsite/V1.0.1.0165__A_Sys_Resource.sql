-- auto gen by tony 2015-12-18 17:43:13
select redo_sqls($$
  ALTER TABLE "sys_resource"
  ADD COLUMN "status" bool DEFAULT false;
$$);
COMMENT ON COLUMN "sys_resource"."status" IS '菜单是否启用';

DROP VIEW v_sys_user_resource;

CREATE OR REPLACE VIEW v_sys_user_resource AS
 SELECT res.id,
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

  update sys_resource set status=true;


update sys_resource set status=false where name in('首页') and subsys_code='ccenter';
