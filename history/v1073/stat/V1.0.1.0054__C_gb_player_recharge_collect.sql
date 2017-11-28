-- auto gen by wayne 2016-11-30 19:53:11
drop function if exists gb_player_recharge_collection(comp_url text,recharge_date text);
CREATE OR REPLACE FUNCTION gb_player_recharge_collection(comp_url text,recharge_date text)
	RETURNS "pg_catalog"."void" AS $BODY$

/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/12/03  wayne     创建此函数: 收集各站点player_recharge线上支付记录数,用来统计各家线上支付的掉单率
*/
DECLARE
	rec   record;
	rec_ds record;
	site_url text;
	pc_id int;
	d_static_date DATE;
	select_sql text;
BEGIN
	d_static_date := to_date(recharge_date, 'YYYY-MM-DD');
	DELETE FROM player_recharge_collection t where t.recharge_date=d_static_date;

	FOR rec_ds IN
	SELECT comp_id, master_id, site_id, site_name, ip, port, dbname, username, password
	FROM dblink(comp_url,
							'SELECT parent_id comp_id, sys_user_id master_id, d.id site_id, d.name site_name,
                      ip, port, dbname, username, password
                 FROM sys_site s, sys_datasource d where s.id = d.id
                ORDER BY site_id')
		AS si( comp_id INT, master_id INT, site_id INT, site_name varchar(16),
			 ip varchar(15), port int4, dbname varchar(32), username varchar(32), password varchar(128)
			 )
	LOOP
		site_url = 'host=' || rec_ds.ip || ' port=' || rec_ds.port || ' dbname=' || rec_ds.dbname || ' user=' || rec_ds.username || ' password=' || rec_ds.password;
		select_sql = 'SELECT (string_to_array(pa.bank_code, ''_''))[1] channel_code,pa.bank_code channel_sub_code,SUM(1) total_num,SUM(CASE WHEN pr.check_username IS NOT NULL THEN 1 END) lost_num,
			SUM(CASE WHEN pr.recharge_status=''5'' THEN 1 END) success_num,
			SUM(CASE WHEN pr.recharge_status=''6'' THEN 1 END) fail_num,
			SUM(CASE WHEN pr.recharge_status=''4'' THEN 1 END) process_num
		  FROM player_recharge pr	LEFT JOIN pay_account pa ON pr.pay_account_id = pa. ID
			WHERE	recharge_type_parent = ''online_deposit''
					 AND pr.create_time >= ''' || recharge_date::date::timestamp || ''' AND pr.create_time < ''' || (recharge_date::date::timestamp + '1 day') || '''
		GROUP BY pa.bank_code';

		RAISE INFO '正在收集站点：%,site_url: %,select_sql: %', rec_ds.username,site_url,select_sql;
		FOR rec IN
		SELECT channel_code, channel_sub_code, total_num, lost_num,success_num,fail_num,process_num
		FROM dblink(site_url,select_sql)
			AS a("channel_code" varchar(32), channel_sub_code varchar(32), total_num INTEGER, lost_num INTEGER, success_num INTEGER, fail_num INTEGER, process_num INTEGER)

		LOOP
			raise info 'channel_code = %, channel_sub_code = %', rec.channel_code, rec.channel_sub_code;

			INSERT INTO player_recharge_collection
			(comp_id, master_id, site_id, site_name, channel_code, channel_sub_code, total_num, lost_num, recharge_date,success_num,fail_num,process_num,create_time) VALUES
				(rec_ds.comp_id, rec_ds.master_id, rec_ds.site_id, rec_ds.site_name, rec.channel_code, rec.channel_sub_code, rec.total_num, rec.lost_num,d_static_date,
												 rec.success_num,rec.fail_num,rec.process_num,now()
				) RETURNING "id" into pc_id;
			raise info 'player_recharge_collection.新增.键值 = %', pc_id;

		END LOOP;
	END LOOP;
	raise info '统计 % END', rec_ds.site_name;

END;

$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100
;

