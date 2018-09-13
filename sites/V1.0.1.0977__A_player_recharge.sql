-- auto gen by steffan 2018-09-13 11:20:56
 select redo_sqls($$
alter table player_recharge add column "fee_flag" varchar(10) ;
  $$);
  COMMENT ON COLUMN player_recharge.fee_flag IS '是否使用手续费方案';