-- auto gen by cherry 2017-07-01 17:51:42

select redo_sqls($$
    ALTER TABLE player_transfer ADD COLUMN transfer_hash varchar(100) ;
  $$);
COMMENT on COLUMN player_transfer.transfer_hash is '转账hash值验证时间间隔';
CREATE UNIQUE INDEX IF NOT EXISTS  idx_player_transfer_transfer_hash ON player_transfer(transfer_hash);