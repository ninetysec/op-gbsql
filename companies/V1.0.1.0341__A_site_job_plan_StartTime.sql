-- auto gen by longer 2017-07-03 17:32:38

select redo_sqls($$
    alter TABLE site_job_plan add COLUMN start_time TIMESTAMP;
$$);

COMMENT ON COLUMN site_job_plan.start_time is '任务开始执行时间';

CREATE OR REPLACE VIEW v_site_job_plan AS SELECT a1.id,
                                 a1.job_id,
                                 a2.prefix_job_id,
                                 a2.sub_job_code,
                                 a2.sub_job_name,
                                 a3.sub_job_code AS prefix_job_code,
                                 a3.sub_job_name AS prefix_job_name,
                                 a2.job_class,
                                 a2.job_method,
                                 a1.site_id,
                                 a4.sys_user_id AS master_id,
                                 a4.parent_id AS center_id,
                                 a4.timezone,
                                 a1.run_time,
                                 a1.job_time_type,
                                 a1.job_time_unit,
                                 a1.fixed_month,
                                 a1.fixed_day,
                                 a1.fixed_hour,
                                 a1.fixed_minutes,
                                 a1.fixed_second,
                                 a1.period_value,
                                 a1.status,
                                 a1.enable_status,
                                 a1.start_time
                               FROM (((site_job_plan a1
                                 LEFT JOIN site_job a2 ON ((a1.job_id = a2.id)))
                                 LEFT JOIN site_job a3 ON ((a2.prefix_job_id = a3.id)))
                                 LEFT JOIN sys_site a4 ON ((a1.site_id = a4.id)));

