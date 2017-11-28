-- auto gen by cherry 2016-02-02 17:47:26
DROP VIEW IF EXISTS  v_float_pic ;
CREATE OR REPLACE VIEW v_float_pic as
SELECT i.id,
    p.status,
    i.img_link_type,
    i.img_link_value
   FROM (ctt_float_pic_item i
     LEFT JOIN ctt_float_pic p ON ((i.float_pic_id = p.id)));

