-- auto gen by admin 2016-04-13 21:22:37
------------------------------sys_dict-------------------------------------------------------
delete from sys_dict where (dict_type='master_question1' or dict_type='master_question2' or dict_type='master_question3') and module='setting' ;

---安全提示问题1
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question1', '1', '1', '您小时候最喜欢哪一本书？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question1', '2', '2', '您的理想工作是什么？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question1', '3', '3', '您童年时代的绰号是什么？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values ('setting', 'master_question1', '4', '4', '您拥有的第一辆车是什么型号？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question1', '5', '5', '您在学生时代最喜欢哪个歌手或乐队？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question1', '6', '6', '您在学生时代最喜欢哪个电影明星或角色？', NULL, 't');


---安全提示问题2
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question2', '1', '1', '您的第一个上司叫什么名字？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question2', '2', '2', '您的父母是在哪里认识的？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values ('setting', 'master_question2', '3', '3', '您的第一个宠物叫什么名字？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question2', '4', '4', '您少年时代最好的朋友叫什么名字？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question2', '5', '5', '您第一次去电影院看的是哪一部电影？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question2', '6', '6', '您学会做的第一道菜是什么？', NULL, 't');

---安全提示问题3
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values ('setting', 'master_question3', '1', '1', '您上小学时最喜欢的老师姓什么？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question3', '2', '2', '您第一次坐飞机是去哪里？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question3', '3', '3', '您从小长大的那条街叫什么？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question3', '4', '4', '您去过的第一个海滨浴场是哪一个？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question3', '5', '5', '您购买的第一张专辑是什么？', NULL, 't');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") values  ('setting', 'master_question3', '6', '6', '您最喜欢哪个球队？', NULL, 't');