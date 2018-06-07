-- auto gen by steffan 2018-05-28 09:21:13
INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '978', 'date', 'date', 'f', NULL, NULL, '', '', '217', '', 'BB-注单日期', '', ''
WHERE 978 NOT IN(SELECT id FROM game_api_interface_request WHERE id=978);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '979', 'date', 'date', 'f', NULL, NULL, '', '', '218', '', 'BB-注单日期', '', ''
WHERE 979 NOT IN(SELECT id FROM game_api_interface_request WHERE id=979);