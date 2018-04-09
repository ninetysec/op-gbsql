-- auto gen by linsen 2018-04-09 11:52:05
-- activity_message_i18n添加字段 by kobe
select redo_sqls($$
  ALTER TABLE activity_message_i18n ADD COLUMN activity_terminal_type VARCHAR(8);
$$);
COMMENT ON COLUMN activity_message_i18n.activity_terminal_type IS '活动总段类型';