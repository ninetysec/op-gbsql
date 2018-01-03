-- auto gen by cherry 2016-01-12 14:43:13
ALTER TABLE "notice_text"  ALTER COLUMN "tmpl_params" TYPE text COLLATE "default";

CREATE TABLE IF NOT EXISTS "ctt_float_pic_item" (
"id" serial4 NOT NULL,
"float_pic_id" int4,
"normal_effect" varchar(255),
"mouse_in_effect" varchar(255),
"img_link_type" varchar(255),
"img_link_value" varchar(255),
"order_num" int4,
PRIMARY KEY ("id")
);
COMMENT ON TABLE ctt_float_pic_item IS '浮动图子项表--River';
COMMENT ON COLUMN "ctt_float_pic_item"."id" IS '主键';
COMMENT ON COLUMN "ctt_float_pic_item"."float_pic_id" IS '浮动图外键';
COMMENT ON COLUMN "ctt_float_pic_item"."normal_effect" IS '正常效果';
COMMENT ON COLUMN "ctt_float_pic_item"."mouse_in_effect" IS '鼠标移进效果';
COMMENT ON COLUMN "ctt_float_pic_item"."img_link_type" IS '链接类型(客户或URL)';
COMMENT ON COLUMN "ctt_float_pic_item"."img_link_value" IS '链接值(客户ID或url)';
COMMENT ON COLUMN "ctt_float_pic_item"."order_num" IS '顺序号';

COMMENT ON COLUMN "ctt_float_pic"."single_mode" IS 'true:单图模板模式；false:自定义列表模式';
--修改浮动图菜单URL
update sys_resource set url='cttFloatPic/list.html' where id=605;
UPDATE sys_resource set "name"='日志查询' where "id"='506';

