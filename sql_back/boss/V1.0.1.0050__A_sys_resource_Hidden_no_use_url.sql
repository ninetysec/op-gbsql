-- auto gen by longer 2016-01-12 11:16:39


-- 暂时注释掉以下功能
-- 规则文件
-- 审计日志
-- 服务器管理
update sys_resource set status = false where id in( 503,504,505 );
