-- auto gen by cherry 2017-08-17 16:22:41
select redo_sqls($$
    ALTER TABLE pay_account add COLUMN bank_login_name varchar(128);
		ALTER TABLE pay_account add COLUMN bank_password varchar(256);
		ALTER TABLE pay_account add COLUMN is_acb BOOLEAN;
$$);


COMMENT on COLUMN pay_account.bank_login_name is '网银登录名';
COMMENT on COLUMN pay_account.bank_password is '网银密码';
COMMENT on COLUMN pay_account.is_acb is '是否开启上分';