-- auto gen by linsen 2018-03-29 21:00:50
-- 站点恢复默认额度记录表添加“恢复前转账额度”字段 by linsen
select redo_sqls($$
  ALTER TABLE credit_reset_profit_record ADD COLUMN orgin_transfer numeric(20,2);
  $$);

COMMENT ON COLUMN credit_reset_profit_record.orgin_transfer IS '恢复前转账额度';

