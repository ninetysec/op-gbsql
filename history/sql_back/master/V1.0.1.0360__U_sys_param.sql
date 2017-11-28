-- auto gen by cherry 2016-01-27 11:30:52
ALTER TABLE "user_player_transfer" ALTER COLUMN "real_name" TYPE varchar(32) COLLATE "default";

UPDATE sys_param SET default_value='5' WHERE param_type='privilage_pass_time' and param_code='setting.privilage.pass.time';

UPDATE sys_param
SET default_value = '[{"bulitIn":"true","id":1,"sort":1,"name":"regCode","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"true","id":2,"sort":2,"name":"username","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"true","id":3,"sort":3,"name":"password","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"true","id":4,"sort":4,"name":"verificationCode","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"true","id":5,"sort":5,"name":"defaultTimezone","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"false","id":6,"sort":6,"name":"countryCity","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":7,"sort":7,"name":"sex","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":8,"sort":8,"name":"nickName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":9,"sort":9,"name":"defaultLocale","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":10,"sort":10,"name":"302","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":11,"sort":11,"name":"110","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":12,"sort":12,"name":"birthday","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":13,"sort":13,"name":"201","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":14,"sort":14,"name":"paymentPassword","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":15,"sort":15,"name":"realName","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":16,"sort":16,"name":"301","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":17,"sort":17,"name":"serviceTerms","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":18,"sort":18,"name":"securityIssues","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":19,"sort":19,"name":"mainCurrency","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":20,"sort":20,"name":"303","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":21,"sort":21,"name":"constellation","isRequired":"1","isRegField":"1","status":"0"}]'
WHERE
	MODULE = 'setting' AND param_type = 'reg_setting' AND param_code = 'field_setting';

UPDATE sys_param
SET default_value = '[{"bulitIn":"true","id":1,"sort":1,"name":"regCode","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"true","id":2,"sort":2,"name":"username","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"true","id":3,"sort":3,"name":"password","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"true","id":4,"sort":4,"name":"verificationCode","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"true","id":5,"sort":5,"name":"defaultTimezone","isRequired":"0","isRegField":"0","status":"0"},{"bulitIn":"false","id":6,"sort":6,"name":"countryCity","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":7,"sort":7,"name":"paymentPassword","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":8,"sort":8,"name":"defaultLocale","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":9,"sort":9,"name":"mainCurrency","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":10,"sort":10,"name":"303","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":11,"sort":11,"name":"201","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":12,"sort":12,"name":"nickName","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":13,"sort":13,"name":"sex","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":14,"sort":14,"name":"302","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":15,"sort":15,"name":"110","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":16,"sort":16,"name":"birthday","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":17,"sort":17,"name":"realName","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":18,"sort":18,"name":"301","isRequired":"1","isRegField":"1","status":"1"},{"bulitIn":"false","id":19,"sort":19,"name":"serviceTerms","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":20,"sort":20,"name":"securityIssues","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":21,"sort":21,"name":"resource","isRequired":"1","isRegField":"1","status":"0"},{"bulitIn":"false","id":22,"sort":22,"name":"constellation","isRequired":"1","isRegField":"1","status":"0"}]'
WHERE
	MODULE = 'setting' AND param_type = 'reg_setting_agent' AND param_code = 'field_setting';


DELETE from sys_param WHERE param_type='sys_tone_audit';
DELETE from sys_param WHERE param_type='sys_tone_draw';
DELETE from sys_param WHERE param_type='sys_tone_notice';
DELETE from sys_param WHERE param_type='sys_tone_warm';
DELETE from sys_param WHERE param_type='sys_tone_onlinePay';


UPDATE sys_param SET default_value='musics/notice/facebook.mp3' WHERE param_code='notice' AND param_type='warming_tone_project';
UPDATE sys_param SET default_value='musics/audit/hmdxls.mp3' WHERE param_code='audit' AND param_type='warming_tone_project';
UPDATE sys_param SET default_value='musics/warm/xtjbs.mp3' WHERE param_code='warm' AND param_type='warming_tone_project';
UPDATE sys_param SET default_value='musics/draw/dxls.mp3' WHERE param_code='draw' AND param_type='warming_tone_project';
UPDATE sys_param SET default_value='musics/deposit/tssd.mp3' WHERE param_code='deposit' AND param_type='warming_tone_project';
UPDATE sys_param SET default_value='musics/onlinePay/msn.mp3' WHERE param_code='onlinePay' AND param_type='warming_tone_project';


DROP VIEW IF EXISTS v_notice_email_rank;
CREATE OR REPLACE VIEW v_notice_email_rank AS
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
