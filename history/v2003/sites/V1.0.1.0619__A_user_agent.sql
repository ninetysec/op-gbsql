-- auto gen by george 2017-12-04 09:07:01
select redo_sqls($$
	alter table user_agent add column view_capital_record BOOLEAN DEFAULT FALSE;
$$);
COMMENT ON COLUMN user_agent.view_capital_record IS '是否开启查看资金记录';