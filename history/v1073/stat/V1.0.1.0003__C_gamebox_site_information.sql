-- auto gen by cheery 2016-03-04 10:05:58

/**
 * 收集站点总代.代理.玩家等信息.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	main_url 	运营商库.dblink格式URL
 * @param 	master_urls 站点库.dblink格式URL(多库, 以分隔符分开)
 * @param 	split 		分隔符.
 */
drop function if exists gamebox_site_information(TEXT, TEXT, TEXT);
create or replace function gamebox_site_information(
	main_url TEXT,
	master_urls TEXT,
	split TEXT
) returns TEXT as $$
DECLARE
	dblink_urls TEXT[];

BEGIN
	IF ltrim(rtrim(main_url)) = '' THEN
		raise info '-1, 运营商URL为空';
		RETURN '1, 运营商URL为空';
	ELSEIF ltrim(rtrim(master_urls)) = '' THEN
		raise info '-1, 站点库URL为空';
		RETURN '2, 站点库URL为空';
	ELSEIF ltrim(rtrim(split))='' THEN
		raise info '-1, 分隔符为空';
		RETURN '3, 分隔符为空';
  	END IF;

	dblink_urls:=regexp_split_to_array(master_urls, split);

	IF array_length(dblink_urls,  1) > 0 THEN

		perform dblink_close_all();
		perform gamebox_collect_site_infor(main_url);

		FOR i IN 1..array_length(dblink_urls,  1)
		LOOP
			perform gamebox_role_information(dblink_urls[i]);
		END LOOP;

	END IF;
	RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_information(main_url TEXT, master_urls TEXT, split TEXT)
IS 'Lins-收集站点总代.代理.玩家数-入口';

/**
 * 收集站点总代.代理.玩家等信息.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	dblink_url 	运营商库.dblink格式URL
 */
drop function if exists gamebox_role_information(TEXT);
create or replace function gamebox_role_information(
	dblink_url TEXT
) returns void as $$
DECLARE
	rec record;
	cnum INT;

BEGIN
	IF ltrim(rtrim(dblink_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	perform dblink_connect('master', dblink_url);

	FOR rec IN
		SELECT * FROM dblink (
			'master',
			'SELECT gamebox_current_site() as site_id,
					COUNT(CASE user_type WHEN ''22'' THEN ID END) as top_agent_num,
					COUNT(CASE user_type WHEN ''23'' THEN ID END) as agent_num,
					COUNT(CASE user_type WHEN ''24'' THEN ID END) as player_num
			  FROM sys_user') as a(site_id int, top_agent_num int, agent_num int, player_num int)
		LEFT JOIN sys_site_info s ON a.site_id = s.siteid

	LOOP
		--判断记录是否存在.
		SELECT count(1) INTO cnum FROM site_information WHERE site_id = rec.site_id;
		raise info 'cnum=%', cnum;
		raise info 'site_id=%', rec.site_id;

		IF cnum > 0 THEN
			UPDATE site_information
			   SET center_id 	= rec.operationid,
			   	   center_name 	= rec.operationname,
			   	   master_id 	= rec.masterid,
			   	   master_name 	= rec.mastername,
			   	   site_name 	= rec.sitename,
			   	   topagent_num = rec.top_agent_num,
			   	   agent_num 	= rec.agent_num,
			   	   player_num 	= rec.player_num
			 WHERE site_id	= rec.site_id;
		ELSE
			INSERT INTO site_information(
				center_id, center_name, master_id, master_name,
				site_id, site_name, topagent_num, agent_num, player_num
			)VALUES(
				rec.operationid, rec.operationname, rec.masterid, rec.mastername,
				rec.siteid, rec.sitename, rec.top_agent_num, rec.agent_num, rec.player_num
			);
			SELECT currval(pg_get_serial_sequence('site_information',  'id')) into cnum;
			raise info 'site_information.完成.键值:%', cnum;
		END IF;

		GET DIAGNOSTICS cnum = ROW_COUNT;
		raise notice '本次涉及数据量 %',  cnum;
	END LOOP;

	perform dblink_disconnect('master');
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_role_information(dblink_url TEXT)
IS 'Lins-收站点总代.代理.玩家等信息';

/*
--测试收集站点玩家数.
SELECT * FROM gamebox_site_information
(
	'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres',
	'host=192.168.0.88 dbname=gamebox-master user=postgres password=postgres|host=192.168.0.88 dbname=gamebox-master2 user=postgres password=postgres',
	'\|'
);
 */
