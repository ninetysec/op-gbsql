-- auto gen by linsen 2018-08-20 11:55:35
-- 站点任务 by mical

create table IF NOT EXISTS qrtz_site_job_details
(
  sched_name varchar(120) not null,
  job_name  varchar(200) not null,
  job_group varchar(200) not null,
  description varchar(250) null,
  job_class_name   varchar(250) not null,
  is_durable bool not null,
  is_nonconcurrent bool not null,
  is_update_data bool not null,
  requests_recovery bool not null,
  job_data bytea null,
  primary key (sched_name,job_name,job_group)
);

create table IF NOT EXISTS qrtz_site_triggers
(
  sched_name varchar(120) not null,
  trigger_name varchar(200) not null,
  trigger_group varchar(200) not null,
  job_name  varchar(200) not null,
  job_group varchar(200) not null,
  description varchar(250) null,
  next_fire_time bigint null,
  prev_fire_time bigint null,
  priority integer null,
  trigger_state varchar(16) not null,
  trigger_type varchar(8) not null,
  start_time bigint not null,
  end_time bigint null,
  calendar_name varchar(200) null,
  misfire_instr smallint null,
  job_data bytea null,
  primary key (sched_name,trigger_name,trigger_group),
  foreign key (sched_name,job_name,job_group)
  references qrtz_site_job_details(sched_name,job_name,job_group)
);

create table IF NOT EXISTS qrtz_site_simple_triggers
(
  sched_name varchar(120) not null,
  trigger_name varchar(200) not null,
  trigger_group varchar(200) not null,
  repeat_count bigint not null,
  repeat_interval bigint not null,
  times_triggered bigint not null,
  primary key (sched_name,trigger_name,trigger_group),
  foreign key (sched_name,trigger_name,trigger_group)
  references qrtz_site_triggers(sched_name,trigger_name,trigger_group)
);

create table IF NOT EXISTS qrtz_site_cron_triggers
(
  sched_name varchar(120) not null,
  trigger_name varchar(200) not null,
  trigger_group varchar(200) not null,
  cron_expression varchar(200) not null,
  time_zone_id varchar(80),
  primary key (sched_name,trigger_name,trigger_group),
  foreign key (sched_name,trigger_name,trigger_group)
  references qrtz_site_triggers(sched_name,trigger_name,trigger_group)
);

create table IF NOT EXISTS qrtz_site_simprop_triggers
(
  sched_name varchar(120) not null,
  trigger_name varchar(200) not null,
  trigger_group varchar(200) not null,
  str_prop_1 varchar(512) null,
  str_prop_2 varchar(512) null,
  str_prop_3 varchar(512) null,
  int_prop_1 int null,
  int_prop_2 int null,
  long_prop_1 bigint null,
  long_prop_2 bigint null,
  dec_prop_1 numeric(13,4) null,
  dec_prop_2 numeric(13,4) null,
  bool_prop_1 bool null,
  bool_prop_2 bool null,
  primary key (sched_name,trigger_name,trigger_group),
  foreign key (sched_name,trigger_name,trigger_group)
  references qrtz_site_triggers(sched_name,trigger_name,trigger_group)
);

create table IF NOT EXISTS qrtz_site_blob_triggers
(
  sched_name varchar(120) not null,
  trigger_name varchar(200) not null,
  trigger_group varchar(200) not null,
  blob_data bytea null,
  primary key (sched_name,trigger_name,trigger_group),
  foreign key (sched_name,trigger_name,trigger_group)
  references qrtz_site_triggers(sched_name,trigger_name,trigger_group)
);

create table IF NOT EXISTS qrtz_site_calendars
(
  sched_name varchar(120) not null,
  calendar_name  varchar(200) not null,
  calendar bytea null,
  primary key (sched_name,calendar_name)
);

