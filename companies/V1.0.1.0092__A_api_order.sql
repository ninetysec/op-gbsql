-- auto gen by admin 2016-05-06 22:00:29
 select redo_sqls($$
        ALTER TABLE api_order ADD COLUMN distribute_state character varying(32);
 $$);

COMMENT ON COLUMN api_order.distribute_state IS '分发状态(未分发,已分发,待重新分发)';

update help_type_i18n set "name"='转账帮助' where help_type_id=13;
update help_type_i18n set "name"='上海时时乐' where help_type_id=42;