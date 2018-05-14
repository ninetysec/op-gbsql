-- auto gen by linsen 2018-04-23 15:38:27
-- pay_api_provider表添加字段 by lin
select redo_sqls($$
ALTER TABLE pay_api_provider ADD COLUMN is_proxy_mode BOOLEAN;
$$);

COMMENT ON COLUMN pay_api_provider.is_proxy_mode is '是否开启代理';