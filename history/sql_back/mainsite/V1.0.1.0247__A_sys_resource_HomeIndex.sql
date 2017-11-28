-- auto gen by longer 2016-01-22 14:49:03
-- 运营商首页一起不需要的菜单,暂时关闭
update sys_resource set status = false where id in (101,102,103,104,105);



