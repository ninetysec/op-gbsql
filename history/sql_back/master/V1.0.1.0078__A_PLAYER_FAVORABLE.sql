-- auto gen by cheery 2015-09-17 19:06:01
--修改玩家优惠表-优惠稽核倍数类型
ALTER TABLE player_favorable ALTER COLUMN audit_favorable_multiple TYPE numeric(20,2);
