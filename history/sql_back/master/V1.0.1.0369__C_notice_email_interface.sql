-- auto gen by cogo 2016-01-31 09:48:43
DROP VIEW IF EXISTS v_notice_email_interface;
DROP VIEW IF EXISTS v_notice_email_rank;

ALTER TABLE notice_email_interface ALTER COLUMN "account_password" TYPE varchar(128) COLLATE "default";

CREATE OR REPLACE VIEW "v_notice_email_interface" AS
 SELECT a.id,
    a.user_group_type,
    a.user_group_id,
    a.server_address,
    a.server_port,
    a.email_account,
    a.account_password,
    a.built_in,
    a.name,
    a.create_time,
    a.update_time,
    a.send_count,
    a.status,
    b.remarks,
    b.define_table,
    c.rank_name AS user_group_name,
    a.reply_email_account,
    a.test_email_account
   FROM ((notice_email_interface a
     LEFT JOIN notice_receiver_group b ON (((a.user_group_type)::text = (b.type)::text)))
     LEFT JOIN player_rank c ON ((a.user_group_id = c.id)));

CREATE OR REPLACE VIEW "v_notice_email_rank" AS
 SELECT a.id,
    b.rankids,
    a.name,
    a.built_in,
    a.create_time,
    a.status,
    a.email_account,
    a.account_password,
    a.send_count,
    a.server_address,
    a.server_port,
    b.account,
    b.rankname
   FROM (( SELECT DISTINCT (notice_email_interface.status)::integer AS id,
            notice_email_interface.name,
            notice_email_interface.create_time,
            notice_email_interface.account_password,
            notice_email_interface.status,
            notice_email_interface.email_account,
            notice_email_interface.built_in,
            notice_email_interface.send_count,
            notice_email_interface.server_address,
            notice_email_interface.server_port
           FROM notice_email_interface) a
     LEFT JOIN ( SELECT notice_email_interface.email_account AS account,
            string_agg(((notice_email_interface.user_group_id)::character varying)::text, ','::text) AS rankids,
            string_agg((player_rank.rank_name)::text, ','::text) AS rankname
           FROM (notice_email_interface
             JOIN player_rank ON ((notice_email_interface.user_group_id = player_rank.id)))
          GROUP BY notice_email_interface.email_account) b ON (((a.email_account)::text = (b.account)::text)));

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'content', 'depositAccountWarning', 'deposit.reset.days.next.time', '0', '0', '11', '账户下次清零时间', '', 't', NULL
WHERE 'deposit.reset.days.next.time' NOT in(SELECT param_code FROM sys_param WHERE module='content' AND param_type='depositAccountWarning');

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'content', 'payAccountWarning', 'deposit.reset.days.next.time', '0', '0', '11', '账户下次清零时间', '', 't', NULL
WHERE 'deposit.reset.days.next.time' not in(SELECT param_code FROM sys_param WHERE module='content' AND param_type='payAccountWarning');

