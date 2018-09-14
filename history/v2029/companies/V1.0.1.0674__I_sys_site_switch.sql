-- auto gen by linsen 2018-08-10 11:46:22
--体育赔率0.75是否计算有效投注额开关 by martin
INSERT INTO sys_site_switch(switch_code, switch_value, remark, site_id, create_user, create_time)
select 'sport_odds_switch', true, '体育赔率0.75是否计算有效投注额开关', ss.id, 0, now() from sys_site ss
where not exists(select null from sys_site_switch where switch_code='sport_odds_switch' and site_id = ss.id);