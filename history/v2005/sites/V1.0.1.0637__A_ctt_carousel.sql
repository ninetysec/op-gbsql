-- auto gen by george 2017-12-19 16:41:32
select redo_sqls($$
alter table ctt_carousel add column content_type VARCHAR(10);
$$);
COMMENT ON COLUMN ctt_carousel.content_type IS '内容类型';