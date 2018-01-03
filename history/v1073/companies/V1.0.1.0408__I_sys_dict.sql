-- auto gen by cherry 2017-09-01 20:53:36
INSERT INTO   sys_dict  (module ,  dict_type ,  dict_code ,  order_num ,  remark ,  parent_code ,  active)         select         'lottery', 'lottery_type', 'sfc', '5', '十分彩', NULL, 't'
WHERE NOT EXISTS(SELECT dict_code FROM sys_dict WHERE  dict_code='sfc');

INSERT INTO   sys_dict  (module ,  dict_type ,  dict_code ,  order_num ,  remark ,  parent_code ,  active)         select         'lottery', 'lottery_type', 'keno', '6', '快乐彩', NULL, 't'
WHERE NOT EXISTS(SELECT dict_code FROM sys_dict WHERE  dict_code='keno');

INSERT INTO  sys_dict  (module ,  dict_type ,  dict_code ,  order_num ,  remark ,  parent_code ,  active)         select         'lottery', 'lottery_type', 'xy28', '7', '幸运28', NULL, 't'
WHERE NOT EXISTS(SELECT dict_code FROM sys_dict WHERE  dict_code='xy28');

INSERT INTO sys_dict  (module ,  dict_type ,  dict_code ,  order_num ,  remark ,  parent_code ,  active)         select         'lottery', 'lottery_type', 'pl3', '8', '排列3', NULL, 't'
WHERE  NOT EXISTS(SELECT dict_code FROM sys_dict WHERE  dict_code='pl3');

INSERT INTO  sys_dict  (module ,  dict_type ,  dict_code ,  order_num ,  remark ,  parent_code ,  active)         select         'lottery', 'lottery_type', 'qt', '9', '其他', NULL, 't'
WHERE NOT EXISTS(SELECT dict_code FROM sys_dict WHERE  dict_code='qt');

CREATE INDEX if not EXISTS "lottery_winning_record_cp_idx" ON "lottery_winning_record" USING btree (code, expect);
