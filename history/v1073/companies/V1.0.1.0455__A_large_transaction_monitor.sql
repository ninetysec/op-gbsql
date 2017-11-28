-- auto gen by cherry 2017-10-27 10:04:24
CREATE OR REPLACE VIEW v_large_transaction_monitor as
SELECT t1.*,t2.main_currency FROM
large_transaction_monitor t1
LEFT JOIN sys_site t2 ON t1.site_id = t2.id;

COMMENT ON VIEW v_large_transaction_monitor is '大额交易视图 -- cherry';