-- auto gen by linsen 2018-07-30 19:42:09
-- bank表添加约束 by mical
SELECT redo_sqls($$
	ALTER TABLE bank ADD CONSTRAINT "constraint_bank_name" UNIQUE ("bank_name");
$$);