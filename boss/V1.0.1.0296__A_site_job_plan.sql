-- auto gen by cherry 2017-02-25 11:40:07
DROP view if EXISTS v_site_job_plan;

select redo_sqls($$

  alter table site_job_plan add COLUMN master_id int4;

  alter table site_job_plan add COLUMN center_id int4;

$$);

COMMENT ON COLUMN site_job_plan.master_id is '站长ID';

COMMENT ON COLUMN site_job_plan.center_id is '运营商ID';


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

    a1.status

   FROM (site_job_plan a1

     LEFT JOIN site_sub_job a2 ON ((a1.job_id = a2.id))

     LEFT JOIN site_sub_job a3 on a2.prefix_job_id=a3.id);



insert into "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '16', NULL, 'site_job_016', ' 代理新进任务', 'so.wwb.gamebox.service.master.AnalyzePlayerJob', 'siteJob', '1', '1'

WHERE NOT EXISTS (select id from site_sub_job t where t.id = 16);



UPDATE site_sub_job SET prefix_job_id = 11 where id in (7,8,10);