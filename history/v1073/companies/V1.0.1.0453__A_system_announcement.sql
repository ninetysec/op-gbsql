-- auto gen by george 2017-10-26 11:17:59
select redo_sqls ($$
  alter table system_announcement add column receive_user_type VARCHAR(20);
 $$);
COMMENT ON COLUMN system_announcement.receive_user_type IS '接收对象(运营商、站长、总代、代理)';