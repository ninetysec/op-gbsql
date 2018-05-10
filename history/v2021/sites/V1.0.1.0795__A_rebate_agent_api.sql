-- auto gen by linsen 2018-05-03 14:54:05
-- 修改字段 by younger
SELECT redo_sqls ($$
		ALTER TABLE rebate_agent_api ALTER COLUMN rebate_ratio TYPE numeric(5,2);
		ALTER TABLE rebate_agent_api ALTER COLUMN parent_ratio TYPE numeric(5,2);
$$);