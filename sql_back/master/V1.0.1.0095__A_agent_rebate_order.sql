-- auto gen by cheery 2015-09-22 11:33:09
--新增操作人id和操作人名称字段
select redo_sqls($$
  ALTER TABLE agent_rebate_order add COLUMN  user_id int4;
  ALTER TABLE agent_rebate_order ADD COLUMN username varchar(32);
$$);

COMMENT ON COLUMN agent_rebate_order.user_id IS '操作人id';
COMMENT ON COLUMN agent_rebate_order.username IS '操作人名称';