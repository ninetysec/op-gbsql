-- auto gen by admin 2016-04-15 21:01:22
ALTER TABLE pay_account ALTER COLUMN full_name DROP NOT NULL;
COMMENT ON COLUMN pay_account.full_name IS '姓名';

select redo_sqls($$
ALTER TABLE player_transfer add COLUMN  api_trans_id varchar(32);
 $$);

COMMENT on COLUMN player_transfer.api_trans_id is 'api的转账id';