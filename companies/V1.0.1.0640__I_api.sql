-- auto gen by linsen 2018-07-02 11:54:02
-- 棋乐游 by zain


INSERT INTO "api" ("id", "status", "order_num", "maintain_start_time", "maintain_end_time", "code", "domain", "transferable", "terminal","timezone")

SELECT '43', 'normal', '43', NULL, NULL, '43', '', 't', '0','GMT+00:00'

WHERE not EXISTS (SELECT id FROM api where id=43);



INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")

SELECT '棋乐游', 'zh_CN', '43', '', '', '', 'normal', '棋乐游'

WHERE not EXISTS(SELECT id FROM api_i18n where api_id=43 and locale='zh_CN');



INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")

SELECT '761CITY GAME', 'en_US', '43', '', '', '', 'normal', '761CITY GAME'

WHERE not EXISTS(SELECT id FROM api_i18n where api_id=43 and locale='en_US');



INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")

SELECT '棋樂遊', 'zh_TW', '43', '', '', '', 'normal', '棋樂遊'

WHERE not EXISTS(SELECT id FROM api_i18n where api_id=43 and locale='zh_TW');



INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")

SELECT '棋樂遊', 'ja_JP', '43', '', '', '', 'normal', '棋樂遊'

WHERE not EXISTS(SELECT id FROM api_i18n where api_id=43 and locale='ja_JP');



INSERT INTO"api_type_relation" ("api_id", "api_type_id", "order_num", "rebate_order_num")

SELECT '43', '5', NULL, NULL

WHERE not EXISTS(SELECT id FROM api_type_relation WHERE api_id=43 and api_type_id=5);



INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")

SELECT '43', '5', '761CITY GAME', 'en_US'

WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=43 and api_type_id=5 and local='en_US');



INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")

SELECT '43', '5', '棋樂遊', 'zh_TW'

WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=43 and api_type_id=5 and local='zh_TW');



INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")

SELECT '43', '5', '棋樂遊', 'ja_JP'

WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=43 and api_type_id=5 and local='ja_JP');



INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")

SELECT '43', '5', '棋乐游', 'zh_CN'

WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=43 and api_type_id=5 and local='zh_CN');



INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")

SELECT '43', NULL, now(), '0', now(), 'f', NULL, NULL, NULL, NULL

WHERE not EXISTS(SELECT id FROM api_order_log where api_id=43 and type='0');



INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")

SELECT '43', NULL, now(), '1', now(), 'f', NULL, NULL, NULL, NULL

WHERE not EXISTS(SELECT id FROM api_order_log where api_id=43 and type='1');



INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")

SELECT '43', NULL, now(), '2', now(), 'f', NULL, NULL, NULL, NULL

WHERE not EXISTS(SELECT id FROM api_order_log where api_id=43 and type='2');



INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")

SELECT '43', NULL, now(), '3', now(), 'f', NULL, NULL, NULL, NULL

WHERE not EXISTS(SELECT id FROM api_order_log where api_id=43 and type='5');



-- 棋牌

INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter")

SELECT '43', 'Chess', '', ''

where not EXISTS (SELECT id FROM api_gametype_relation where api_id='43' and game_type='Chess');



-- 捕鱼

INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter")

SELECT '43', 'Fish', '', ''

where not EXISTS (SELECT id FROM api_gametype_relation where api_id='43' and game_type='Fish');



-- 电子

INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter")

SELECT '43', 'Casino', '', ''

where not EXISTS (SELECT id FROM api_gametype_relation where api_id='43' and game_type='Casino');


INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430001','43','Chess','1','','normal','43001','5',NULL,NULL,'1',NULL where not exists (select id from game where id=430001);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430002','43','Chess','1','','normal','43002','5',NULL,NULL,'1',NULL where not exists (select id from game where id=430002);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430003','43','Chess','1','','normal','43003','5',NULL,NULL,'1',NULL where not exists (select id from game where id=430003);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430004','43','Chess','1','','normal','43004','5',NULL,NULL,'1',NULL where not exists (select id from game where id=430004);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430005','43','Chess','1','','normal','43005','5',NULL,NULL,'1',NULL where not exists (select id from game where id=430005);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430006','43','Chess','1','','normal','43006','5',NULL,NULL,'1',NULL where not exists (select id from game where id=430006);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430007','43','Chess','1','','normal','43007','5',NULL,NULL,'1',NULL where not exists (select id from game where id=430007);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430008','43','Chess','1','','normal','43008','5',NULL,NULL,'1',NULL where not exists (select id from game where id=430008);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430009','43','Chess','1','','normal','43001','5',NULL,NULL,'2',NULL where not exists (select id from game where id=430009);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430010','43','Chess','1','','normal','43002','5',NULL,NULL,'2',NULL where not exists (select id from game where id=430010);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430011','43','Chess','1','','normal','43003','5',NULL,NULL,'2',NULL where not exists (select id from game where id=430011);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430012','43','Chess','1','','normal','43004','5',NULL,NULL,'2',NULL where not exists (select id from game where id=430012);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430013','43','Chess','1','','normal','43005','5',NULL,NULL,'2',NULL where not exists (select id from game where id=430013);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430014','43','Chess','1','','normal','43006','5',NULL,NULL,'2',NULL where not exists (select id from game where id=430014);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430015','43','Chess','1','','normal','43007','5',NULL,NULL,'2',NULL where not exists (select id from game where id=430015);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430016','43','Chess','1','','normal','43008','5',NULL,NULL,'2',NULL where not exists (select id from game where id=430016);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430017','43','Fish','1','','normal','43009','2',NULL,NULL,'1',NULL where not exists (select id from game where id=430017);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430018','43','Fish','1','','normal','43009','2',NULL,NULL,'2',NULL where not exists (select id from game where id=430018);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430019','43','Casino','1','','normal','43010','2',NULL,NULL,'1',NULL where not exists (select id from game where id=430019);

INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '430020','43','Casino','1','','normal','43010','2',NULL,NULL,'2',NULL where not exists (select id from game where id=430020);



INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州扑克','zh_CN','430001','game/QLY/43001.jpg','','',NULL where not exists (select id from game_i18n where game_id=430001 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Texas Holdem','en_US','430001','game/QLY/43001.jpg','','',NULL where not exists (select id from game_i18n where game_id=430001 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州撲克','zh_TW','430001','game/QLY/43001.jpg','','',NULL where not exists (select id from game_i18n where game_id=430001 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州撲克','ja_JP','430001','game/QLY/43001.jpg','','',NULL where not exists (select id from game_i18n where game_id=430001 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '随机牛牛','zh_CN','430002','game/QLY/43002.jpg','','',NULL where not exists (select id from game_i18n where game_id=430002 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Niuniu','en_US','430002','game/QLY/43002.jpg','','',NULL where not exists (select id from game_i18n where game_id=430002 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '隨機牛牛','zh_TW','430002','game/QLY/43002.jpg','','',NULL where not exists (select id from game_i18n where game_id=430002 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '隨機牛牛','ja_JP','430002','game/QLY/43002.jpg','','',NULL where not exists (select id from game_i18n where game_id=430002 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牛牛','zh_CN','430003','game/QLY/43003.jpg','','',NULL where not exists (select id from game_i18n where game_id=430003 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Grap Niuniu','en_US','430003','game/QLY/43003.jpg','','',NULL where not exists (select id from game_i18n where game_id=430003 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '搶庄牛牛','zh_TW','430003','game/QLY/43003.jpg','','',NULL where not exists (select id from game_i18n where game_id=430003 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '搶庄牛牛','ja_JP','430003','game/QLY/43003.jpg','','',NULL where not exists (select id from game_i18n where game_id=430003 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛','zh_CN','430004','game/QLY/43004.jpg','','',NULL where not exists (select id from game_i18n where game_id=430004 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Tongbi Niuniu','en_US','430004','game/QLY/43004.jpg','','',NULL where not exists (select id from game_i18n where game_id=430004 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛','zh_TW','430004','game/QLY/43004.jpg','','',NULL where not exists (select id from game_i18n where game_id=430004 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛','ja_JP','430004','game/QLY/43004.jpg','','',NULL where not exists (select id from game_i18n where game_id=430004 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '龙虎','zh_CN','430005','game/QLY/43005.jpg','','',NULL where not exists (select id from game_i18n where game_id=430005 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Longhudou','en_US','430005','game/QLY/43005.jpg','','',NULL where not exists (select id from game_i18n where game_id=430005 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '龍虎','zh_TW','430005','game/QLY/43005.jpg','','',NULL where not exists (select id from game_i18n where game_id=430005 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '龍虎','ja_JP','430005','game/QLY/43005.jpg','','',NULL where not exists (select id from game_i18n where game_id=430005 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花','zh_CN','430006','game/QLY/43006.jpg','','',NULL where not exists (select id from game_i18n where game_id=430006 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Golden Flower','en_US','430006','game/QLY/43006.jpg','','',NULL where not exists (select id from game_i18n where game_id=430006 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花','zh_TW','430006','game/QLY/43006.jpg','','',NULL where not exists (select id from game_i18n where game_id=430006 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花','ja_JP','430006','game/QLY/43006.jpg','','',NULL where not exists (select id from game_i18n where game_id=430006 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '百人牛牛','zh_CN','430007','game/QLY/43007.jpg','','',NULL where not exists (select id from game_i18n where game_id=430007 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Bairen Niuniu','en_US','430007','game/QLY/43007.jpg','','',NULL where not exists (select id from game_i18n where game_id=430007 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '百人牛牛','zh_TW','430007','game/QLY/43007.jpg','','',NULL where not exists (select id from game_i18n where game_id=430007 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '百人牛牛','ja_JP','430007','game/QLY/43007.jpg','','',NULL where not exists (select id from game_i18n where game_id=430007 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '欢乐30秒','zh_CN','430008','game/QLY/43008.jpg','','',NULL where not exists (select id from game_i18n where game_id=430008 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Happy 30 Sec. ','en_US','430008','game/QLY/43008.jpg','','',NULL where not exists (select id from game_i18n where game_id=430008 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '歡樂30秒','zh_TW','430008','game/QLY/43008.jpg','','',NULL where not exists (select id from game_i18n where game_id=430008 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '歡樂30秒','ja_JP','430008','game/QLY/43008.jpg','','',NULL where not exists (select id from game_i18n where game_id=430008 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州扑克','zh_CN','430009','game/QLY/43001.jpg','','',NULL where not exists (select id from game_i18n where game_id=430009 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Texas Holdem','en_US','430009','game/QLY/43001.jpg','','',NULL where not exists (select id from game_i18n where game_id=430009 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州撲克','zh_TW','430009','game/QLY/43001.jpg','','',NULL where not exists (select id from game_i18n where game_id=430009 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州撲克','ja_JP','430009','game/QLY/43001.jpg','','',NULL where not exists (select id from game_i18n where game_id=430009 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '随机牛牛','zh_CN','430010','game/QLY/43002.jpg','','',NULL where not exists (select id from game_i18n where game_id=430010 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Niuniu','en_US','430010','game/QLY/43002.jpg','','',NULL where not exists (select id from game_i18n where game_id=430010 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '隨機牛牛','zh_TW','430010','game/QLY/43002.jpg','','',NULL where not exists (select id from game_i18n where game_id=430010 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '隨機牛牛','ja_JP','430010','game/QLY/43002.jpg','','',NULL where not exists (select id from game_i18n where game_id=430010 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牛牛','zh_CN','430011','game/QLY/43003.jpg','','',NULL where not exists (select id from game_i18n where game_id=430011 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Grap Niuniu','en_US','430011','game/QLY/43003.jpg','','',NULL where not exists (select id from game_i18n where game_id=430011 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '搶庄牛牛','zh_TW','430011','game/QLY/43003.jpg','','',NULL where not exists (select id from game_i18n where game_id=430011 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '搶庄牛牛','ja_JP','430011','game/QLY/43003.jpg','','',NULL where not exists (select id from game_i18n where game_id=430011 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛','zh_CN','430012','game/QLY/43004.jpg','','',NULL where not exists (select id from game_i18n where game_id=430012 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Tongbi Niuniu','en_US','430012','game/QLY/43004.jpg','','',NULL where not exists (select id from game_i18n where game_id=430012 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛','zh_TW','430012','game/QLY/43004.jpg','','',NULL where not exists (select id from game_i18n where game_id=430012 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛','ja_JP','430012','game/QLY/43004.jpg','','',NULL where not exists (select id from game_i18n where game_id=430012 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '龙虎','zh_CN','430013','game/QLY/43005.jpg','','',NULL where not exists (select id from game_i18n where game_id=430013 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Longhudou','en_US','430013','game/QLY/43005.jpg','','',NULL where not exists (select id from game_i18n where game_id=430013 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '龍虎','zh_TW','430013','game/QLY/43005.jpg','','',NULL where not exists (select id from game_i18n where game_id=430013 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '龍虎','ja_JP','430013','game/QLY/43005.jpg','','',NULL where not exists (select id from game_i18n where game_id=430013 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花','zh_CN','430014','game/QLY/43006.jpg','','',NULL where not exists (select id from game_i18n where game_id=430014 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Golden Flower','en_US','430014','game/QLY/43006.jpg','','',NULL where not exists (select id from game_i18n where game_id=430014 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花','zh_TW','430014','game/QLY/43006.jpg','','',NULL where not exists (select id from game_i18n where game_id=430014 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花','ja_JP','430014','game/QLY/43006.jpg','','',NULL where not exists (select id from game_i18n where game_id=430014 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '百人牛牛','zh_CN','430015','game/QLY/43007.jpg','','',NULL where not exists (select id from game_i18n where game_id=430015 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Bairen Niuniu','en_US','430015','game/QLY/43007.jpg','','',NULL where not exists (select id from game_i18n where game_id=430015 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '百人牛牛','zh_TW','430015','game/QLY/43007.jpg','','',NULL where not exists (select id from game_i18n where game_id=430015 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '百人牛牛','ja_JP','430015','game/QLY/43007.jpg','','',NULL where not exists (select id from game_i18n where game_id=430015 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '欢乐30秒','zh_CN','430016','game/QLY/43008.jpg','','',NULL where not exists (select id from game_i18n where game_id=430016 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Happy 30 Sec. ','en_US','430016','game/QLY/43008.jpg','','',NULL where not exists (select id from game_i18n where game_id=430016 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '歡樂30秒','zh_TW','430016','game/QLY/43008.jpg','','',NULL where not exists (select id from game_i18n where game_id=430016 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '歡樂30秒','ja_JP','430016','game/QLY/43008.jpg','','',NULL where not exists (select id from game_i18n where game_id=430016 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '李逵捕鱼','zh_CN','430017','game/QLY/43009.jpg','','',NULL where not exists (select id from game_i18n where game_id=430017 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '761 Finshing','en_US','430017','game/QLY/43009.jpg','','',NULL where not exists (select id from game_i18n where game_id=430017 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '李逵捕魚','zh_TW','430017','game/QLY/43009.jpg','','',NULL where not exists (select id from game_i18n where game_id=430017 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '李逵捕魚','ja_JP','430017','game/QLY/43009.jpg','','',NULL where not exists (select id from game_i18n where game_id=430017 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '李逵捕鱼','zh_CN','430018','game/QLY/43009.jpg','','',NULL where not exists (select id from game_i18n where game_id=430018 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '761 Finshing','en_US','430018','game/QLY/43009.jpg','','',NULL where not exists (select id from game_i18n where game_id=430018 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '李逵捕魚','zh_TW','430018','game/QLY/43009.jpg','','',NULL where not exists (select id from game_i18n where game_id=430018 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '李逵捕魚','ja_JP','430018','game/QLY/43009.jpg','','',NULL where not exists (select id from game_i18n where game_id=430018 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '奔驰宝马','zh_CN','430019','game/QLY/43010.jpg','','',NULL where not exists (select id from game_i18n where game_id=430019 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Benz & BMW','en_US','430019','game/QLY/43010.jpg','','',NULL where not exists (select id from game_i18n where game_id=430019 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '奔馳寶馬','zh_TW','430019','game/QLY/43010.jpg','','',NULL where not exists (select id from game_i18n where game_id=430019 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '奔馳寶馬','ja_JP','430019','game/QLY/43010.jpg','','',NULL where not exists (select id from game_i18n where game_id=430019 and locale='ja_JP');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '奔驰宝马','zh_CN','430020','game/QLY/43010.jpg','','',NULL where not exists (select id from game_i18n where game_id=430020 and locale='zh_CN');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select 'Benz & BMW','en_US','430020','game/QLY/43010.jpg','','',NULL where not exists (select id from game_i18n where game_id=430020 and locale='en_US');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '奔馳寶馬','zh_TW','430020','game/QLY/43010.jpg','','',NULL where not exists (select id from game_i18n where game_id=430020 and locale='zh_TW');

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '奔馳寶馬','ja_JP','430020','game/QLY/43010.jpg','','',NULL where not exists (select id from game_i18n where game_id=430020 and locale='ja_JP');



INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_type', 'Chess', 'en_US', 'Chess', '0', '', '', 't', NULL
where not EXISTS (SELECT id FROM site_i18n where module='setting' and type='game_type' and key='Chess' and locale='en_US');


INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_type', 'Chess', 'zh_CN', '棋牌', '0', '', '', 't', NULL
where not EXISTS (SELECT id FROM site_i18n where module='setting' and type='game_type' and key='Chess' and locale='zh_CN');


INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_type', 'Chess', 'zh_TW', '棋牌', '0', '', '', 't', NULL
where not EXISTS (SELECT id FROM site_i18n where module='setting' and type='game_type' and key='Chess' and locale='zh_TW');


INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_type', 'Chess', 'ja_JP', '棋牌', '0', '', NULL, 't', NULL
where not EXISTS (SELECT id FROM site_i18n where module='setting' and type='game_type' and key='Chess' and locale='ja_JP');


INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_type', 'Fish', 'en_US', 'Fish', '0', '', '', 't', NULL
where not EXISTS (SELECT id FROM site_i18n where module='setting' and type='game_type' and key='Fish' and locale='en_US');


INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_type', 'Fish', 'zh_CN', '捕鱼', '0', '', '', 't', NULL
where not EXISTS (SELECT id FROM site_i18n where module='setting' and type='game_type' and key='Fish' and locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_type', 'Fish', 'zh_TW', '捕鱼', '0', '', '', 't', NULL
where not EXISTS (SELECT id FROM site_i18n where module='setting' and type='game_type' and key='Fish' and locale='zh_TW');


INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_type', 'Fish', 'ja_JP', '捕鱼', '0', '', NULL, 't', NULL
where not EXISTS (SELECT id FROM site_i18n where module='setting' and type='game_type' and key='Fish' and locale='ja_JP');