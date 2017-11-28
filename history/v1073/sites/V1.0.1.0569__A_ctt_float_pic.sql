-- auto gen by george 2017-10-26 10:19:15
select redo_sqls($$
  ALTER TABLE ctt_float_pic ADD COLUMN pic_type VARCHAR(6) DEFAULT 1;
  ALTER TABLE ctt_float_pic ADD COLUMN show_effect BOOLEAN;
$$);
COMMENT ON COLUMN ctt_float_pic.pic_type IS '图片类型';
COMMENT ON COLUMN ctt_float_pic.show_effect IS '显示效果';