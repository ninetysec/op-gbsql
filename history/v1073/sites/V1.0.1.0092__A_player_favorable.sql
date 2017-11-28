-- auto gen by admin 2016-04-11 21:57:35
ALTER TABLE player_favorable alter COLUMN "player_transaction_id"  DROP not NULL;

UPDATE sys_resource SET  "name" = '投注记录' WHERE "id"='43';