-- auto gen by cherry 2017-02-27 20:10:01
select redo_sqls($$

  alter table site_job_run_record add COLUMN operator_id int4;

$$);

COMMENT ON COLUMN site_job_run_record.operator_id is '操作人ID';



select redo_sqls($$

  alter table site_job_plan add COLUMN enable_status VARCHAR(10);

$$);

COMMENT ON COLUMN site_job_plan.enable_status is '启用状态';



DROP view if EXISTS v_site_job_plan;

CREATE OR REPLACE VIEW "v_site_job_plan" AS

 SELECT a1.id,

    a1.job_id,

    a2.prefix_job_id,

    a2.sub_job_code,

    a2.sub_job_name,

    a3.sub_job_code prefix_job_code,

    a3.sub_job_name prefix_job_name,

    a2.job_class,

    a2.job_method,

    a1.site_id,

    a1.master_id,a1.center_id,

    a1.timezone,

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

    a1.enable_status

   FROM (site_job_plan a1

     LEFT JOIN site_sub_job a2 ON ((a1.job_id = a2.id))

     LEFT JOIN site_sub_job a3 on a2.prefix_job_id=a3.id);