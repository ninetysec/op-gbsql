-- auto gen by admin 2016-06-28 19:22:02
 select redo_sqls($$
     ALTER TABLE bank ADD COLUMN website varchar(256);
 $$);

COMMENT ON COLUMN bank.website  is '网上银行官网';

UPDATE bank SET website='http://www.icbc.com.cn' WHERE bank_name='icbc';

UPDATE bank SET website='http://www.cmbchina.com' WHERE bank_name='cmb';

UPDATE bank SET website='http://wwww.ccb.com' WHERE bank_name='ccb';

UPDATE bank SET website='http://www.95599.cn' WHERE bank_name='abc';

UPDATE bank SET website='http://www.boc.cn' WHERE bank_name='boc';

UPDATE bank SET website='http://www.cmbc.com.cn' WHERE bank_name='cmbc';

UPDATE bank SET website='http://www.cebbank.com' WHERE bank_name='ceb';

UPDATE bank SET website='http://www.95559.com.cn' WHERE bank_name='comm';

UPDATE bank SET website='http://www.spdb.com.cn' WHERE bank_name='spdb';

UPDATE bank SET website='http://bank.pingan.com' WHERE bank_name='spabank';

UPDATE bank SET website='http://www.cib.com.cn' WHERE bank_name='cib';

UPDATE bank SET website='http://www.bankofbeijing.com.cn' WHERE bank_name='bjbank';

UPDATE bank SET website='http://bank.ecitic.com' WHERE bank_name='citic';

UPDATE bank SET website='http://www.cgbchina.com.cn' WHERE bank_name='gdb';

UPDATE bank SET website='http://www.psbc.com' WHERE bank_name='psbc';

UPDATE bank SET website='http://www.jsbchina.cn' WHERE bank_name='jsbank';

UPDATE bank SET website='http://www.hxb.com.cn' WHERE bank_name='hxbank';

UPDATE bank SET website='http://www.bankofshanghai.com' WHERE bank_name='shbank';

UPDATE bank SET website='http://www.cbhb.com.cn' WHERE bank_name='bohaib';

UPDATE bank SET website='http://www.hkbea.com.cn' WHERE bank_name='hkbea';

UPDATE bank SET website='http://www.nbcb.com.cn' WHERE bank_name='nbbank';

UPDATE bank SET website='http://www.czbank.com' WHERE bank_name='czbank';

UPDATE bank SET website='http://www.hzbank.com.cn' WHERE bank_name='hzcb';

UPDATE bank SET website='http://www.gzcb.com.cn' WHERE bank_name='gcb';

UPDATE bank SET website='http://www.fjnx.com.cn' WHERE bank_name='fjnx';

UPDATE bank SET website='http://www.hangseng.com.cn/' WHERE bank_name='hangseng';

UPDATE bank SET website='https://www.alipay.com' WHERE bank_name='alipay';


