-- auto gen by cherry 2017-03-14 10:41:54
update site_sub_job set job_time_unit='5',fixed_day = 3 where sub_job_code='site_job_008';

update site_sub_job set fixed_day = null where sub_job_code='site_job_003';