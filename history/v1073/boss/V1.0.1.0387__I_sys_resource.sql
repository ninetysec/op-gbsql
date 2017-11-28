-- auto gen by tony 2017-07-25 10:19:13
INSERT INTO "sys_resource" ( "id","name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '30617','纯彩票站', '', '启用禁用纯彩票站', '306', '', '15', 'boss', 'platform:site_is_lottery', '2', '', 'f', 't', 't' WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id='30617' AND name='纯彩票站' AND parent_id='306' AND permission='platform:site_is_lottery');

