-- auto gen by cheery 2015-10-23 16:35:20
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'claim_period', 'NaturalDay', '1', '自然日', 't'
  WHERE 'NaturalDay' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'claim_period');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'claim_period', 'NatureWeek', '2', '自然周', 't'
  WHERE 'NatureWeek' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'claim_period');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'claim_period', 'NaturalMonth', '3', '自然月', 't'
  WHERE 'NaturalMonth' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'claim_period');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'claim_period', 'ActivityCycle', '4', '活动周期', 't'
  WHERE 'ActivityCycle' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'claim_period');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'effective_time', 'OneDay', '1', '1天内', 't'
  WHERE 'OneDay' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'effective_time');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'effective_time', 'TwoDays', '2', '2天内', 't'
  WHERE 'TwoDays' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'effective_time');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'effective_time', 'ThreeDays', '3', '3天内', 't'
  WHERE 'ThreeDays' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'effective_time');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'effective_time', 'SevenDays', '4', '7天内', 't'
  WHERE 'SevenDays' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'effective_time');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'effective_time', 'ThirtyDays', '5', '30天内', 't'
  WHERE 'ThirtyDays' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'effective_time');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "active")
  SELECT 'operation', 'effective_time', 'ActivityCycle', '6', '活动周期', 't'
  WHERE 'ActivityCycle' NOT IN (SELECT dict_code from sys_dict where module = 'operation' and dict_type = 'effective_time');
