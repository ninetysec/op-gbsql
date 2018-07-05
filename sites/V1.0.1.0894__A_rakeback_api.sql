-- auto gen by linsen 2018-06-29 17:44:09
--
-- rakeback_api添加代理线信息 by linsen
SELECT redo_sqls($$
  alter table rakeback_api add COLUMN agent_id int4;
  alter table rakeback_api add COLUMN agent_username varchar(32);
  alter table rakeback_api add COLUMN topagent_id int4;
  alter table rakeback_api add COLUMN topagent_username varchar(32);
$$);

COMMENT ON COLUMN rakeback_api.agent_id is '代理id';
COMMENT ON COLUMN rakeback_api.agent_username is '代理账号';
COMMENT ON COLUMN rakeback_api.topagent_id is '总代id';
COMMENT ON COLUMN rakeback_api.topagent_username is '总代账号';



-- rakeback_api_nosettled添加代理线信息 by linsen
SELECT redo_sqls($$
  alter table rakeback_api_nosettled add COLUMN agent_id int4;
  alter table rakeback_api_nosettled add COLUMN agent_username varchar(32);
  alter table rakeback_api_nosettled add COLUMN topagent_id int4;
  alter table rakeback_api_nosettled add COLUMN topagent_username varchar(32);
$$);

COMMENT ON COLUMN rakeback_api_nosettled.agent_id is '代理id';
COMMENT ON COLUMN rakeback_api_nosettled.agent_username is '代理账号';
COMMENT ON COLUMN rakeback_api_nosettled.topagent_id is '总代id';
COMMENT ON COLUMN rakeback_api_nosettled.topagent_username is '总代账号';