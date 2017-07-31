-- auto gen by cherry 2017-07-28 15:18:33
update api_order_log set currency ='CNY' where api_id in ('3','10','16')  and currency is null;

INSERT into api_order_log(api_id,start_id,update_time,"type",start_time,is_need_account,end_id,end_time,ext_json,gametype,currency)   select api_id,start_id,update_time,"type",start_time,is_need_account,end_id,end_time,ext_json,gametype,'JPY' from api_order_log where api_id in ('3','10','16') and currency='CNY' and NOT EXISTS (select * from  api_order_log where api_id in ('3','10','16') and  currency ='JPY' );