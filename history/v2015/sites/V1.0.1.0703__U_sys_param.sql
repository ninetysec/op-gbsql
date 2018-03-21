-- auto gen by linsen 2018-03-11 14:21:12
-- 更新易收付出款operate字段 by linsen
UPDATE sys_param SET operate='0' WHERE module ='fund' AND  param_type = 'withdraw' AND param_code='easy_payment';
