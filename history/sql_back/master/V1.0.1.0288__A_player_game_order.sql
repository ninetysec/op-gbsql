-- auto gen by cheery 2015-12-24 16:00:49
--玩家游戏下单记录添加注单号码字段
select redo_sqls($$
  ALTER TABLE "player_game_order"  ADD COLUMN bet_id varchar(64);
$$);

COMMENT ON COLUMN player_game_order.bet_id IS '注单号码';