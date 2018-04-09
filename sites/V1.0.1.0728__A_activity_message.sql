-- auto gen by linsen 2018-04-09 11:50:31
-- activity_message添加字段 by kobe
select redo_sqls($$
  ALTER TABLE activity_message ADD COLUMN float_pic_show_in_pc VARCHAR(8);
  ALTER TABLE activity_message ADD COLUMN float_pic_show_in_mobile VARCHAR(8);
$$);
COMMENT ON COLUMN activity_message.float_pic_show_in_pc IS '浮窗PC端是否展示';
COMMENT ON COLUMN activity_message.float_pic_show_in_mobile IS '浮窗手机端是否展示';