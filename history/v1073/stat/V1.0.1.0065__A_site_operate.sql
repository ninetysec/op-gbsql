-- auto gen by cherry 2017-09-20 20:58:50
SELECT redo_sqls($$
ALTER TABLE site_operate ADD COLUMN winning_amount numeric(20,2) default 0;
ALTER TABLE site_operate ADD COLUMN contribution_amount numeric(20,2) default 0;

ALTER TABLE master_operate ADD COLUMN winning_amount numeric(20,2) default 0;
ALTER TABLE master_operate ADD COLUMN contribution_amount numeric(20,2) default 0;
$$);

COMMENT ON COLUMN site_operate.winning_amount IS '中奖金额';
COMMENT ON COLUMN site_operate.contribution_amount IS '彩池共享金';

COMMENT ON COLUMN master_operate.winning_amount IS '中奖金额';
COMMENT ON COLUMN master_operate.contribution_amount IS '彩池共享金';