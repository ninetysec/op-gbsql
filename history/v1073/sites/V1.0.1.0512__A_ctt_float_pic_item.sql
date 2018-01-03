-- auto gen by cherry 2017-08-24 10:18:00
DROP VIEW if EXISTS v_float_pic;

ALTER TABLE ctt_float_pic_item ALTER COLUMN normal_effect type varchar(512);
ALTER TABLE ctt_float_pic_item ALTER COLUMN mouse_in_effect type varchar(512);
ALTER TABLE ctt_float_pic_item ALTER COLUMN img_link_type type varchar(512);
ALTER TABLE ctt_float_pic_item ALTER COLUMN img_link_value type varchar(512);

CREATE OR REPLACE VIEW "v_float_pic" AS
 SELECT i.id,
    p.status,
    i.img_link_type,
    i.img_link_value
   FROM (ctt_float_pic_item i
     LEFT JOIN ctt_float_pic p ON ((i.float_pic_id = p.id)));