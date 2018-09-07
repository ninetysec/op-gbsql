-- auto gen by steffan 2018-09-07 10:32:24
--##创建APP打包任务表 hanson 180907
CREATE TABLE IF NOT EXISTS app_package_task
(
    Id varchar(50) PRIMARY KEY,
    site_id integer NOT NULL,
    box_type varchar(5) NOT NULL,
    app_name varchar(50) NOT NULL,
    logo_in_start_up varchar(1) DEFAULT 0 NOT NULL,
    create_time timestamp NOT NULL,
    run_end_time timestamp,
    status varchar(1) DEFAULT 0 NOT NULL,
    create_user varchar(50) NOT NULL
);
COMMENT ON COLUMN app_package_task.id IS '任务ID';
COMMENT ON COLUMN app_package_task.site_id IS '站点ID';
COMMENT ON COLUMN app_package_task.box_type IS '包网类型';
COMMENT ON COLUMN app_package_task.app_name IS 'app名称';
COMMENT ON COLUMN app_package_task.logo_in_start_up IS '启动图是否需要LOGO';
COMMENT ON COLUMN app_package_task.create_time IS '创建时间';
COMMENT ON COLUMN app_package_task.run_end_time IS '任务执行完毕时间';
COMMENT ON COLUMN app_package_task.status IS '任务执行状态：0=未执行，1=被取消，2=执行成功，3=执行失败';
COMMENT ON COLUMN app_package_task.create_user IS '创建者';
COMMENT ON TABLE app_package_task IS 'app打包任务表';