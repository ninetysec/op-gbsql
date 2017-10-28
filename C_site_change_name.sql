-- gb-companies 站点改名

--Step--
--1)

update site_i18n set value = '新海天'
where module = 'setting'
      and type = 'site_name'
      and key = 'name'
      and locale = 'zh_CN'
      and site_id = 259;


update sys_datasource set name = '新海天'
where id = 259;
update sys_report_datasource set name = '新海天'
where id = 259;
