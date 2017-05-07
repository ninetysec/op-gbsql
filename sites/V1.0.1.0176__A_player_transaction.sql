-- auto gen by admin 2016-06-19 10:34:22
--修改为交易号约束
ALTER TABLE player_transaction DROP constraint IF EXISTS uc_player_transaction;

ALTER TABLE  player_transfer DROP constraint IF EXISTS uc_player_transfer;

ALTER TABLE player_recharge DROP constraint IF EXISTS uc_player_recharge;

ALTER TABLE player_recommend_award DROP constraint IF EXISTS uc_player_recommend_award;

ALTER TABLE player_withdraw DROP constraint IF EXISTS uc_player_withdraw;

select redo_sqls($$
alter TABLE player_recharge add CONSTRAINT uc_player_recharge UNIQUE (transaction_no);

alter TABLE player_transaction add CONSTRAINT uc_player_transaction UNIQUE (transaction_no);

alter TABLE player_transfer add CONSTRAINT uc_player_transfer UNIQUE (transaction_no);

alter TABLE player_recommend_award add CONSTRAINT uc_player_recommend_award UNIQUE (transaction_no);

alter TABLE player_withdraw add CONSTRAINT uc_player_withdraw UNIQUE (transaction_no);
$$);