create table IF NOT EXISTS qrtz_site_paused_trigger_grps
(
  sched_name varchar(120) not null,
  trigger_group  varchar(200) not null,
  primary key (sched_name,trigger_group)
);

create table IF NOT EXISTS qrtz_site_fired_triggers
(
  sched_name varchar(120) not null,
  entry_id varchar(95) not null,
  trigger_name varchar(200) not null,
  trigger_group varchar(200) not null,
  instance_name varchar(200) not null,
  fired_time bigint not null,
  sched_time bigint not null,
  priority integer not null,
  state varchar(16) not null,
  job_name varchar(200) null,
  job_group varchar(200) null,
  is_nonconcurrent bool null,
  requests_recovery bool null,
  primary key (sched_name,entry_id)
);

create table IF NOT EXISTS qrtz_site_scheduler_state
(
  sched_name varchar(120) not null,
  instance_name varchar(200) not null,
  last_checkin_time bigint not null,
  checkin_interval bigint not null,
  primary key (sched_name,instance_name)
);

create table IF NOT EXISTS qrtz_site_locks
(
  sched_name varchar(120) not null,
  lock_name  varchar(40) not null,
  primary key (sched_name,lock_name)
);


create index IF NOT EXISTS idx_qrtz_site_j_req_recovery on qrtz_site_job_details(sched_name,requests_recovery);
create index IF NOT EXISTS idx_qrtz_site_j_grp on qrtz_site_job_details(sched_name,job_group);


create index IF NOT EXISTS idx_qrtz_site_t_jg on qrtz_site_triggers(sched_name,job_group);
create index IF NOT EXISTS idx_qrtz_site_t_c on qrtz_site_triggers(sched_name,calendar_name);
create index IF NOT EXISTS idx_qrtz_site_t_g on qrtz_site_triggers(sched_name,trigger_group);
create index IF NOT EXISTS idx_qrtz_site_t_state on qrtz_site_triggers(sched_name,trigger_state);
create index IF NOT EXISTS idx_qrtz_site_t_n_state on qrtz_site_triggers(sched_name,trigger_name,trigger_group,trigger_state);
create index IF NOT EXISTS idx_qrtz_site_t_n_g_state on qrtz_site_triggers(sched_name,trigger_group,trigger_state);
create index IF NOT EXISTS idx_qrtz_site_t_next_fire_time on qrtz_site_triggers(sched_name,next_fire_time);
create index IF NOT EXISTS idx_qrtz_site_t_nft_st on qrtz_site_triggers(sched_name,trigger_state,next_fire_time);
create index IF NOT EXISTS idx_qrtz_site_t_nft_misfire on qrtz_site_triggers(sched_name,misfire_instr,next_fire_time);
create index IF NOT EXISTS idx_qrtz_site_t_nft_st_misfire on qrtz_site_triggers(sched_name,misfire_instr,next_fire_time,trigger_state);
create index IF NOT EXISTS idx_qrtz_site_t_nft_st_misfire_grp on qrtz_site_triggers(sched_name,misfire_instr,next_fire_time,trigger_group,trigger_state);

create index IF NOT EXISTS idx_qrtz_site_ft_trig_inst_name on qrtz_site_fired_triggers(sched_name,instance_name);
create index IF NOT EXISTS idx_qrtz_site_ft_inst_job_req_rcvry on qrtz_site_fired_triggers(sched_name,instance_name,requests_recovery);
create index IF NOT EXISTS idx_qrtz_site_ft_j_g on qrtz_site_fired_triggers(sched_name,job_name,job_group);
create index IF NOT EXISTS idx_qrtz_site_ft_jg on qrtz_site_fired_triggers(sched_name,job_group);
create index IF NOT EXISTS idx_qrtz_site_ft_t_g on qrtz_site_fired_triggers(sched_name,trigger_name,trigger_group);
create index IF NOT EXISTS idx_qrtz_site_ft_tg on qrtz_site_fired_triggers(sched_name,trigger_group);