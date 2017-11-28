-- auto gen by cheery 2015-12-30 11:35:58
ALTER TABLE site_operate DROP COLUMN IF EXISTS site_num;
ALTER TABLE site_operate DROP COLUMN IF EXISTS top_agent_num;
ALTER TABLE site_operate DROP COLUMN IF EXISTS agent_num;

ALTER TABLE master_operate DROP COLUMN IF EXISTS site_id;
ALTER TABLE master_operate DROP COLUMN IF EXISTS site_name;
ALTER TABLE master_operate DROP COLUMN IF EXISTS master_num;
ALTER TABLE master_operate DROP COLUMN IF EXISTS site_num;
ALTER TABLE master_operate DROP COLUMN IF EXISTS top_agent_num;
ALTER TABLE master_operate DROP COLUMN IF EXISTS agent_num;

drop table IF EXISTS sys_master_report;