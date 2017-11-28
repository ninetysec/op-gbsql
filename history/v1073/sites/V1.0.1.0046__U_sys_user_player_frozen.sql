-- auto gen by orange 2016-03-04 16:21:25
DROP VIEW IF EXISTS v_sys_user_player_frozen;

CREATE OR REPLACE VIEW "v_sys_user_player_frozen" AS
 SELECT _user.id,
    _user.username,
    _user.status,
    _user.site_id,
    _user.freeze_type,
    _user.account_freeze_remark,
    _user.freeze_start_time,
    _user.freeze_end_time,
    _player.balance_type,
    _player.balance_freeze_start_time,
    _player.balance_freeze_end_time,
    _player.balance_freeze_remark,
    _player.id AS player_id,
    _line.online_status,
    _user.default_locale,
    _user.freeze_title,
    _user.freeze_content,
    _player.balance_freeze_title,
    _player.balance_freeze_content,
    _user.freeze_user,
    _user.disabled_user,
    _user.disabled_time,
    _user.freeze_time
   FROM ((sys_user _user
     LEFT JOIN user_player _player ON ((_user.id = _player.id)))
     LEFT JOIN ( SELECT count(1) AS online_status,
            sys_on_line_session.sys_user_id
           FROM sys_on_line_session
          GROUP BY sys_on_line_session.sys_user_id) _line ON ((_user.id = _line.sys_user_id)));

ALTER TABLE "v_sys_user_player_frozen" OWNER TO "postgres";

COMMENT ON VIEW "v_sys_user_player_frozen" IS '玩家账号冻结--tom';