-- auto gen by wayne 2016-11-30 19:53:11
CREATE TABLE IF NOT EXISTS player_transfer_collection (

	id serial NOT NULL,
	transfer_type character varying(32) NOT NULL,
	api_id integer,
	comp_id integer,
	master_id integer,
	site_id integer NOT NULL,
	site_name character varying,
	transfer_date date,
	total_num integer,
	lost_num integer,
	success_num integer,
	fail_num integer,
	process_num integer,
	create_time TIMESTAMP,
	CONSTRAINT player_transfer_collection_pkey PRIMARY KEY (id)
)

WITH (OIDS=FALSE)
;


COMMENT ON TABLE player_transfer_collection IS '转账订单统计表--wayne';

COMMENT ON COLUMN player_transfer_collection.site_id IS '站点ID';

COMMENT ON COLUMN player_transfer_collection.transfer_date IS '转账日期';
COMMENT ON COLUMN player_transfer_collection.total_num IS '订单总数';
COMMENT ON COLUMN player_transfer_collection.lost_num IS '掉单数';
COMMENT ON COLUMN player_transfer_collection.success_num IS '成功数';
COMMENT ON COLUMN player_transfer_collection.fail_num IS '失败数';
COMMENT ON COLUMN player_transfer_collection.process_num IS '处理中的订单数';
