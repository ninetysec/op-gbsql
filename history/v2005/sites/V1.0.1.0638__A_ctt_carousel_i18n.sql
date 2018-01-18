-- auto gen by george 2017-12-19 16:42:05
select redo_sqls($$
alter table ctt_carousel_i18n add column content VARCHAR(2048);
$$);
COMMENT ON COLUMN ctt_carousel_i18n.content IS '文字内容';