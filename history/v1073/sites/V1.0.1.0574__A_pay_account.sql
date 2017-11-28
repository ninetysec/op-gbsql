-- auto gen by cherry 2017-10-26 20:51:30
 select redo_sqls($$
   ALTER TABLE pay_account add COLUMN alias_name varchar(32);
	ALTER TABLE pay_account ADD COLUMN support_atm_counter BOOLEAN;
  $$);

COMMENT on COLUMN pay_account.alias_name is '别名';
COMMENT on COLUMN pay_account.support_atm_counter is '柜员机/柜台存款开关';
