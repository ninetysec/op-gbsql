-- auto gen by tom 2016-03-04 09:27:43
select redo_sqls($$
    ALTER TABLE "notice_param_relation" ADD COLUMN "param_name" varchar(100);
  $$);
COMMENT ON COLUMN "notice_param_relation"."param_name" IS '参数名称';

UPDATE notice_param_relation SET param_name='notice.param.user' where param_code='${user}';
UPDATE notice_param_relation SET param_name='notice.param.unfreezetime' where param_code='${unfreezetime}';
UPDATE notice_param_relation SET param_name='notice.param.sitename' where param_code='${sitename}';
UPDATE notice_param_relation SET param_name='notice.param.website' where param_code='${website}';
UPDATE notice_param_relation SET param_name='notice.param.customer' where param_code='${customer}';
UPDATE notice_param_relation SET param_name='notice.param.year' where param_code='${year}';
UPDATE notice_param_relation SET param_name='notice.param.month' where param_code='${month}';
UPDATE notice_param_relation SET param_name='notice.param.day' where param_code='${day}';
UPDATE notice_param_relation SET param_name='notice.param.operatetime' where param_code='${operatetime}';
UPDATE notice_param_relation SET param_name='notice.param.orderlaunchtime' where param_code='${orderlaunchtime}';
UPDATE notice_param_relation SET param_name='notice.param.orderamount' where param_code='${orderamount}';
UPDATE notice_param_relation SET param_name='notice.param.ordernum' where param_code='${ordernum}';
UPDATE notice_param_relation SET param_name='notice.param.saleapplytime' where param_code='${saleapplytime}';
UPDATE notice_param_relation SET param_name='notice.param.saleactivityname' where param_code='${saleactivityname}';
UPDATE notice_param_relation SET param_name='notice.param.period' where param_code='${period}';
UPDATE notice_param_relation SET param_name='notice.param.perioddetail' where param_code='${perioddetail}';
UPDATE notice_param_relation SET param_name='notice.param.account' where param_code='${account}';
UPDATE notice_param_relation SET param_name='notice.param.finalwithdrawal' where param_code='${finalwithdrawal}';
