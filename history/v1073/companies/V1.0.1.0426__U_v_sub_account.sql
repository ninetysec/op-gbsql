-- auto gen by longer 2017-09-27 22:53:43

-- auto gen by longer 2017-09-27 22:53:43

drop VIEW if EXISTS v_sub_account;
CREATE OR REPLACE VIEW v_sub_account AS SELECT su.user_type,
                               su.id,
                               su.username,
                               su.status,
                               su.create_time,
                               su.real_name,
                               su.nickname,
                               array_to_json(ARRAY( SELECT sys_role.name
                                                    FROM "gb-companies".sys_role
                                                    WHERE (sys_role.id IN ( SELECT sys_user_role.role_id
                                                                            FROM "gb-companies".sys_user_role
                                                                            WHERE (sys_user_role.user_id = su.id))))) AS roles,
                               array_to_json(ARRAY( SELECT sys_role.id
                                                    FROM "gb-companies".sys_role
                                                    WHERE (sys_role.id IN ( SELECT sys_user_role.role_id
                                                                            FROM "gb-companies".sys_user_role
                                                                            WHERE (sys_user_role.user_id = su.id))))) AS role_ids,
                               ( SELECT
                                   CASE
                                   WHEN (count(1) > 0) THEN true
                                   ELSE false
                                   END AS built_in
                                 FROM "gb-companies".sys_role
                                 WHERE ((sys_role.id IN ( SELECT sys_user_role.role_id
                                                          FROM "gb-companies".sys_user_role
                                                          WHERE (sys_user_role.user_id = su.id))) AND sys_role.built_in)) AS built_in,
                               su.owner_id,
                               su.site_id,
                               su.login_time,
                               su.freeze_end_time
                             FROM "gb-companies".sys_user su
                             WHERE (((su.user_type)::text = '11'::text) AND ((su.status)::text = ANY (ARRAY['1'::text, '2'::text])));



