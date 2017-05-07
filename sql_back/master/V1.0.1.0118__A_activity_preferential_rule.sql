-- auto gen by cheery 2015-10-14 14:34:37
ALTER TABLE activity_preferential_rule DROP COLUMN IF EXISTS preferential_way_id;
ALTER TABLE activity_preferential_rule DROP COLUMN IF EXISTS preferential_lower_name;
ALTER TABLE activity_preferential_rule DROP COLUMN IF EXISTS preferential_lower_limit;
ALTER TABLE activity_preferential_rule DROP COLUMN IF EXISTS preferential_upper_name;
ALTER TABLE activity_preferential_rule DROP COLUMN IF EXISTS preferential_upper_limit;
ALTER TABLE activity_preferential_rule DROP COLUMN IF EXISTS preferential_value;

select redo_sqls($$
  ALTER TABLE activity_preferential_rule ADD COLUMN preferential_code varchar(32);
  ALTER TABLE activity_preferential_rule ADD COLUMN preferential_name varchar(100);
  ALTER TABLE activity_preferential_rule ADD COLUMN preferential_operate varchar(32);
$$);

COMMENT ON COLUMN activity_preferential_rule.preferential_code IS '优惠代码';

COMMENT ON COLUMN activity_preferential_rule.preferential_name IS '优惠名称';

COMMENT ON COLUMN activity_preferential_rule.preferential_operate IS '优惠操作符';
