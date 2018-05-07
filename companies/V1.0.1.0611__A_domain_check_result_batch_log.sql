-- auto gen by linsen 2018-05-07 16:54:17
--添加字段, 为domain_check_result_batch_log表增加task_id，用于手动提交检测任务时使用。by hanson

select redo_sqls($$
		ALTER table domain_check_result_batch_log add column task_id character varying(32);
$$);

COMMENT ON COLUMN domain_check_result_batch_log.task_id IS '手动检测任务号';