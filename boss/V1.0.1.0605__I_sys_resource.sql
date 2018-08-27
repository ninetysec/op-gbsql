-- auto gen by steffan 2018-08-27 16:29:30
-- 同步站点参数的菜单id不合规则,修改为有层级结构的id
update sys_resource
set id = 3060817
where id = 30624 and name='同步单个站点参数' and parent_id = 30608;


update sys_resource
set id = 30625
where id = 309 and name='同步所有站点参数' and parent_id = 306;