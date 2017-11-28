-- auto gen by admin 2016-05-10 16:31:57
select redo_sqls($$
       ALTER TABLE rebate_agent  ADD COLUMN settlement_time timestamp (6);
ALTER TABLE rebate_agent ADD COLUMN operate_id int4;
ALTER TABLE rebate_agent ADD COLUMN operate_username varchar(100);
ALTER TABLE rebate_agent ADD COLUMN history_apportion numeric(20,2);
      $$);


COMMENT ON COLUMN rebate_agent.settlement_time IS '结算时间';
COMMENT ON COLUMN rebate_agent.operate_id IS '最后操作者id';
COMMENT ON COLUMN rebate_agent.operate_username IS '最后操作用户名';
COMMENT ON COLUMN rebate_agent.history_apportion IS '历史分摊费用';


select redo_sqls($$
    ALTER TABLE rebate_agent_nosettled ADD COLUMN history_apportion numeric(20,2);
$$);
COMMENT ON COLUMN rebate_agent_nosettled.history_apportion IS '历史分摊费用';