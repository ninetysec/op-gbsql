-- auto gen by linsen 2018-04-15 16:59:54
-- pay_log表添加字段 by lin
select redo_sqls($$
    ALTER TABLE pay_log ADD COLUMN pay_code varchar(32);
$$);

COMMENT ON COLUMN pay_log.channel_code is '支付状态码';

