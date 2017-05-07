-- auto gen by Administrator 2016-11-21 15:43:55
INSERT INTO sys_param ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
 select  'setting', 'servers', 'vip', '121.201.42.17', '121.201.42.17', '9', '浏览器防劫持服务器地址,逗号隔开', '', 't', '0'
 where  'vip' not in(select param_code from sys_param where module='setting' and param_type='servers' and param_code='vip');
