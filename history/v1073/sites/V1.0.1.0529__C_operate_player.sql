-- auto gen by cherry 2017-09-20 21:02:20
SELECT redo_sqls($$
ALTER TABLE operate_player ADD COLUMN winning_amount numeric(20,2);
ALTER TABLE operate_player ADD COLUMN contribution_amount numeric(20,2);

ALTER TABLE operate_agent ADD COLUMN winning_amount numeric(20,2);
ALTER TABLE operate_agent ADD COLUMN contribution_amount numeric(20,2);

ALTER TABLE operate_topagent ADD COLUMN winning_amount numeric(20,2);
ALTER TABLE operate_topagent ADD COLUMN contribution_amount numeric(20,2);
$$);

COMMENT ON COLUMN operate_player.winning_amount IS '中奖金额';
COMMENT ON COLUMN operate_player.contribution_amount IS '彩池共享金';

COMMENT ON COLUMN operate_agent.winning_amount IS '中奖金额';
COMMENT ON COLUMN operate_agent.contribution_amount IS '彩池共享金';

COMMENT ON COLUMN operate_topagent.winning_amount IS '中奖金额';
COMMENT ON COLUMN operate_topagent.contribution_amount IS '彩池共享金';