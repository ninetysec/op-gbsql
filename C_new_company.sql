-- gb-companies 新建运营商脚本

--Step--
--1) login boss,create one Companies User,then get the ID
--2) change sys_site insert value
--    id sys_user_id name code
--3) search and update sys_site id
--4) search and update sys_domain
--    id domain
--5) change site_i18n
--    remark default_value

--username: swadmin
--运营商账号id 站点id 官网地址 域名id 需同步修改
INSERT INTO "sys_site" ("id", "sys_user_id", "name", "theme", "sso_theme", "status", "is_buildin", "postfix",
                        "short_name", "main_currency", "main_language", "web_site", "opening_time", "timezone",
                        "traffic_statistics", "code", "logo_path", "parent_id", "site_classify_key", "site_net_scheme_id",
                        "max_profit", "deposit", "template_code", "maintain_start_time", "maintain_end_time", "maintain_reason",
                        "maintain_operate_id", "maintain_operate_time", "import_players_time")
VALUES ('-6', '313', '试玩运营商', '', 'ccenter', '1', 'f', '@swpt', '试玩', 'CNY', 'zh_CN', 'swpt.gbccenter.com',
                                                                                      now(), 'GMT+08:00', '', 'swpt', 'Logo/1/1440489057635.jpg', '0', 'zy', '1', NULL, NULL, '', NULL, NULL, '', NULL, NULL, NULL);

UPDATE sys_user  SET site_id='-5' WHERE id='313';

INSERT INTO "sys_domain" ("id", "sys_user_id", "domain", "is_default", "is_enable", "is_deleted", "sort", "site_id",
                          "subsys_code", "create_user", "create_time", "update_user", "update_time", "is_for_all_rank",
                          "page_url", "name", "agent_id", "resolve_status", "build_in", "is_temp", "code")
VALUES ('-9', '313', 'swpt.gbccenter.com', 'f', 't', 'f', NULL, '-6', 'ccenter', '0', now(), NULL, NULL, NULL, '/index.html', '', NULL, '5', 'f', 't', '');
INSERT INTO "site_operate_area" ("site_id", "code", "status", "area_ip", "open_time") VALUES ('-6', 'CN', '1', '', NULL);
INSERT INTO "site_language" ("site_id", "language", "status", "logo", "open_time") VALUES ('-6', 'zh_TW', '1', 'images/language/traditional-chinese.png', now());
INSERT INTO "site_language" ("site_id", "language", "status", "logo", "open_time") VALUES ('-6', 'en_US', '1', 'images/language/england.png', now());
INSERT INTO "site_language" ("site_id", "language", "status", "logo", "open_time") VALUES ('-6', 'zh_CN', '1', 'images/language/simplified-chinese.png', now());
INSERT INTO "site_currency" ("site_id", "code", "status") VALUES ('-6', 'CNY', '1');
INSERT INTO "site_customer_service" ("id", "site_id", "code", "name", "parameter", "status", "create_time", "create_user", "built_in") VALUES ('-6', '-6', 'K001', '默认客服', '', 't', now(), '0', 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__") VALUES ('setting', 'site_name', 'name', 'zh_CN', '试玩', '-6', '试玩', '', 't', '');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__") VALUES ('setting', 'site_name', 'name', 'en_US', '试玩', '-6', '试玩', '', 't', '');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__") VALUES ('setting', 'site_name', 'name', 'zh_TW', '试玩', '-6', '试玩', '', 't', '');

