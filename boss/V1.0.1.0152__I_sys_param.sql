-- auto gen by bruce 2016-10-02 11:45:50
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
  SELECT 'setting', 'sys_tone_attack', 'attack', 'musics/attack.wav', 'musics/attack.wav', '1', '攻击提醒', NULL, 't', '0'
  WHERE 'attack' not IN (SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_attack');