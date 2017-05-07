-- auto gen by cherry 2016-01-19 09:26:33
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
 SELECT  'setting', 'sys_tone_onlinePay', 'golden', 'musics/onlinePay/golden.wav', '500', '4', '超级玛丽-golden', NULL, 't', NULL
WHERE 'golden' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_onlinePay');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_onlinePay', 'dxyx2', 'musics/onlinePay/dxyx2.wav', '1000', '3', '短信音效2', NULL, 't', NULL
WHERE 'dxyx2' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_onlinePay');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_onlinePay', 'yxyx', 'musics/onlinePay/yxyx.wav', '500', '2', '游戏音效', NULL, 't', NULL
WHERE 'yxyx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_onlinePay');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_onlinePay', 'sxsjdxy', 'musics/onlinePay/sxsjdxy.wav', '3000', '1', '三星手机短信音', NULL, 't', NULL
WHERE 'sxsjdxy' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_onlinePay');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_warm', 'jls', 'musics/warm/jls.wav', '3000', '6', '警铃声', NULL, 't', NULL
WHERE 'jls' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_warm', 'jss3', 'musics/warm/jss3.wav', '3000', '5', '警示声3', NULL, 't', NULL
WHERE 'jss3' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_warm', 'jss2', 'musics/warm/jss2.wav', '4000', '4', '警示声2', NULL, 't', NULL
WHERE 'jss2' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_warm', 'jss1', 'musics/warm/jss1.wav', '3000', '3', '警示声1', NULL, 't', NULL
WHERE 'jss1' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_warm', 'jbs', 'musics/warm/jbs.wav', '3000', '2', '警报声', NULL, 't', NULL
WHERE 'jbs' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_warm', 'lhjs', 'musics/warm/lhjs.wav', '2000', '1', '老虎机声-警报声', NULL, 't', NULL
WHERE 'lhjs' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_notice', 'nlyx', 'musics/notice/nlyx.wav', '3000', '2', '闹铃音效', NULL, 't', NULL
WHERE 'nlyx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_notice', 'xxxtx', 'musics/notice/xxxtx.wav', '3000', '2', '新消息提醒-英文', NULL, 't', NULL
WHERE 'xxxtx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_notice', 'sjdxy', 'musics/notice/sjdxy.wav', '2000', '2', '手机短信音', NULL, 't', NULL
WHERE 'sjdxy' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_notice', 'sjhxyx', 'musics/notice/sjhxyx.wav', '2000', '2', '手机和弦音效', NULL, 't', NULL
WHERE 'sjhxyx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_notice', 'sxdxtsy', 'musics/notice/sxdxtsy.wav', '1000', '2', '三星短信提示音', NULL, 't', NULL
WHERE 'sxdxtsy' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_draw', 'hdlpy', 'musics/draw/hdlpy.wav', '3000', '3', '魂斗罗配乐', NULL, 't', NULL
WHERE 'hdlpy' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_draw');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_draw', 'passing', 'musics/draw/passing.wav', '2000', '2', 'passing', NULL, 't', NULL
WHERE 'passing' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_draw');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_draw', 'doorbell', 'musics/draw/doorbell.wav', '1000', '1', 'doorbell', NULL, 't', NULL
WHERE 'doorbell' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_draw');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_deposit', 'cbtg', 'musics/deposit/cbtg.wav', '3000', '6', '超级玛丽-城堡通关', NULL, 't', NULL
WHERE 'cbtg' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_deposit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_deposit', 'cdmghh', 'musics/deposit/cdmghh.wav', '3000', '5', '超级玛丽-吃到蘑菇或花', NULL, 't', NULL
WHERE 'cdmghh' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_deposit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_deposit', 'njyjdls', 'musics/deposit/njyjdls.wav', '3000', '4', '诺基亚经典铃音', NULL, 't', NULL
WHERE 'njyjdls' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_deposit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_deposit', 'pgjdls', 'musics/deposit/pgjdls.wav', '2000', '3', '苹果经典铃音marimba', NULL, 't', NULL
WHERE 'pgjdls' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_deposit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_deposit', 'sjhxyx', 'musics/deposit/sjhxyx.wav', '2000', '2', '手机和弦音效', NULL, 't', NULL
WHERE 'sjhxyx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_deposit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_deposit', 'hxqkyx', 'musics/deposit/hxqkyx.wav', '3000', '1', '和弦轻快音效', NULL, 't', NULL
WHERE 'hxqkyx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_deposit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_audit', 'spyx', 'musics/audit/spyx.wav', '3000', '5', '审批音效', NULL, 't', NULL
WHERE 'spyx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_audit', 'sjkd', 'musics/audit/sjkd.wav', '2000', '4', '时间快到', NULL, 't', NULL
WHERE  'sjkd' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_audit', 'sjhxyx2', 'musics/audit/sjhxyx2.wav', '3000', '3', '手机和弦音效2', NULL, 't', NULL
WHERE  'sjhxyx2' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_audit', 'sxsjls', 'musics/audit/sxsjls.wav', '3000', '2', '三星手机铃声', NULL, 't', NULL
WHERE  'sxsjls' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_audit', 'trill', 'musics/audit/trill.wav', '2000', '1', 'Trill', NULL, 't', NULL
WHERE  'trill' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

UPDATE sys_param SET default_value='musics/notice/sxdxtsy.wav' WHERE param_type='warming_tone_project' AND param_code='notice';
UPDATE sys_param SET default_value='musics/warm/lhjs.wav' WHERE param_type='warming_tone_project' AND param_code='warm';
UPDATE sys_param SET default_value='musics/audit/trill.wav' WHERE param_type='warming_tone_project' AND param_code='audit';
UPDATE sys_param SET default_value='musics/draw/doorbell.wav' WHERE param_type='warming_tone_project' AND param_code='draw';
UPDATE sys_param SET default_value='musics/onlinePay/sxsjdxy.wav' WHERE param_type='warming_tone_project' AND param_code='onlinePay';
UPDATE sys_param SET default_value='musics/deposit/hxqkyx.wav' WHERE param_type='warming_tone_project' AND param_code='deposit';

UPDATE sys_resource SET url='vNoticeEmailRank/list.html' WHERE id=709;