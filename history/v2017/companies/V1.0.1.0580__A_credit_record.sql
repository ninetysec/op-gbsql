-- auto gen by linsen 2018-03-25 17:37:53
-- credit_record添加字段 by linsen
SELECT redo_sqls($$
  alter table credit_record add COLUMN transfer_scale numeric(20,2);
  alter table credit_record add COLUMN transfer_quota numeric(20,2);
  alter table credit_record add COLUMN credit_line numeric(20,2);
  alter table credit_record add COLUMN transfer_line numeric(20,2);
$$);

COMMENT ON COLUMN credit_record.transfer_scale is '转账额度兑换比例';
COMMENT ON COLUMN credit_record.transfer_quota is '充值后转账额度';
COMMENT ON COLUMN credit_record.credit_line is '买分授信额度';
COMMENT ON COLUMN credit_record.transfer_line is '转账授信额度';


