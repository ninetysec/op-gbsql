-- auto gen by linsen 2018-04-06 15:12:33
-- player_transaction添加字段 by linsen

SELECT redo_sqls($$
  alter table player_transaction add COLUMN agent_id int4;
  alter table player_transaction add COLUMN agent_username varchar(32);
  alter table player_transaction add COLUMN topagent_id int4;
  alter table player_transaction add COLUMN topagent_username varchar(32);
  alter table player_transaction add COLUMN user_name varchar(32);
$$);

COMMENT ON COLUMN player_transaction.agent_id is '代理id';
COMMENT ON COLUMN player_transaction.agent_username is '代理账号';
COMMENT ON COLUMN player_transaction.topagent_id is '总代id';
COMMENT ON COLUMN player_transaction.topagent_username is '总代账号';
COMMENT ON COLUMN player_transaction.user_name is '玩家账号';
