-- auto gen by linsen 2018-05-07 16:49:23
--捷报数据中心菜单初使化脚本 by martin

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '11', '捷报数据', '/mcenter/mreport', '捷报数据', NULL, '', '10', 'mcenter', 'mcenter:mreport', '1', 'icon-caipiao', 't', 'f', 'f'
where not exists(select id from sys_resource where id=11);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1101', '站点日常数据', '', '站点日常数据', '11', '', '1', 'mcenter', 'mreport:site_daily', '1', 'icon_gaikuang', 't', 'f', 't'
where not exists(select id from sys_resource where id=1101);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1102', '玩家分析', '', '玩家分析', '11', '', '2', 'mcenter', 'mreport:player_analyze', '1', 'icon_player', 't', 'f', 't'
where not exists(select id from sys_resource where id=1102);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1103', '付费分析', '', '付费分析', '11', '', '3', 'mcenter', 'mreport:paid_analyze', '1', 'icon_deposit', 't', 'f', 't'
where not exists(select id from sys_resource where id=1103);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1104', '游戏与用户细分', '', '游戏与用户细分', '11', '', '4', 'mcenter', 'mreport:game_player', '1', 'icon_game', 't', 'f', 't'
where not exists(select id from sys_resource where id=1104);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1105', '活动数据分析', '', '活动数据分析', '11', '', '5', 'mcenter', 'mreport:activity_analyze', '1', 'icon_deposit', 't', 'f', 't'
where not exists(select id from sys_resource where id=1105);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1106', '包网最高权限数据', '', '包网最高权限数据', '11', '', '6', 'mcenter', 'mreport:baowang_authority', '1', 'icon_deposit', 't', 'f', 't'
where not exists(select id from sys_resource where id=1106);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110101', '实时总览', '/daily/realTimeSummary.html', '实时总览', '1101', '', '1', 'mcenter', 'daily:realtime_profile', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110101);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110102', '运营日常统计', '/daily/operationSummary.html', '运营日常统计', '1101', '', '2', 'mcenter', 'daily:operation_summary', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110102);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110103', '市场日常统计', '', '市场日常统计', '1101', '', '3', 'mcenter', 'daily:market_summary', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110103);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110104', '终端用户数据构成', '', '终端用户数据构成', '1101', '', '4', 'mcenter', 'daily:terminal_summary', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110104);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110201', '注册来源分析', '', '注册来源分析', '1102', '', '1', 'mcenter', 'player:registered_source', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110201);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110202', '访问深度分析', '', '访问深度分析', '1102', '', '2', 'mcenter', 'player:view_deepin', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110202);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110203', '留存分析', '', '留存分析', '1102', '', '3', 'mcenter', 'player:retain_analyze', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110203);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110204', 'IP&设备分布', '', 'IP&设备分布', '1102', '', '4', 'mcenter', 'player:ip_device_distributed', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110204);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110205', '用户质量分布', '', '用户质量分布', '1102', '', '5', 'mcenter', 'player:user_quality', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110205);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110301', 'API营收', '', 'API营收', '1103', '', '1', 'mcenter', 'paid:api_revenue', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110301);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110302', '投注额金字塔', '', '投注额金字塔', '1103', '', '2', 'mcenter', 'paid:betting_pyramid', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110302);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110303', '存款分析', '', '存款分析', '1103', '', '3', 'mcenter', 'paid:deposit_analyze', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110303);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110401', '游戏数据分析', '', '游戏数据分析', '1104', '', '1', 'mcenter', 'gamePlayer:game_data', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110401);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110402', '体育用户细分', '', '体育用户细分', '1104', '', '2', 'mcenter', 'gamePlayer:sports_player', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110402);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110403', '电子用户细分', '', '电子用户细分', '1104', '', '3', 'mcenter', 'gamePlayer:casino_player', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110403);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110404', '真人类用户细分', '', '真人类用户细分', '1104', '', '4', 'mcenter', 'gamePlayer:live_dealer_player', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110404);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110405', '彩票类用户细分', '', '彩票类用户细分', '1104', '', '5', 'mcenter', 'gamePlayer:lottery_player', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110405);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110406', '棋牌类用户细分', '', '棋牌类用户细分', '1104', '', '6', 'mcenter', 'gamePlayer:chess_player', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110406);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110501', '存送活动数据', '', '存送活动数据', '1105', '', '1', 'mcenter', 'activity:deposit_gift', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110501);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110502', '有效投注额活动数据', '', '有效投注额活动数据', '1105', '', '2', 'mcenter', 'activity:effective_transaction', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110502);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110503', '浮窗类活动数据', '', '浮窗类活动数据', '1105', '', '3', 'mcenter', 'activity:float_window', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110503);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110504', '注册送活动数据', '', '注册送活动数据', '1105', '', '4', 'mcenter', 'activity:registered_gift', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110504);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110601', '支付通道丢单统计', '', '支付通道丢单统计', '1106', '', '1', 'mcenter', 'authority:payment_channel_lost', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110601);

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '110602', 'VIP玩家分析', '', 'VIP玩家分析', '1106', '', '2', 'mcenter', 'authority:vip_player_analyze', '1', '', 't', 'f', 't'
where not exists(select id from sys_resource where id=110602);
