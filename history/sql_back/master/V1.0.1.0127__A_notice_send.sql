-- auto gen by kevice 2015-10-16 16:24:08

select redo_sqls($$
    ALTER TABLE notice_send ADD COLUMN success_count integer DEFAULT 0;
    ALTER TABLE notice_send ADD COLUMN fail_count integer DEFAULT 0;
$$);
COMMENT ON COLUMN notice_send.success_count IS '发送成功数量';
COMMENT ON COLUMN notice_send.fail_count IS '发送失败数量';