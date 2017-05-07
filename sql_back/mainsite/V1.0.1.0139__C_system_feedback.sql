-- auto gen by cheery 2015-12-10 09:05:49
---创建意见反馈表
CREATE TABLE if not EXISTS system_feedback (
  id SERIAL4 PRIMARY KEY NOT NULL,
  center_id INT4,
  master_id INT4,
  site_id INT4,
  site_name VARCHAR(32),
  topagent_id INT4,
  topagent_name VARCHAR(32),
  agent_id INT4,
  agent_name VARCHAR(32),
  feedback_content VARCHAR(2048),
  feedback_id INT4,
  feedback_name VARCHAR(32),
  feedback_time TIMESTAMP,
  is_read BOOL
);

ALTER TABLE system_feedback OWNER TO postgres;
COMMENT ON TABLE system_feedback IS '意见反馈表 - eagle';
COMMENT ON COLUMN system_feedback.id IS '主键';
COMMENT ON COLUMN system_feedback.center_id IS '运营商ID';
COMMENT ON COLUMN system_feedback.master_id IS '站长id';
COMMENT ON COLUMN system_feedback.site_id IS '站点id';
COMMENT ON COLUMN system_feedback.site_name IS '站点账号';
COMMENT ON COLUMN system_feedback.topagent_id IS '总代id';
COMMENT ON COLUMN system_feedback.topagent_name IS '总代账号';
COMMENT ON COLUMN system_feedback.agent_id IS '代理id';
COMMENT ON COLUMN system_feedback.agent_name IS '代理账号';
COMMENT ON COLUMN system_feedback.feedback_content IS '反馈内容';
COMMENT ON COLUMN system_feedback.feedback_id IS '反馈人id';
COMMENT ON COLUMN system_feedback.feedback_name IS '反馈人账号';
COMMENT ON COLUMN system_feedback.feedback_time IS '反馈时间';
COMMENT ON COLUMN system_feedback.is_read IS '是否已读';

---修改菜单
UPDATE sys_resource set name = "replace"(name, '账','账') where name LIKE '%账%';

DROP VIEW IF EXISTS v_sub_account;
CREATE OR REPLACE VIEW v_sub_account  as
---是否包含重要角色
SELECT
	su.user_type,
	su. ID,
	su.username,
	su.status,
	su.create_time,
  	su.real_name,
  	su.nickname,
	array_to_json(array(SELECT name FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) roles,
	array_to_json(array(SELECT id FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) )) role_ids,
	(SELECT CASE WHEN count(1) > 0 then true else false end built_in FROM sys_role where id in( SELECT role_id from sys_user_role where user_id = su.id) and built_in )built_in,
  su.owner_id
FROM
	sys_user su
where su.user_type in ('11') and status in ('1','2');
COMMENT ON VIEW "v_sub_account" IS '子账户视图';
ALTER TABLE "sys_role" ALTER COLUMN "code" DROP NOT NULL;