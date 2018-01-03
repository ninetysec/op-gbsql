-- auto gen by cherry 2016-08-10 11:45:13
 select redo_sqls($$
       ALTER TABLE player_transfer ADD COLUMN operate_id int4;
			 ALTER TABLE player_transfer ADD COLUMN operator varchar(32);
$$);

COMMENT on COLUMN player_transfer.operate_id is '操作者id';

COMMENT on COLUMN player_transfer.operator is '操作者账号';


