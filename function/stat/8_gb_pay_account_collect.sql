DROP FUNCTION IF EXISTS gb_pay_account_collect(comp_url text);
CREATE OR REPLACE FUNCTION gb_pay_account_collect(comp_url text)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/09/21  Chan     创建此函数: 收集各站点pay_account
--v1.01  2016/10/24  Leisure  关联sys_site，增加comp_id, master_id字段
--v1.02  2017/07/01  Leisure  拼数据源时增加了机房的判断
--v1.03  2017/07/10  Leisure  修改DBLINK连接方式，回收SU
*/
DECLARE
  rec   record;
  rec_ds record;
  site_url text;
  pc_id int;

BEGIN

  TRUNCATE TABLE pay_account_collection;

  --v1.03  2017/07/10  Leisure
  perform dblink_connect_u('mainsite', comp_url);

  FOR rec_ds IN
    SELECT comp_id, master_id, site_id, site_name, ip, port, dbname, username, password
      FROM dblink('mainsite',
                  'SELECT parent_id comp_id, sys_user_id master_id, d.id site_id, d.name site_name,
                          CASE idc WHEN ''A'' THEN ip ELSE remote_ip END, CASE idc WHEN ''A'' THEN port ELSE remote_port END, dbname, username, password
                     FROM sys_site s, sys_datasource d where s.id = d.id
                    ORDER BY site_id')
        AS si( comp_id INT, master_id INT, site_id INT, site_name varchar(16),
               ip varchar(15), port int4, dbname varchar(32), username varchar(32), password varchar(128)
             )
  LOOP
    site_url = 'host=' || rec_ds.ip || ' port=' || rec_ds.port || ' dbname=' || rec_ds.dbname || ' user=' || rec_ds.username || ' password=' || rec_ds.password;

    RAISE INFO '正在收集站点：%', rec_ds.username;
    FOR rec IN
      SELECT "id", pay_name, account, full_name, disable_amount, pay_key,
        status, create_time, create_user, type, account_type, bank_code, pay_url,
        code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
        effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
        full_rank, custom_bank_name, open_acount_name, qr_code_url, remark
      FROM dblink(site_url,
        'select id, pay_name, account, full_name, disable_amount, pay_key,
        status, create_time, create_user, type, account_type, bank_code, pay_url,
        code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
        effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
        full_rank, custom_bank_name, open_acount_name, qr_code_url, remark from pay_account')
            AS a("id" int4, pay_name varchar(100), account varchar(200), full_name varchar(200), disable_amount int4, pay_key varchar(200),
        status varchar, create_time timestamp(6), create_user int4, type varchar(50), account_type varchar(50), bank_code varchar(50), pay_url varchar(200),
        code varchar(10), deposit_count int4, deposit_total numeric(20,2), deposit_default_count int4, deposit_default_total numeric(20,2),
        effective_minutes int4, single_deposit_min int4, single_deposit_max int4, frozen_time timestamp(6), channel_json text,
        full_rank bool, custom_bank_name varchar(32), open_acount_name varchar(100), qr_code_url varchar(200), remark varchar(512))

    LOOP
      raise info 'id = %, pay_name = %', rec."id", rec.pay_name;

      INSERT INTO pay_account_collection (comp_id, master_id, site_id, site_name, pay_account_id, pay_name, account, full_name, disable_amount, pay_key,
        status, create_time, create_user, type, account_type, bank_code, pay_url,
        code, deposit_count, deposit_total, deposit_default_count, deposit_default_total,
        effective_minutes, single_deposit_min, single_deposit_max, frozen_time, channel_json,
        full_rank, custom_bank_name, open_acount_name, qr_code_url, remark
      ) VALUES (
        rec_ds.comp_id, rec_ds.master_id, rec_ds.site_id, rec_ds.site_name, rec.id, rec.pay_name, rec.account, rec.full_name, rec.disable_amount, rec.pay_key,
        rec.status, rec.create_time, rec.create_user, rec.type, rec.account_type, rec.bank_code, rec.pay_url,
        rec.code, rec.deposit_count, rec.deposit_total, rec.deposit_default_count, rec.deposit_default_total,
        rec.effective_minutes, rec.single_deposit_min, rec.single_deposit_max, rec.frozen_time, rec.channel_json,
        rec.full_rank, rec.custom_bank_name, rec.open_acount_name, rec.qr_code_url, rec.remark
      ) RETURNING "id" into pc_id;
      raise info 'pay_account_collection.新增.键值 = %', pc_id;

    END LOOP;
  END LOOP;

  perform dblink_disconnect('mainsite');
  raise info '统计 % END', rec_ds.site_name;

END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;

COMMENT ON FUNCTION gb_pay_account_collect(comp_url text) IS 'Chan-收集各站点收款账户';
