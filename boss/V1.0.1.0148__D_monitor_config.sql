-- auto gen by Wayne 2016-09-27 21:42:45
DELETE FROM monitor_config_relation where config_id = (SELECT "id" FROM monitor_config where type_name='so.wwb.gamebox.service.boss.taskschedule.TaskRunRecordService' and method_name='update');
DELETE FROM monitor_data_result where config_id = (SELECT "id" FROM monitor_config where type_name='so.wwb.gamebox.service.boss.taskschedule.TaskRunRecordService' and method_name='update');
DELETE FROM monitor_config where type_name='so.wwb.gamebox.service.boss.taskschedule.TaskRunRecordService' and method_name='update';



