-- auto gen by tony 2016-11-06 16:25:41
update sys_domain set page_url='/' where page_url='/index.html';
update sys_domain set page_url='/mcenter/passport/login.html' where page_url='/mcenter/index.html';
update sys_domain set page_url='/ccenter/passport/login.html' where site_id<0;
update sys_domain set page_url='/boss/passport/login.html' where site_id=0;
update sys_domain set page_url='/' where agent_id is not null and site_id>0 and (page_url is null or page_url='');