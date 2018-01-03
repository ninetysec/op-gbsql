-- auto gen by cherry 2016-08-10 11:44:28
 select redo_sqls($$
	alter TABLE sys_domain add column for_agent BOOLEAN ;
$$);

COMMENT ON COLUMN "sys_domain"."for_agent" IS '代理使用';