-- auto gen by linsen 2018-04-17 11:34:13
-- 删除之前新建的pay_proxy_line，用新建proxy_line代替 by lin
DROP TABLE IF EXISTS "pay_proxy_line";

CREATE TABLE if not EXISTS "proxy_line" (
"id" serial4 NOT NULL PRIMARY key,
"host_name" varchar(255) ,
"port" varchar(32) ,
"type" varchar(2) ,
"update_user" varchar(32) ,
"update_time" timestamp(6),
"status" varchar(32)
);
COMMENT on TABLE proxy_line is '代理线表';
COMMENT on COLUMN proxy_line.id is'主键';
COMMENT on COLUMN proxy_line.host_name is'代理hostname';
COMMENT on COLUMN proxy_line.port is'端口号';
COMMENT on COLUMN proxy_line.type is'代理类型';
COMMENT on COLUMN proxy_line.update_user is'更新用户';
COMMENT on COLUMN proxy_line.update_time is'更新时间';
COMMENT on COLUMN proxy_line.status is '状态';