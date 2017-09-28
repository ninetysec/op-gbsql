-- auto gen by cherry 2017-09-28 20:00:42
--select f_summary_lottery_order('host=192.168.0.88 port=5501 dbname=gb-sites  user=gb-site-1 password=postgres',1 ,'bjpk10' ,'77' );

drop function IF EXISTS f_summary_lottery_order(TEXT, int, TEXT, TEXT);
create or replace function f_summary_lottery_order(
  conn   TEXT,
  siteid  int,
  code   TEXT,
  expect   TEXT
) returns text as $$


DECLARE
  rtn   text:='';
  v_count  int:=0;
  querysql  VARCHAR;--汇总数据查询
    text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  querysql = 'SELECT * from lottery_bet_order t where t.code= ''' || code  || ''' and t.expect=''' ||expect  || '''' ;
    raise notice '汇总数据查询语句 %', querysql;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  perform dblink_connect_u('master', conn);
  rtn = rtn||'|开始执行,彩种:'||code||'期号:'||expect||'彩票汇总记录';
  INSERT INTO lottery_order_summary(
    expect, code, play_code, bet_code, bet_num, odd, bet_amount, payout, create_time, user_id, site_id
  ) SELECT
      a.expect, a.code, a.play_code, a.bet_code, a.bet_num,a.odd,a.bet_amount,a.payout, now(),a.user_id ,siteid
    FROM
      dblink ('master',
              'SELECT expect, code, play_code, bet_code, bet_num, odd, bet_amount, payout, now(), user_id from lottery_bet_order t where t.code= ''' || code  || ''' and t.expect=''' || expect  || ''' '
      )AS a(
             expect varchar,
             code varchar,
             play_code varchar,
             bet_code varchar,
             bet_num varchar,
             odd NUMERIC,
             bet_amount NUMERIC,
             payout NUMERIC,
             create_time timestamp,
             user_id int
           );

 GET DIAGNOSTICS v_count = ROW_COUNT;
  raise notice '本次插入数据量 %', v_count;
	perform dblink_disconnect('master');
  RETURN v_count;

	EXCEPTION
    		WHEN OTHERS THEN
					GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,  text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    				RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;
    				GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    				RAISE NOTICE E'--- Call Stack ---\n%', text_var4;
	RETURN text_var4;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION f_summary_lottery_order(  conn TEXT, siteid int, code TEXT, expect TEXT)
IS '彩票汇总任务';