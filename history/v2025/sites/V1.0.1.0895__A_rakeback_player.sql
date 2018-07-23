-- auto gen by linsen 2018-06-29 17:45:17
-- rakeback_player添加代理线信息 by linsen
SELECT redo_sqls($$
  alter table rakeback_player add COLUMN agent_username varchar(32);
  alter table rakeback_player add COLUMN topagent_username varchar(32);
$$);

COMMENT ON COLUMN rakeback_player.agent_username is '代理账号';
COMMENT ON COLUMN rakeback_player.topagent_username is '总代账号';

-- rakeback_player_nosettled添加代理线信息 by linsen
SELECT redo_sqls($$
  alter table rakeback_player_nosettled add COLUMN agent_username varchar(32);
  alter table rakeback_player_nosettled add COLUMN topagent_username varchar(32);
$$);

COMMENT ON COLUMN rakeback_player_nosettled.agent_username is '代理账号';
COMMENT ON COLUMN rakeback_player_nosettled.topagent_username is '总代账号';