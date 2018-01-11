-- auto gen by george 2018-01-11 11:28:50

--隐藏生产的游戏管理菜单 by younger
update sys_resource set status = FALSE where url='vSiteApiType/list.html' and subsys_code = 'mcenter' and permission='content:game' and status = TRUE;