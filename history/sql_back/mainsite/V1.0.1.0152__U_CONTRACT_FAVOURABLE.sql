-- auto gen by tom 2015-12-11 16:09:12
select redo_sqls($$
    ALTER TABLE "contract_favourable_grads" alter COLUMN "profit_lower" type  numeric(20,2);
    ALTER TABLE "contract_favourable_grads" alter COLUMN "profit_limit"  type numeric(20,2);
$$);