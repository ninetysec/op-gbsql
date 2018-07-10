-- auto gen by linsen 2018-06-21 20:09:13
-- player_recharge添加索引 by min
CREATE INDEX IF NOT EXISTS player_recharge_recharge_type_parent_recharge_status_idx ON player_recharge(recharge_type_parent, recharge_type);
