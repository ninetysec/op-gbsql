-- auto gen by tom 2015-12-18 15:49:12
ALTER TABLE "contract_favourable_grads" DROP COLUMN "favourable_value";
ALTER TABLE "contract_favourable_grads" ADD COLUMN "favourable_value"  numeric(20,2);
COMMENT ON COLUMN "contract_favourable_grads"."favourable_value" IS '优惠值';
