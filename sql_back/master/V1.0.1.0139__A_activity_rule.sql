-- auto gen by cheery 2015-10-23 16:17:41
ALTER TABLE activity_preferential_relation DROP IF EXISTS "order";

select redo_sqls($$
  ALTER TABLE activity_rule ADD COLUMN preferential_amount_limit numeric(20,2);

  ALTER TABLE activity_preferential_relation ADD COLUMN order_column int4;

  ALTER TABLE activity_message_i18n ADD COLUMN activity_overview varchar(200);

  ALTER TABLE activity_message ADD COLUMN is_deleted bool;
$$);

ALTER TABLE activity_rule  ALTER COLUMN effective_time TYPE VARCHAR(20);

COMMENT ON COLUMN activity_rule.preferential_amount_limit IS '优惠金额上限';

COMMENT ON COLUMN activity_preferential_relation.order_column IS '档次';

COMMENT ON COLUMN activity_message_i18n.activity_overview IS '活动概述';

COMMENT ON COLUMN activity_message.is_deleted IS '活动是否删除';
