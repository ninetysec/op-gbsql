-- auto gen by tom 2016-02-15 14:08:51
UPDATE contract_favourable set favourable_limit=favourable_limit*10000;
UPDATE contract_favourable_grads set profit_lower=profit_lower*10000,profit_limit=profit_limit*10000;

UPDATE contract_favourable_grads set favourable_value=favourable_value*10000 where contract_favourable_id in (select id from contract_favourable where favourable_way='1');

update contract_occupy_grads set profit_lower=profit_lower*10000,profit_limit=profit_limit*10000;
