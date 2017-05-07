-- auto gen by admin 2016-06-14 14:51:01
 select redo_sqls($$
      ALTER TABLE site_rebate ADD COLUMN history_apportion numeric(20,2);
      $$);


COMMENT ON COLUMN site_rebate.history_apportion IS '历史分摊费用';

drop function if exists gamebox_station_bill(TEXT, TEXT, TEXT, TEXT, INT);

create or replace function gamebox_station_bill(

	main_url 	TEXT,

	master_url 	TEXT,

	start_time 	TEXT,

	end_time 	TEXT,

	flag 	INT

	)returns TEXT as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：账务(站长、总代)-入口

--v1.01  2016/06/04  Leisure  取dict_map之前，先同步site_info表,

                              如果账务日期不为1号，则取1号日期

*/

DECLARE

	rec 		record;

	cnum 		INT;



	category 	TEXT:='API';

	keys 		TEXT[];

	sub_keys 	TEXT[];

	sub_key 	TEXT:='';

	col_split 	TEXT:='_';

	num_map 	hstore;



	maps 		hstore[];

	sys_map 	hstore;		-- 优惠分摊比例

	api_map 	hstore;

	expense_map hstore;

	dict_map 	hstore;		-- 运营商，站长，账务类型等信息

	param 		TEXT:='';

	sid 		INT;		-- 站点ID.

	val 		FLOAT;

	date_time 	TIMESTAMP;

	c_year 		INT;

	c_month 	INT;



	player_num 	INT;

	bill_id 	INT;

	rtn 		TEXT;

	bill_no 	TEXT;		-- 账务流水号

BEGIN

	IF ltrim(rtrim(master_url)) = '' THEN

		RAISE EXCEPTION '-1, 站点库URL为空';

	END IF;



	perform dblink_close_all();

	perform dblink_connect('master',  master_url);



	SELECT  * FROM dblink(

		'master', 'SELECT  * FROM gamebox_sys_param(''apportionSetting'')'

	) as p(h hstore) INTO sys_map;



	raise info 'sys_map: %', sys_map;



	sid = (sys_map->'site_id')::INT;



	--v1.01  2016/06/04  Leisure

	perform gamebox_collect_site_infor(main_url);

	SELECT gamebox_site_map(sid) INTO dict_map;



	--v1.01  2016/06/04  Leisure

	date_time = start_time::TIMESTAMP;

	IF extract(day FROM date_time) <> '1' THEN

		date_time = date_time + '1 day';

	END IF;



	SELECT extract(year FROM date_time) INTO c_year;

	SELECT extract(month FROM date_time) INTO c_month;



	dict_map = (SELECT ('year=>'||c_year)::hstore)||dict_map;

	dict_map = (SELECT ('month=>'||c_month)::hstore)||dict_map;



	SELECT put(dict_map, 'bill_type', flag::TEXT) into dict_map; 	-- 账务类型



	raise info 'dict_map: %', dict_map;



	-- raise info '运营商，站长，账务类型等信息(dict_map) = %', dict_map;



	SELECT put(sys_map, 'backwater_percent', sys_map->'topagent.rakeback.percent') 		into sys_map;

	SELECT put(sys_map, 'refund_fee_percent', sys_map->'topagent.poundage.percent') 	into sys_map;

	SELECT put(sys_map, 'favourable_percent', sys_map->'topagent.preferential.percent') 	into sys_map;

	SELECT put(sys_map, 'rebate_percent', sys_map->'topagent.rebate.percent') 			into sys_map;



	-- raise info '优惠分摊比例(sys_map) = %', sys_map;



	-- 删除重复运行记录.

	DELETE FROM station_bill_other WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT);

	DELETE FROM station_profit_loss WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT);

	DELETE FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT;



	IF flag = 1 THEN 		-- 计算站长账务

		-- 站长账单流水号

		SELECT gamebox_generate_order_no('B', sid::TEXT, '03', 'master') INTO bill_no;

		SELECT put(dict_map, 'bill_no', bill_no) into dict_map;

		SELECT gamebox_station_bill_master(sys_map, dict_map, 'master', main_url, start_time, end_time) INTO rtn;

	ELSEIF flag = 2 THEN	-- 计算总代账务

		-- 总代账单流水号

		SELECT gamebox_generate_order_no('B', sid::TEXT, '04', 'master') INTO bill_no;

		SELECT put(dict_map, 'bill_no', bill_no) into dict_map;

		SELECT gamebox_station_bill_top(sys_map, dict_map, 'master', main_url, start_time, end_time) INTO rtn;

	END IF;



	--关闭连接

	perform dblink_disconnect('master');



	RETURN '0';

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_station_bill(main_url TEXT, master_url TEXT, start_time TEXT, end_time TEXT, flag INT)

IS 'Lins-账务(站长、总代)-入口';