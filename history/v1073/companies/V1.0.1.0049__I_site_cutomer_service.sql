-- auto gen by cherry 2016-03-08 16:29:34
DELETE FROM site_customer_service WHERE code='K001' AND site_id='1';

INSERT INTO site_customer_service ( "site_id", "code", "name", "parameter", "status", "create_time", "create_user", "built_in")
SELECT  '1', 'K001', '默认客服', 'http://chat.53kf.com/webCompany.php?arg=cnspeed&style=1&language=zh-cn&lytype=0&charset=gbk&kflist=on&kf=100311874,100311875,100311876,100311886,100312081&zdkf_type=2&referer=http%3A%2F%2Fcnspeed.com%2Fhelp%2Findex_kf.asp&keyword=&tfrom=1&tpl=crystal_blue', 't', '2016-01-29 10:51:33.73621', '0', 't'
WHERE 'K001' not in(SELECT code FROM site_customer_service where site_id='1' );