-- auto gen by cherry 2017-03-13 10:26:13
select redo_sqls($$

	alter table api_type_relation ADD COLUMN rebate_order_num int4;

$$);

COMMENT ON COLUMN api_type_relation.rebate_order_num is '返佣统计顺序';

update api_type_relation set rebate_order_num = 1   where api_id =9  and api_type_id =1;

update api_type_relation set rebate_order_num = 2   where api_id =10 and api_type_id =1;

update api_type_relation set rebate_order_num = 3   where api_id =1  and api_type_id =1;

update api_type_relation set rebate_order_num = 4   where api_id =7  and api_type_id =1;

update api_type_relation set rebate_order_num = 5   where api_id =8  and api_type_id =1;

update api_type_relation set rebate_order_num = 6   where api_id =17 and api_type_id =1;

update api_type_relation set rebate_order_num = 7   where api_id =16 and api_type_id =1;

update api_type_relation set rebate_order_num = 8   where api_id =3  and api_type_id =1;

update api_type_relation set rebate_order_num = 9   where api_id =5  and api_type_id =1;

update api_type_relation set rebate_order_num = 10  where api_id =12 and api_type_id =3 ;

update api_type_relation set rebate_order_num = 11  where api_id =19 and api_type_id =3 ;

update api_type_relation set rebate_order_num = 12  where api_id =4  and api_type_id =3 ;

update api_type_relation set rebate_order_num = 13  where api_id =10 and api_type_id =3 ;

update api_type_relation set rebate_order_num = 14  where api_id =9  and api_type_id =2 ;

update api_type_relation set rebate_order_num = 15  where api_id =10 and api_type_id =2 ;

update api_type_relation set rebate_order_num = 16  where api_id =6  and api_type_id =2 ;

update api_type_relation set rebate_order_num = 17  where api_id =15 and api_type_id =2 ;

update api_type_relation set rebate_order_num = 18  where api_id =3  and api_type_id =2 ;

update api_type_relation set rebate_order_num = 19  where api_id =14 and api_type_id =2 ;

update api_type_relation set rebate_order_num = 20  where api_id =10 and api_type_id =4 ;

update api_type_relation set rebate_order_num = 21  where api_id =2  and api_type_id =4 ;

update api_type_relation set rebate_order_num = 22  where api_id =11 and api_type_id =4 ;