CREATE OR REPLACE FUNCTION gb_gen_sys_role_resource ()
 RETURNS void
 LANGUAGE plpgsql
AS $function$

DECLARE

  n_count INT;

BEGIN

  WITH RECURSIVE t AS
  (
    SELECT id, parent_id, array_agg(id) ids, name::text FROM sys_resource WHERE parent_id IS NULL GROUP BY id, name
      UNION ALL
    SELECT s.id, s.parent_id, array_append(t.ids, s.id) ids, t.name || '-' || s.name FROM sys_resource s, t WHERE s.parent_id = t.id
  )
  --SELECT * FROM t;
  ,
  r AS (
    INSERT INTO sys_role ( name, status, create_user, create_time, subsys_code, built_in, site_id)
    SELECT name, '1', '0', NOW(), 'boss', 'f', '0' FROM t WHERE parent_id IS NOT NULL AND name NOT IN ( SELECT name FROM sys_role)
    RETURNING *
  )
  INSERT INTO sys_role_resource ( role_id, resource_id)
  SELECT DISTINCT r.id, tt.resource_id
  FROM r, ( SELECT name, unnest(t.ids) resource_id FROM t ) tt
  WHERE r.name = tt.name
  AND NOT EXISTS ( SELECT 1 FROM sys_role_resource sr WHERE sr.role_id = r.id AND sr.resource_id = tt.resource_id);

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice 'sys_role_resource 本次新增记录数 %', n_count;

END;
$function$
;

COMMENT ON FUNCTION gb_gen_sys_role_resource ()
IS 'Laser-同步角色资源表';
