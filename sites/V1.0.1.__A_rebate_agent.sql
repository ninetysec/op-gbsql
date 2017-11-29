-- auto gen by george 2017-11-29 15:00:54
SELECT redo_sqls($$

ALTER TABLE rebate_agent RENAME COLUMN deposit_radio TO deposit_ratio;

ALTER TABLE rebate_agent RENAME COLUMN withdraw_radio TO withdraw_ratio;

ALTER TABLE rebate_agent RENAME COLUMN rakeback_radio TO rakeback_ratio;

ALTER TABLE rebate_agent RENAME COLUMN favorable_radio TO favorable_ratio;

ALTER TABLE rebate_agent RENAME COLUMN other_radio TO other_ratio;

ALTER TABLE rebate_agent_nosettled RENAME COLUMN deposit_radio TO deposit_ratio;

ALTER TABLE rebate_agent_nosettled RENAME COLUMN withdraw_radio TO withdraw_ratio;

ALTER TABLE rebate_agent_nosettled RENAME COLUMN rakeback_radio TO rakeback_ratio;

ALTER TABLE rebate_agent_nosettled RENAME COLUMN favorable_radio TO favorable_ratio;

ALTER TABLE rebate_agent_nosettled RENAME COLUMN other_radio TO other_ratio;

$$);