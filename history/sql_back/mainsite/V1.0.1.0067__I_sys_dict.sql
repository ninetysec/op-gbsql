-- auto gen by cheery 2015-11-09 07:05:37
INSERT INTO "sys_dict" (
  "module",
  "dict_type",
  "dict_code",
  "order_num",
  "remark",
  "parent_code",
  "active"
)

  SELECT
    'content',
    'carousel_type',
    'carousel_type_index',
    '1',
    '广告类别-首页',
    NULL,
    't'
  where 'carousel_type_index' not in (
    SELECT dict_code from sys_dict where module = 'content' and dict_type = 'carousel_type'

  );
UPDATE "sys_dict" SET active = false WHERE "dict_type" = 'carousel_state' AND "module" = 'content' AND "dict_code" = 'stop';