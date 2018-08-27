-- auto gen by linsen 2018-08-27 11:15:14
-- 棋乐游 by snow

-- 1.api表
INSERT INTO "api" ("id", "status", "order_num", "maintain_start_time", "maintain_end_time", "code", "domain", "transferable", "terminal","timezone")
  SELECT '46', 'normal', '46', NULL, NULL, '46', '', 't', '0','GMT+08:00'
  WHERE not EXISTS (SELECT id FROM api where id=46);

-- 2.api_i18n表
INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")  SELECT '乐游棋牌', 'zh_CN', '46', '', '', '', 'normal', '乐游棋牌'  WHERE not EXISTS(SELECT id FROM api_i18n where api_id=46 and locale='zh_CN');
INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content") SELECT 'LEG Chess', 'en_US', '46', '', '', '', 'normal', 'LEG Chess' WHERE not EXISTS(SELECT id FROM api_i18n where api_id=46 and locale='en_US');
INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content") SELECT '樂遊棋牌', 'zh_TW', '46', '', '', '', 'normal', '樂遊棋牌'   WHERE not EXISTS(SELECT id FROM api_i18n where api_id=46 and locale='zh_TW');
INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content") SELECT '将棋を楽しむ', 'ja_JP', '46', '', '', '', 'normal', '将棋を楽しむ'  WHERE not EXISTS(SELECT id FROM api_i18n where api_id=46 and locale='ja_JP');


-- 3.配置游戏类型 api_type_relation
INSERT INTO"api_type_relation" ("api_id", "api_type_id", "order_num", "rebate_order_num")
  SELECT '46', '5', NULL, NULL WHERE not EXISTS(SELECT id FROM api_type_relation WHERE api_id=46 and api_type_id=5);


-- 4. 配置游戏类型国际化 api_type_relation_i18n
INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local") SELECT '46', '5', 'LEG  Chess', 'en_US' WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=46 and api_type_id=5 and local='en_US');
INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local") SELECT '46', '5', '樂遊棋牌', 'zh_TW'    WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=46 and api_type_id=5 and local='zh_TW');
INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")SELECT '46', '5', '将棋を楽しむ', 'ja_JP' WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=46 and api_type_id=5 and local='ja_JP');
INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local") SELECT '46', '5', '乐游棋牌', 'zh_CN'   WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=46 and api_type_id=5 and local='zh_CN');


--5. API和游戏类型关系表 api_gametype_relation
INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter")
  SELECT '46', 'Chess', '', '' where not EXISTS (SELECT id FROM api_gametype_relation where api_id='46' and game_type='Chess');


--6.游戏表 game
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460001','46','Chess','1','','normal','620','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460001);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460002','46','Chess','1','','normal','720','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460002);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460003','46','Chess','1','','normal','830','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460003);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460004','46','Chess','1','','normal','220','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460004);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460005','46','Chess','1','','normal','860','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460005);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460006','46','Chess','1','','normal','900','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460006);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460007','46','Chess','1','','normal','600','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460007);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460008','46','Chess','1','','normal','870','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460008);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460009','46','Chess','1','','normal','880','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460009);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460010','46','Chess','1','','normal','230','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460010);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460011','46','Chess','1','','normal','730','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460011);
INSERT INTO game (id, api_id, game_type, order_num, url, status, code, api_type_id, maintain_start_time, maintain_end_time, support_terminal, can_try) select '460012','46','Chess','1','','normal','610','5',NULL,NULL,'1',NULL where not exists (select id from game where id=460012);


--7.游戏表 game_i18n

INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州扑克','zh_CN','460001','game/LEG/mobile-pc-dzpk.png','','',NULL where not exists (select id from game_i18n where game_id=460001 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州扑克','zh_TW','460001','game/LEG/mobile-pc-dzpk.png','','',NULL where not exists (select id from game_i18n where game_id=460001 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州扑克','en_US','460001','game/LEG/mobile-pc-dzpk.png','','',NULL where not exists (select id from game_i18n where game_id=460001 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '德州扑克','ja_JP','460001','game/LEG/mobile-pc-dzpk.png','','',NULL where not exists (select id from game_i18n where game_id=460001 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '二八杠','zh_CN','460002','game/LEG/mobile-pc-erba.png','','',NULL where not exists (select id from game_i18n where game_id=460002 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '二八杠','zh_TW','460002','game/LEG/mobile-pc-erba.png','','',NULL where not exists (select id from game_i18n where game_id=460002 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '二八杠','en_US','460002','game/LEG/mobile-pc-erba.png','','',NULL where not exists (select id from game_i18n where game_id=460002 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '二八杠', 'ja_JP','460002','game/LEG/mobile-pc-erba.png','','',NULL where not exists (select id from game_i18n where game_id=460002 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牛牛','zh_CN','460003','game/LEG/mobile-pc-qznn.png','','',NULL where not exists (select id from game_i18n where game_id=460003 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牛牛','zh_TW','460003','game/LEG/mobile-pc-qznn.png','','',NULL where not exists (select id from game_i18n where game_id=460003 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牛牛','en_US','460003','game/LEG/mobile-pc-qznn.png','','',NULL where not exists (select id from game_i18n where game_id=460003 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牛牛', 'ja_JP','460003','game/LEG/mobile-pc-qznn.png','','',NULL where not exists (select id from game_i18n where game_id=460003 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花','zh_CN','460004','game/LEG/mobile-pc-zhajinhua.png','','',NULL where not exists (select id from game_i18n where game_id=460004 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花','zh_TW','460004','game/LEG/mobile-pc-zhajinhua.png','','',NULL where not exists (select id from game_i18n where game_id=460004 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花','en_US','460004','game/LEG/mobile-pc-zhajinhua.png','','',NULL where not exists (select id from game_i18n where game_id=460004 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '炸金花', 'ja_JP','460004','game/LEG/mobile-pc-zhajinhua.png','','',NULL where not exists (select id from game_i18n where game_id=460004 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '三公','zh_CN','460005','game/LEG/mobile-pc-sangong.png','','',NULL where not exists (select id from game_i18n where game_id=460005 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '三公','zh_TW','460005','game/LEG/mobile-pc-sangong.png','','',NULL where not exists (select id from game_i18n where game_id=460005 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '三公','en_US','460005','game/LEG/mobile-pc-sangong.png','','',NULL where not exists (select id from game_i18n where game_id=460005 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '三公', 'ja_JP','460005','game/LEG/mobile-pc-sangong.png','','',NULL where not exists (select id from game_i18n where game_id=460005 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '押庄龙虎','zh_CN','460006','game/LEG/mobile-pc-yzlh.png','','',NULL where not exists (select id from game_i18n where game_id=460006 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '押庄龙虎','zh_TW','460006','game/LEG/mobile-pc-yzlh.png','','',NULL where not exists (select id from game_i18n where game_id=460006 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '押庄龙虎','en_US','460006','game/LEG/mobile-pc-yzlh.png','','',NULL where not exists (select id from game_i18n where game_id=460006 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '押庄龙虎', 'ja_JP','460006','game/LEG/mobile-pc-yzlh.png','','',NULL where not exists (select id from game_i18n where game_id=460006 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '21 点','zh_CN','460007','game/LEG/mobile-pc-21d.png','','',NULL where not exists (select id from game_i18n where game_id=460007 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '21 点','zh_TW','460007','game/LEG/mobile-pc-21d.png','','',NULL where not exists (select id from game_i18n where game_id=460007 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '21 点','en_US','460007','game/LEG/mobile-pc-21d.png','','',NULL where not exists (select id from game_i18n where game_id=460007 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '21 点', 'ja_JP','460007','game/LEG/mobile-pc-21d.png','','',NULL where not exists (select id from game_i18n where game_id=460007 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛','zh_CN','460008','game/LEG/mobile-pc-tbnn.png','','',NULL where not exists (select id from game_i18n where game_id=460008 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛','zh_TW','460008','game/LEG/mobile-pc-tbnn.png','','',NULL where not exists (select id from game_i18n where game_id=460008 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛','en_US','460008','game/LEG/mobile-pc-tbnn.png','','',NULL where not exists (select id from game_i18n where game_id=460008 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '通比牛牛', 'ja_JP','460008','game/LEG/mobile-pc-tbnn.png','','',NULL where not exists (select id from game_i18n where game_id=460008 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '欢乐红包','zh_CN','460009','game/LEG/mobile-pc-hlhb.png','','',NULL where not exists (select id from game_i18n where game_id=460009 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '欢乐红包','zh_TW','460009','game/LEG/mobile-pc-hlhb.png','','',NULL where not exists (select id from game_i18n where game_id=460009 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '欢乐红包','en_US','460009','game/LEG/mobile-pc-hlhb.png','','',NULL where not exists (select id from game_i18n where game_id=460009 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '欢乐红包', 'ja_JP','460009','game/LEG/mobile-pc-hlhb.png','','',NULL where not exists (select id from game_i18n where game_id=460009 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '极速炸金花','zh_CN','460010','game/LEG/mobile-pc-jszjh.png','','',NULL where not exists (select id from game_i18n where game_id=460010 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '极速炸金花','zh_TW','460010','game/LEG/mobile-pc-jszjh.png','','',NULL where not exists (select id from game_i18n where game_id=460010 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '极速炸金花','en_US','460010','game/LEG/mobile-pc-jszjh.png','','',NULL where not exists (select id from game_i18n where game_id=460010 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '极速炸金花', 'ja_JP','460010','game/LEG/mobile-pc-jszjh.png','','',NULL where not exists (select id from game_i18n where game_id=460010 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牌九','zh_CN','460011','game/LEG/mobile-pc-pj.png','','',NULL where not exists (select id from game_i18n where game_id=460011 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牌九','zh_TW','460011','game/LEG/mobile-pc-pj.png','','',NULL where not exists (select id from game_i18n where game_id=460011 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牌九','en_US','460011','game/LEG/mobile-pc-pj.png','','',NULL where not exists (select id from game_i18n where game_id=460011 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '抢庄牌九', 'ja_JP','460011','game/LEG/mobile-pc-pj.png','','',NULL where not exists (select id from game_i18n where game_id=460011 and locale='ja_JP');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '斗地主','zh_CN','460012','game/LEG/mobile-pc-ddz.png','','',NULL where not exists (select id from game_i18n where game_id=460012 and locale='zh_CN');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '斗地主','zh_TW','460012','game/LEG/mobile-pc-ddz.png','','',NULL where not exists (select id from game_i18n where game_id=460012 and locale='zh_TW');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '斗地主','en_US','460012','game/LEG/mobile-pc-ddz.png','','',NULL where not exists (select id from game_i18n where game_id=460012 and locale='en_US');
INSERT INTO game_i18n (name, locale, game_id, cover, introduce_status, game_introduce, backup_cover) select '斗地主', 'ja_JP','460012','game/LEG/mobile-pc-ddz.png','','',NULL where not exists (select id from game_i18n where game_id=460012 and locale='ja_JP');


-- 8. api_order_log

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype") SELECT '46', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL WHERE not EXISTS(SELECT id FROM api_order_log where api_id=46 and type='0');
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype") SELECT '46', '0', now(), '1', now(), 'f', NULL, NULL, NULL, NULL WHERE not EXISTS(SELECT id FROM api_order_log where api_id=46 and type='1');
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype") SELECT '46', '0', now(), '2', now(), 'f', NULL, NULL, NULL, NULL WHERE not EXISTS(SELECT id FROM api_order_log where api_id=46 and type='2');
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype") SELECT '46', '0', now(), '3', now(), 'f', NULL, NULL, NULL, NULL WHERE not EXISTS(SELECT id FROM api_order_log where api_id=46 and type='3');
