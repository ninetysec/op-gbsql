-- auto gen by kevice 2015-10-22 15:57:43

select redo_sqls($$
  ALTER TABLE notice_send ADD COLUMN job_code character varying(32);
$$);
COMMENT ON COLUMN notice_send.job_code IS '定时任务的编码';