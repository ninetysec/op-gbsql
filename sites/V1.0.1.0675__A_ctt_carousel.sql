-- auto gen by george 2018-01-24 14:38:33

--ctt_carousel表添加字段shwo_model
select redo_sqls($$
  ALTER TABLE ctt_carousel ADD COLUMN show_model VARCHAR(6);
$$);
COMMENT ON COLUMN ctt_carousel.show_model IS '图片展示模式';
--修改ctt_carousel_i18n字段content类型
alter table ctt_carousel_i18n alter column content type text;
