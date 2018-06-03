-- auto gen by steffan 2018-05-22 17:54:42   alter by martin
--companies库sys_site表新增maintain_type字段
select redo_sqls($$
    ALTER TABLE sys_site ADD COLUMN maintain_type character varying(20);
$$);

COMMENT ON COLUMN sys_site.maintain_type
    IS '站点维护方式(all/frontend/background:全站维护/前台维护/后台维护)';