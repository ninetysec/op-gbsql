-- auto gen by linsen 2018-06-02 10:53:34
-- 修改merchant_code字段长度 by back
select redo_sqls($$
	alter table pay_log alter column merchant_code type varchar(200);
$$);
