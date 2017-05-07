-- auto gen by wayne 2016-12-02 16:52:11
CREATE TABLE IF NOT EXISTS player_recharge_collection (

	id serial NOT NULL,
	channel_code character varying(32) NOT NULL,
	channel_sub_code character varying(32) NOT NULL,
	comp_id integer,
	master_id integer,
	site_id integer NOT NULL,
	site_name character varying,
	recharge_date date,
	total_num integer,
	lost_num integer,
	success_num integer,
	fail_num integer,
	process_num integer,
	create_time TIMESTAMP,
	CONSTRAINT player_recharge_collection_pkey PRIMARY KEY (id)
)

WITH (OIDS=FALSE)
;


COMMENT ON TABLE player_recharge_collection IS '线上支付订单统计表--wayne';

COMMENT ON COLUMN player_recharge_collection.site_id IS '站点ID';

COMMENT ON COLUMN player_recharge_collection.recharge_date IS '支付日期';
COMMENT ON COLUMN player_recharge_collection.total_num IS '订单总数';
COMMENT ON COLUMN player_recharge_collection.lost_num IS '掉单数';
COMMENT ON COLUMN player_recharge_collection.success_num IS '成功数';
COMMENT ON COLUMN player_recharge_collection.fail_num IS '失败数';
COMMENT ON COLUMN player_recharge_collection.process_num IS '待支付的订单数';
