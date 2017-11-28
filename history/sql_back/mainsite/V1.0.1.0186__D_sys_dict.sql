-- auto gen by cheery 2015-12-28 09:11:55
delete from sys_dict where dict_type='game_type' or dict_type='game_type_parent';

select redo_sqls($$
    ALTER TABLE system_feedback ADD COLUMN center_name varchar(32);
    ALTER TABLE system_feedback ADD COLUMN master_name varchar(32);
    ALTER TABLE system_feedback ADD COLUMN user_type varchar(5);
$$);

COMMENT ON COLUMN system_feedback.center_name IS '运营商账号';
COMMENT ON COLUMN system_feedback.master_name IS '站长账号';
COMMENT ON COLUMN system_feedback.user_type IS '用户类型';