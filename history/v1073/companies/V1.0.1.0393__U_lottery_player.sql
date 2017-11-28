-- auto gen by cherry 2017-08-18 11:25:54
DELETE FROM lottery_quota WHERE play_code in('dragon1_vs_tiger2',
'dragon1_vs_tiger3',
'dragon1_vs_tiger4',
'dragon1_vs_tiger5',
'dragon2_vs_tiger3',
'dragon2_vs_tiger4',
'dragon2_vs_tiger5',
'dragon3_vs_tiger4',
'dragon3_vs_tiger5',
'dragon4_vs_tiger5');

DELETE FROM site_lottery_quota WHERE play_code in('dragon1_vs_tiger2',
'dragon1_vs_tiger3',
'dragon1_vs_tiger4',
'dragon1_vs_tiger5',
'dragon2_vs_tiger3',
'dragon2_vs_tiger4',
'dragon2_vs_tiger5',
'dragon3_vs_tiger4',
'dragon3_vs_tiger5',
'dragon4_vs_tiger5');


DELETE FROM lottery_play WHERE code in ('dragon1_vs_tiger2',
'dragon1_vs_tiger3',
'dragon1_vs_tiger4',
'dragon1_vs_tiger5',
'dragon2_vs_tiger3',
'dragon2_vs_tiger4',
'dragon2_vs_tiger5',
'dragon3_vs_tiger4',
'dragon3_vs_tiger5',
'dragon4_vs_tiger5');

INSERT INTO lottery_quota (code, play_code, num_quota, bet_quota, play_quota)  SELECT 'cqssc', 'dragon_tiger', '300000', '30000', ' 2500000'where not EXISTS(SELECT id FROM lottery_quota WHERE code='cqssc' and play_code='dragon_tiger');

INSERT INTO lottery_quota (code, play_code, num_quota, bet_quota, play_quota)  SELECT 'tjssc', 'dragon_tiger', '300000', '30000', ' 2500000'where not EXISTS(SELECT id FROM lottery_quota WHERE code='tjssc' and play_code='dragon_tiger');

INSERT INTO lottery_quota (code, play_code, num_quota, bet_quota, play_quota)  SELECT 'xjssc', 'dragon_tiger', '300000', '30000', ' 2500000'where not EXISTS(SELECT id FROM lottery_quota WHERE code='xjssc' and play_code='dragon_tiger');

INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'ssc', 'cqssc', 'normal', '1', '0'where not EXISTS(SELECT id FROM lottery WHERE code='cqssc');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'pk10', 'bjpk10', 'normal', '2', '0'where not EXISTS(SELECT id FROM lottery WHERE code='bjpk10');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'k3', 'jsk3', 'normal', '3', '0'where not EXISTS(SELECT id FROM lottery WHERE code='jsk3');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'lhc', 'hklhc', 'normal', '4', '0'where not EXISTS(SELECT id FROM lottery WHERE code='hklhc');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'ssc', 'xjssc', 'normal', '5', '0'where not EXISTS(SELECT id FROM lottery WHERE code='xjssc');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'ssc', 'tjssc', 'normal', '6', '0'where not EXISTS(SELECT id FROM lottery WHERE code='tjssc');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'k3', 'ahk3', 'normal', '7', '0'where not EXISTS(SELECT id FROM lottery WHERE code='ahk3');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'k3', 'gxk3', 'maintain', '8', '0'where not EXISTS(SELECT id FROM lottery WHERE code='gxk3');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'k3', 'hbk3', 'normal', '9', '0'where not EXISTS(SELECT id FROM lottery WHERE code='hbk3');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'pk10', 'xyft', 'normal', '10', '0'where not EXISTS(SELECT id FROM lottery WHERE code='xyft');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'xy28', 'xy28', 'normal', '11', '0'where not EXISTS(SELECT id FROM lottery WHERE code='xy28');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'sfc', 'cqxync', 'normal', '12', '0'where not EXISTS(SELECT id FROM lottery WHERE code='cqxync');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'sfc', 'gdkl10', 'normal', '13', '0'where not EXISTS(SELECT id FROM lottery WHERE code='gdkl10');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'keno', 'bjkl8', 'normal', '14', '0'where not EXISTS(SELECT id FROM lottery WHERE code='bjkl8');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'pl3', 'fc3d', 'normal', '15', '0'where not EXISTS(SELECT id FROM lottery WHERE code='fc3d');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'pl3', 'tcpl3', 'normal', '16', '0'where not EXISTS(SELECT id FROM lottery WHERE code='tcpl3');
