-- auto gen by cherry 2017-09-05 14:47:14
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
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'ssc', 'ffssc', 'normal', '1', '0'where not EXISTS(SELECT id FROM lottery WHERE code='ffssc');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'ssc', 'efssc', 'normal', '2', '0'where not EXISTS(SELECT id FROM lottery WHERE code='efssc');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'ssc', 'sfssc', 'normal', '3', '0'where not EXISTS(SELECT id FROM lottery WHERE code='sfssc');
INSERT INTO lottery (type, code, status, order_num, terminal) SELECT 'ssc', 'wfssc', 'normal', '4', '0'where not EXISTS(SELECT id FROM lottery WHERE code='wfssc');


