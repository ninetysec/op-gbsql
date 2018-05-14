-- auto gen by linsen 2018-05-04 14:18:28
-- site_online_account添加字段 by kobe
select redo_sqls($$
  ALTER TABLE site_online_account ADD COLUMN player_guest INT4;
  ALTER TABLE site_online_account ADD COLUMN real_guest INT4;
  ALTER TABLE site_online_account ADD COLUMN player_pc INT4;
  ALTER TABLE site_online_account ADD COLUMN player_h5 INT4;
  ALTER TABLE site_online_account ADD COLUMN player_ios INT4;
  ALTER TABLE site_online_account ADD COLUMN player_Android INT4;
$$);
COMMENT ON COLUMN site_online_account.player_guest IS '游客数量';
COMMENT ON COLUMN site_online_account.real_guest IS '去重游客数量';
COMMENT ON COLUMN site_online_account.player_pc IS '来自pc端玩家';
COMMENT ON COLUMN site_online_account.player_h5 IS '来自h5玩家';
COMMENT ON COLUMN site_online_account.player_ios IS '来自ios玩家';
COMMENT ON COLUMN site_online_account.player_Android IS '来自android玩家';