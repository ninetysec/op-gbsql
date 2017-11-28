-- auto gen by cheery 2015-12-11 09:55:03
CREATE TABLE IF NOT EXISTS player_api_account(
	id serial4 NOT NULL PRIMARY KEY,
  api_id int4,
  account varchar(32),
  password varchar(128),
  currency varchar(3),
  locale varchar(5),
  create_time TIMESTAMP(6),
  user_id int4,
  user_name varchar(32)
);

COMMENT ON TABLE player_api_account IS 'API账号表--susu';
COMMENT ON COLUMN player_api_account.id IS '主键';
COMMENT ON COLUMN player_api_account.api_id IS 'api id';
COMMENT ON COLUMN player_api_account.account IS 'api账号';
COMMENT ON COLUMN player_api_account.password IS '密码(对称加密)';
COMMENT ON COLUMN player_api_account.currency IS '使用币种';
COMMENT ON COLUMN player_api_account.locale IS '游戏语言';
COMMENT ON COLUMN player_api_account.create_time IS '创建时间';
COMMENT ON COLUMN player_api_account.user_id IS '玩家id';
COMMENT ON COLUMN player_api_account.user_name IS '玩家名称';

select redo_sqls($$
     ALTER TABLE rebate_agent_nosettled ADD COLUMN recommend numeric(20,2) DEFAULT 0;
$$);
COMMENT ON COLUMN rebate_agent_nosettled.recommend IS ' 推荐费用';