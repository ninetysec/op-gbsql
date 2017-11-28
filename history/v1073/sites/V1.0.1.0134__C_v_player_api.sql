-- auto gen by admin 2016-05-04 20:25:08
  select redo_sqls($$
        ALTER TABLE player_transfer ADD COLUMN transfer_source varchar(32);
      $$);

COMMENT ON COLUMN "player_transfer"."transfer_source" IS '转账来源：1-player:玩家转账、2-recovery:回收资金转账';
DROP VIEW IF EXISTS v_player_api;
CREATE OR REPLACE VIEW  "v_player_api" AS
 SELECT t1.api_id,
    t1.user_id,
    t1.user_name,
    t1.account,
    t1.currency,
    t1.locale,
    t1.last_login_ip,
    t1.last_login_time,
    t1.additional_result,
    t1.password,
    t2.id,
    t2.abnormal_reason,
    t2.is_transaction,
    t2.last_recovery_status,
    t2.last_recovery_time,
    t2.money,
    t2.synchronization_status,
    t2.synchronization_time,
    ( SELECT t3.transfer_state
           FROM player_transfer t3
          WHERE ((t3.user_id = t1.user_id) AND (t3.api_id = t1.api_id) AND ((t3.transfer_source)::text = 'recovery'::text))
          ORDER BY t3.id DESC
         LIMIT 1) AS transfer_state
   FROM (player_api_account t1
     LEFT JOIN player_api t2 ON (((t1.api_id = t2.api_id) AND (t1.user_id = t2.player_id))));

COMMENT ON VIEW "v_player_api" IS 'playerApi视图--cherry';


update notice_tmpl set title = '您于${time}申请的¥${plaseMoney}取款订单，审核成功！',default_title = '您于${time}申请的¥${plaseMoney}取款订单，审核成功！' where group_code='2b801fbd304e33367393bdb9bf1d6c24' and event_type='AGENT_WITHDRAWAL_AUDIT_SUCCESS' and publish_method='email' and locale='en_US';

update notice_tmpl set group_code='53d028bf6f2f4e0582cd34e1ed774df8' where event_type='PLAYER_WITHDRAWAL_AUDIT_FAIL' and publish_method='email';

update notice_tmpl set group_code='2b801fbd304e33367393bdb9bf1d6c24' where event_type='AGENT_WITHDRAWAL_AUDIT_SUCCESS' and publish_method='siteMsg';


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege","status")

SELECT '460201', '编辑玩家信息', 'personalInfo/edit.html', '编辑玩家信息', '4602', '', NULL, 'pcenter', 'account:edit', '2', '', 't', 't','t'

WHERE '460201' NOT IN (SELECT id FROM sys_resource WHERE id='460201');



update sys_resource set name='手动存取',remark='手动存取' where id= 305;