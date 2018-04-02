-- auto gen by linsen 2018-03-29 21:22:53
-- 买分表添加买分和转账提醒相关字段 by linsne
select redo_sqls($$
  ALTER TABLE sys_site_credit ADD COLUMN profit_warning_condition VARCHAR(255);
  ALTER TABLE sys_site_credit ADD COLUMN transfer_warning_condition VARCHAR(255);
  ALTER TABLE sys_site_credit ADD COLUMN profit_warning_time VARCHAR(255);
  ALTER TABLE sys_site_credit ADD COLUMN transfer_warning_time VARCHAR(255);
  $$);

COMMENT ON COLUMN sys_site_credit.profit_warning_condition IS '买分提醒条件:默认80%-90%每8小时提醒一次，90%-100%每3小时提醒一次，大于等于100%每1小时提醒一次';
COMMENT ON COLUMN sys_site_credit.transfer_warning_condition IS '转账提醒条件：默认80%-90%每3小时提醒一次，90%-100%每:1小时提醒一次，大于等于100%立即关闭转账';
COMMENT ON COLUMN sys_site_credit.profit_warning_time IS '买分提醒时间';
COMMENT ON COLUMN sys_site_credit.transfer_warning_time IS '转账提醒时间';

-- 更新买分表新加字段默认值 by linsen
UPDATE sys_site_credit SET transfer_line='0',profit_ratio='10',transfer_ratio='20', profit_warning_condition='{"80-90":"8","90-100":"3","100-100":"1"}',transfer_warning_condition='{"80-90":"3","90-100":"1"}',profit_warning_time='{"80-90":"","90-100":"","100-100":""}',transfer_warning_time='{"80-90":"","90-100":""}';

