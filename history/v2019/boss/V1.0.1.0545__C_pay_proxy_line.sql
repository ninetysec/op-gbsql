-- auto gen by linsen 2018-04-15 11:21:15
-- 新建支付代理线表 by lin
CREATE TABLE if not EXISTS "pay_proxy_line" (
"id" serial4 NOT NULL PRIMARY key,
"host_name" varchar(255) ,
"port" varchar(32) ,
"update_user" varchar(32) ,
"update_time" timestamp(6),
"status" varchar(32)
);
COMMENT on TABLE pay_proxy_line is '支付代理线表';
COMMENT on COLUMN pay_proxy_line.id is'主键';
COMMENT on COLUMN pay_proxy_line.host_name is'代理hostname';
COMMENT on COLUMN pay_proxy_line.port is'端口号';
COMMENT on COLUMN pay_proxy_line.update_user is'更新用户';
COMMENT on COLUMN pay_proxy_line.update_time is'更新时间';
COMMENT on COLUMN pay_proxy_line.status is '状态';