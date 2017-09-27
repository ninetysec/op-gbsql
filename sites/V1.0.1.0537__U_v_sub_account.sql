-- auto gen by longer 2017-09-27 22:53:43

drop VIEW if EXISTS v_sub_account;
CREATE or REPLACE VIEW v_sub_account AS SELECT su.id,
                                          su.user_type,
                                          su.username,
                                          su.status,
                                          su.create_time,
                                          su.real_name,
                                          su.nickname,
                                          array_to_json(ARRAY( SELECT sys_role.name
                                                               FROM sys_role
                                                               WHERE (sys_role.id IN ( SELECT sys_user_role.role_id
                                                                                       FROM sys_user_role
                                                                                       WHERE (sys_user_role.user_id = su.id))))) AS roles,
                                          array_to_json(ARRAY( SELECT sys_role.id
                                                               FROM sys_role
                                                               WHERE (sys_role.id IN ( SELECT sys_user_role.role_id
                                                                                       FROM sys_user_role
                                                                                       WHERE (sys_user_role.user_id = su.id))))) AS role_ids,
                                          ( SELECT
                                              CASE
                                              WHEN (count(1) > 0) THEN true
                                              ELSE false
                                              END AS built_in
                                            FROM sys_role
                                            WHERE ((sys_role.id IN ( SELECT sys_user_role.role_id
                                                                     FROM sys_user_role
                                                                     WHERE (sys_user_role.user_id = su.id))) AND sys_role.built_in)) AS built_in,
                                          su.owner_id,
                                          su.site_id,
                                          su.login_time,
                                          su.authentication_key,
                                          su.freeze_end_time
                                        FROM sys_user su
                                        WHERE (((su.user_type)::text = ANY (ARRAY['21'::text, '221'::text, '231'::text])) AND ((su.status)::text = ANY (ARRAY['1'::text, '2'::text])));
