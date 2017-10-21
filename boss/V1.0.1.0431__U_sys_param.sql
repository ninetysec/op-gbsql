-- auto gen by tony 2017-10-21 17:21:20
--更新外围静态页面缓存刷新地址
UPDATE sys_param
SET param_value='http://{0}/__clear_html_cache',
    default_value='http://{0}/__clear_html_cache'
WHERE module='op'and param_type='purge_out_page_cache' and param_code='purge_out_page_cache';