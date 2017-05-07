-- auto gen by jason 2016-01-21 02:58:42

delete from notice_tmpl where event_type in ('SCHEDULE_OVERTIME','SCHEDULE_EXCEPTION');

INSERT INTO "notice_tmpl" VALUES (nextval('notice_tmpl_id_seq'::regclass), 'auto', 'SCHEDULE_OVERTIME', 'siteMsg', 'schedule-overtime-group', 't', 'zh_TW', '定时任务超时', '定时任务超时，任务流水号：${id},任务ID:${taskScheduleId},任务名称：${jobName}',  't', 'title', 'content', '2016-01-15 08:30:54.267665', '1', '2016-01-15 10:11:56', null, 't');
INSERT INTO "notice_tmpl" VALUES ( nextval('notice_tmpl_id_seq'::regclass),'auto', 'SCHEDULE_OVERTIME', 'siteMsg', 'schedule-overtime-group', 't', 'zh_US', '定时任务超时', '定时任务超时，任务流水号：${id},任务ID:${taskScheduleId},任务名称：${jobName}',  't', 'title', 'content', '2016-01-15 08:30:54.267665', '1', '2016-01-15 10:11:56', null, 't');
INSERT INTO "notice_tmpl" VALUES ( nextval('notice_tmpl_id_seq'::regclass),'auto', 'SCHEDULE_OVERTIME', 'siteMsg', 'schedule-overtime-group', 't', 'zh_CN', '定时任务超时', '定时任务超时，任务流水号：${id},任务ID:${taskScheduleId},任务名称：${jobName}',  't', 'title', 'content', '2016-01-15 08:30:54.267665', '1', '2016-01-15 10:11:56', null, 't');

INSERT INTO "notice_tmpl" VALUES (nextval('notice_tmpl_id_seq'::regclass),'auto', 'SCHEDULE_EXCEPTION', 'siteMsg', 'schedule-exception-group', 't', 'zh_TW', '定时任务异常', '定时任务异常，任务流水号：${id},任务ID:${taskScheduleId},任务名称：${jobName}',  't', 'title', 'content', '2016-01-15 08:30:54.267665', '1', '2016-01-15 10:11:56', null, 't');
INSERT INTO "notice_tmpl" VALUES (nextval('notice_tmpl_id_seq'::regclass), 'auto', 'SCHEDULE_EXCEPTION', 'siteMsg', 'schedule-exception-group', 't', 'zh_US', '定时任务异常', '定时任务异常，任务流水号：${id},任务ID:${taskScheduleId},任务名称：${jobName}',  't', 'title', 'content', '2016-01-15 08:30:54.267665', '1', '2016-01-15 10:11:56', null, 't');
INSERT INTO "notice_tmpl" VALUES (nextval('notice_tmpl_id_seq'::regclass), 'auto', 'SCHEDULE_EXCEPTION', 'siteMsg', 'schedule-exception-group', 't', 'zh_CN', '定时任务异常', '定时任务异常，任务流水号：${id},任务ID:${taskScheduleId},任务名称：${jobName}',  't', 'title', 'content', '2016-01-15 08:30:54.267665', '1', '2016-01-15 10:11:56', null, 't');

