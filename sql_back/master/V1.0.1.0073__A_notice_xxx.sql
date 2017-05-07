-- auto gen by kevice 2015-09-17 09:15:40

select redo_sqls($$
  ALTER TABLE notice_email_interface ADD COLUMN reply_email_account CHARACTER VARYING(64);
  ALTER TABLE notice_email_interface ADD COLUMN test_email_account CHARACTER VARYING(64);
  ALTER TABLE notice_text ADD COLUMN tmpl_params CHARACTER VARYING(255);
  ALTER TABLE notice_send ADD COLUMN cron_exp CHARACTER VARYING(64);
$$);
COMMENT ON COLUMN notice_email_interface.reply_email_account IS '邮件回复账号';
COMMENT ON COLUMN notice_email_interface.test_email_account IS '邮件测试账号';
COMMENT ON COLUMN notice_text.tmpl_params IS '模板参数json串';
COMMENT ON COLUMN notice_send.cron_exp IS '定时发布的cron表达式，为空表示立即发布';
ALTER TABLE notice_contact_way ALTER COLUMN contact_value DROP NOT NULL;