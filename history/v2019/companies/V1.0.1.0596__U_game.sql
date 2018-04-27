-- auto gen by linsen 2018-04-13 16:21:09

--修改game表的can_try字段null的为false by pack
UPDATE game SET can_try='f' where can_try is null;
