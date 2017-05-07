-- auto gen by jeff 2015-09-17 09:36:23
UPDATE sys_resource
SET url = 'setting/vRakebackSet/list.html',
  remark = '系统设置-返水设置'
WHERE
  ID = (
    SELECT
      ID
    FROM
      sys_resource
    WHERE
      NAME = '返水设置'
      AND parent_id = (
        SELECT
          ID
        FROM
          sys_resource
        WHERE
          NAME = '系统设置'
      )
  );

INSERT INTO "sys_resource" (
  "name",
  "url",
  "remark",
  "parent_id",
  "structure",
  "sort_num",
  "subsys_code",
  "permission",
  "resource_type",
  "icon",
  "built_in",
  "privilege"
)
VALUES
  (
    '返水设置-改变状态',
    'setting/rakebackSet/changeStatus.html',
    '系统设置-返水设置-改变状态',
    (SELECT
       id
     FROM
       sys_resource
     WHERE
       NAME = '返水设置' limit 1),
    NULL,
    '5',
    'mcenter',
    'test:view',
    '1',
    NULL,
    't',
    't'
  );

