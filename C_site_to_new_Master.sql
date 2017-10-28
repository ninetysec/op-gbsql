-- gb-companies 站点更换站长

--Step--
--1)

update sys_site set sys_user_id = (
  SELECT id
  FROM sys_user
  WHERE username = 'xhtadmin'
)
where id = 259;


update sys_domain set sys_user_id = (
  SELECT id
  FROM sys_user
  WHERE username = 'xhtadmin'
)
where site_id = 259;
