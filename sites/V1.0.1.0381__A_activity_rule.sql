-- auto gen by cherry 2017-02-07 10:55:16
select redo_sqls($$
    ALTER TABLE activity_rule ADD COLUMN is_need_apply boolean;
$$);

COMMENT ON COLUMN activity_rule.is_need_apply  IS '是否需要申请';