-- auto gen by george 2017-12-06 19:50:52
select redo_sqls ($$
alter table ctt_float_pic_item add column img_link_protocol VARCHAR(10);
 $$);
COMMENT ON COLUMN ctt_float_pic_item.img_link_protocol IS '图片链接协议';