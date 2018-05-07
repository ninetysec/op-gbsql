-- auto gen by linsen 2018-04-09 11:53:20
-- ctt_float_pic添加字段 by kobe
select redo_sqls($$
   ALTER TABLE ctt_float_pic ADD COLUMN float_order_num int4;
$$);
COMMENT ON COLUMN ctt_float_pic.float_order_num IS '浮动图顺序'
