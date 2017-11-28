-- auto gen by cheery 2015-12-18 09:22:41
DROP VIEW IF EXISTS v_sys_user_operators;
CREATE OR REPLACE VIEW v_sys_user_operators AS
 SELECT t2.name,
    t3.referrals,
    t1.id,
    t1.username,
    t1.birthday,
    t1.sex,
    t1.create_time,
    t1.last_login_ip,
    t1.last_login_time,
    t1.last_login_ip_dict_code,
    t1.constellation,
    t1.memo,
    t1.nickname,
    t1.status,
		t1.freeze_end_time
   FROM ((sys_user t1
     LEFT JOIN sys_site t2 ON ((t1.id = t2.sys_user_id)))
     LEFT JOIN user_extend t3 ON ((t1.id = t3.id)))
  WHERE ((t1.user_type)::text = '1'::text);

COMMENT ON VIEW v_sys_user_operators is '运营商视图实体 -- cherry';