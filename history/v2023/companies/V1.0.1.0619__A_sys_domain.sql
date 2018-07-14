-- auto gen by steffan 2018-05-22 17:54:26  alter by martin
--companies库sys_domain表新增is_exception字段
select redo_sqls($$
    ALTER TABLE sys_domain ADD COLUMN is_exception character varying(4) DEFAULT 'N';
$$);

COMMENT ON COLUMN sys_domain.is_exception IS '是否例外域名(Y/N)';