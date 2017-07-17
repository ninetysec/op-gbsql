-- auto gen by cherry 2017-07-15 18:30:25
DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rakeback_bill (
  name       TEXT,
  start_time     TIMESTAMP,
  end_time     TIMESTAMP,
  INOUT bill_id   INT,
  op         TEXT,
  flag       TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-返水周期主表
--v1.01  2016/05/30  Leisure  改为returning，防止并发
--v1.02  2017/01/18  Leisure  没有返水玩家，依然保留返水总表记录
--v1.10  2017/07/01  Leisure  增加pending_lssuing字段，以支持返水重结
*/
DECLARE
  pending_lssuing text:='pending_lssuing';
  pending_pay   text:='pending_pay';
  rec       record;
  max_back_water   float:=0.00;
  backwater     float:=0.00;
  rp_count    INT:=0;  -- rakeback_player 条数

BEGIN
  IF flag='Y' THEN--已出账

    IF op='I' THEN
      --先插入返水总记录并取得键值.
      INSERT INTO rakeback_bill (
         period, start_time, end_time,
         player_count, player_lssuing_count, player_reject_count, rakeback_total, rakeback_actual,
         create_time, lssuing_state
      ) VALUES (
         name, start_time, end_time,
         0, 0, 0, 0, 0,
         now(), pending_pay
      ) returning id into bill_id;

      --改为returning，防止并发 Leisure 20160530
      --SELECT currval(pg_get_serial_sequence('rakeback_bill',  'id')) into bill_id; --v1.01  2016/05/30  Leisure

    ELSE
      SELECT COUNT(1) FROM rakeback_player WHERE rakeback_bill_id = bill_id INTO rp_count;
      IF rp_count > 0 THEN
        FOR rec IN
          SELECT rakeback_bill_id,
               COUNT(DISTINCT player_id)   as cl,
               SUM(rakeback_total)       as sl
            FROM rakeback_player
           WHERE rakeback_bill_id = bill_id
           GROUP BY rakeback_bill_id
        LOOP
          --v1.10  2017/07/01  Leisure
          UPDATE rakeback_bill SET player_count = rec.cl, rakeback_total = rec.sl, rakeback_pending = rec.sl WHERE id = bill_id;
        END LOOP;
      --ELSE
        --DELETE FROM rakeback_bill WHERE id = bill_id;
      END IF;
    END IF;

  ELSEIF flag='N' THEN--未出账

    IF op='I' THEN
      --先插入返水总记录并取得键值.
      INSERT INTO rakeback_bill_nosettled (
         start_time, end_time, player_count, rakeback_total, create_time
      ) VALUES (
         start_time, end_time, 0, 0, now()
      ) returning id into bill_id;

      --改为returning，防止并发 Leisure 20160530
      --SELECT currval(pg_get_serial_sequence('rakeback_bill_nosettled', 'id')) into bill_id;
    ELSE
      SELECT COUNT(1) FROM rakeback_player_nosettled WHERE rakeback_bill_nosettled_id = bill_id INTO rp_count;
      -- raise info '---- rp_count = %', rp_count;
      IF rp_count > 0 THEN
        FOR rec in
          SELECT rakeback_bill_nosettled_id,
               COUNT(DISTINCT player_id)   as cl,
               SUM(rakeback_total)       as sl
            FROM rakeback_player_nosettled
           WHERE rakeback_bill_nosettled_id = bill_id
           GROUP BY rakeback_bill_nosettled_id
        LOOP
          --v1.10  2017/07/01  Leisure
          UPDATE rakeback_bill_nosettled SET player_count = rec.cl, rakeback_total = rec.sl WHERE id = bill_id;
        END LOOP;
        DELETE FROM rakeback_bill_nosettled WHERE id <> bill_id;
      --ELSE
        --DELETE FROM rakeback_bill_nosettled WHERE id = bill_id;
      END IF;
    END IF;

  END IF;
  raise info 'rakeback_bill.完成.键值:%', bill_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, bill_id INT, op TEXT, flag TEXT)
IS 'Lins-返水-返水周期主表';


DROP FUNCTION IF EXISTS gb_rakeback_player(INT, TEXT);
create or replace function gb_rakeback_player(
  p_bill_id   INT,
  p_settle_flag   TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/18  Leisure  创建此函数: 返水.玩家返水
--v1.10  2017/07/01  Leisure  增加pending_lssuing字段，以支持返水重结
*/
DECLARE

BEGIN

  IF p_settle_flag = 'Y' THEN--已出账

    INSERT INTO rakeback_player(
        rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker, settlement_state,
        agent_id, top_agent_id, audit_num, rakeback_total, rakeback_actual, rakeback_paid, rakeback_pending
    )
    SELECT p_bill_id, ut.id, ut.username, ut.rank_id, ut.rank_name, ut.risk_marker, 'pending_lssuing',
           ut.agent_id, ut.topagent_id, ra.audit_num, ra.rakeback, ra.rakeback, 0, ra.rakeback
      FROM (
            SELECT player_id,
                   CASE WHEN SUM(rakeback) > MIN(rakeback_limit) THEN MIN(rakeback_limit) ELSE SUM(rakeback) END rakeback, --顺序不能改，因为返水上限可能为NULL
                   MIN(audit_num) audit_num,
                   SUM(effective_transaction) effective_transaction
              FROM rakeback_api
             WHERE rakeback_bill_id = p_bill_id
             GROUP BY player_id
          ) ra,
          v_sys_user_tier ut
     WHERE ra.player_id = ut."id"
     ORDER BY ra.rakeback DESC, ut.id;

  ELSEIF p_settle_flag = 'N' THEN--未出账

    INSERT INTO rakeback_player_nosettled (
        rakeback_bill_nosettled_id, player_id, username, rank_id, rank_name, risk_marker,
        agent_id, top_agent_id, audit_num, rakeback_total
    )
    SELECT p_bill_id, ut.id, ut.username, ut.rank_id, ut.rank_name, ut.risk_marker,
           ut.agent_id, ut.topagent_id, ra.audit_num, ra.rakeback
      FROM (
            SELECT player_id,
                   CASE WHEN SUM(rakeback) > MIN(rakeback_limit) THEN MIN(rakeback_limit) ELSE SUM(rakeback) END rakeback, --顺序不能改，因为返水上限可能为NULL
                   MIN(audit_num) audit_num,
                   SUM(effective_transaction) effective_transaction
              FROM rakeback_api_nosettled
             WHERE rakeback_bill_nosettled_id = p_bill_id
             GROUP BY player_id
           ) ra,
           v_sys_user_tier ut,
           user_player up
     WHERE ra.player_id = ut.id
       AND ra.player_id = up."id"
     ORDER BY ra.rakeback DESC, ut.id;

  END IF;

END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_player(p_bill_id INT, p_settle_flag TEXT)
IS 'Leisure-返水.玩家返水';


DROP FUNCTION IF EXISTS gb_rakeback_recount(TEXT, TEXT, TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_rakeback_recount(
  p_comp_url  TEXT,
  p_period   TEXT,
  p_start_time   TEXT,
  p_end_time   TEXT,
  p_settle_flag   TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/06/26  Leisure  创建此函数: 返水结算账单.返水重结

  返回值说明：0成功，1警告，2错误
*/
DECLARE

  t_start_time   TIMESTAMP;
  t_end_time   TIMESTAMP;
  n_sid  INT;
  n_return_code INT := 0;

  --rec_rb.id INT;
  --rec_rbn.id INT;

  rec_rb  RECORD;
  rec_rbn RECORD;

  v_remark varchar(50) := '';
  t_sql text;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  t_start_time = clock_timestamp()::timestamp(0);

  perform gb_rakeback(p_period, p_start_time, p_end_time, 'N');

  BEGIN

    SELECT *
      INTO rec_rb
      FROM rakeback_bill WHERE start_time = p_start_time::TIMESTAMP;

    IF NOT FOUND THEN
      RAISE NOTICE '本期返水未结算，不能执行返水补录操作！';
      RETURN 2;
    END IF;

    SELECT *
      INTO rec_rbn
      FROM rakeback_bill_nosettled WHERE start_time = p_start_time::TIMESTAMP;

    IF NOT FOUND THEN
      RAISE NOTICE '本期返水补录账单未生成，不能执行返水补录操作！';
      RETURN 2;
    END IF;

  EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE '本期返水账单异常，任务失败！';
    RETURN 2;
  END;

  IF rec_rb.player_count = rec_rbn.player_count AND rec_rbn.rakeback_total = rec_rbn.rakeback_total THEN
    RAISE NOTICE '返水人数、总额无变化，不需要返水重结！';
    v_remark = '返水人数、总额无变化，不需要返水重结！';
  ELSE

    --更新返水结算账单
    WITH rpn AS (
      SELECT * FROM rakeback_player_nosettled  WHERE rakeback_bill_nosettled_id = rec_rbn.id
    ),
    rp AS (
      SELECT * FROM rakeback_player  WHERE rakeback_bill_id = rec_rb.id
    ),
    rpj AS (
      SELECT
          rpn.*,
          COALESCE(rp.rakeback_paid, 0.00) rakeback_paid, --已付返水
          rpn.rakeback_total - COALESCE(rp.rakeback_total, 0.00) + COALESCE(rp.rakeback_pending, 0.00) rakeback_pending --返水差额 +此前未结
        FROM rpn
        LEFT JOIN rp ON rpn.player_id = rp.player_id
       WHERE rpn.rakeback_total <> COALESCE(rp.rakeback_total, -1)
    )
    --SELECT * FROM rpj
    INSERT INTO rakeback_player (
        rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker, settlement_state, remark,
        agent_id, top_agent_id, audit_num, rakeback_total, rakeback_actual, rakeback_paid, rakeback_pending
    )
    SELECT rec_rb.id, player_id, username, rank_id, rank_name, risk_marker, 'pending_lssuing', '返水补录',
           agent_id, top_agent_id, audit_num, rakeback_total, rakeback_pending, rakeback_paid, rakeback_pending
      FROM rpj
     --WHERE rakeback_total <> 0
    ON CONFLICT ON CONSTRAINT rakeback_player_uc
    DO UPDATE SET rakeback_total = excluded.rakeback_total,
                  rakeback_pending = rakeback_player.rakeback_pending,
                  remark = COALESCE(rakeback_player.remark, '返水补录');

    UPDATE rakeback_bill rb
       SET player_count = rbn.player_count,
           rakeback_total = rbn.rakeback_total,
           rakeback_pending = rbn.rakeback_total - rb.rakeback_total + rb.rakeback_pending,
           settlement_state = CASE rb.settlement_state WHEN 'pending_lssuing' THEN 'pending_lssuing' ELSE 'part_pay' END
      FROM ( SELECT * FROM rakeback_bill_nosettled rbni WHERE rbni.id = rec_rbn.id ) rbn
     WHERE rb.id = rec_rb.id
       AND rb.rakeback_total <> rbn.rakeback_total;
  END IF;

  t_end_time = clock_timestamp()::timestamp(0);

  SELECT gamebox_current_site() INTO n_sid;

  --perform dblink_close_all();
  --perform dblink_connect('master',  p_comp_url);
  t_sql = 'SELECT * from gb_task_infomation_site( ''' || n_sid || ''', ''gb_rakeback_recount'', ''返水补录'', ''' || p_period || ''', ''1'', ''' ||
           t_start_time || ''', ''' || t_end_time || ''', ''' || v_remark || ''')';
  RAISE INFO '%', t_sql;

  IF 'mainsite' IN ( SELECT unnest(dblink_get_connections()) ) THEN
    PERFORM dblink_disconnect('mainsite');
  END IF;

  PERFORM dblink_connect_u('mainsite', p_comp_url);

  SELECT t.return_code
    INTO n_return_code
    FROM
    dblink ('mainsite',
            t_sql
           ) AS t(return_code INT);
  --perform dblink_disconnect('master');

  PERFORM dblink_disconnect('mainsite');
  --PERFORM dblink_close('mainsite');

  IF n_return_code <> 0 THEN
    RAISE INFO '任务记录未成功写入远端表';
  END IF;

RETURN 0;

EXCEPTION
  WHEN QUERY_CANCELED THEN
    RETURN 2;
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    RETURN 2;
END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_recount( p_comp_url  TEXT, p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Leisure-返水结算账单.返水重结';


DROP FUNCTION IF EXISTS f_agent_rebate(p_stat_month text, p_start_time text, p_end_time text, p_api_type_order_json text, p_com_url text);
CREATE OR REPLACE FUNCTION f_agent_rebate(p_stat_month text, p_start_time text, p_end_time text, p_api_type_order_json text, p_com_url text)
  RETURNS varchar AS $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/03/03  younger  创建此函数: 返佣结算账单-入口
--v1.10  2017/03/30  Leisure  修复上月无相应gametype数据时本期无法累加等bug
--v1.01  2017/06/05  Leisure  修复重跑会删除已结记录的bug，改由operate_agent统计

  -- p_stat_month 统计月份
  -- p_start_time 统计开始时间
  -- p_end_time 统计结束时间
  -- p_api_type_order_json API返佣排序
  --生成JSON串语句：
  --SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT api_id, api_type_id, rebate_order_num FROM api_type_relation ORDER BY rebate_order_num ) t
  --运行函数
  --SELECT f_agent_rebate('2017-02','2017-01-31 16:00:00','2017-02-28 16:00:00','','url');

  --rebate_status: ("0", "未处理"), ("1", "未达到门坎"), ("2", "清除"), ("3", "已结算");
*/
DECLARE

  t_start_time   TIMESTAMP;--查询开始时间
  t_end_time   TIMESTAMP;--查询结束时间
  t_start_date DATE;
  t_end_date DATE;
  v_last_rebate_month VARCHAR;
  b_need_history_count BOOLEAN :=false;--是否需要累计
  v_year INT :=0; --统计年
  v_month INT :=0;--统计月
  v_last_year INT :=0;--上期统计年
  v_last_month INT :=0;--上期统计月
  v_rebate_status VARCHAR;--佣统状态
  n_deposit_radio numeric :=0;--存款率
  n_withdraw_radio numeric :=0;--取款率
  rec_agent RECORD;--代理行记录
  rec_api_relation RECORD;--API关系记录
  rec_api_rebate RECORD;--API返佣记录
  n_agent_rebate_id INT;--代理返佣ID
  n_agent_grads_id INT;--代理满足的梯度ID
  n_valid_value INT;--有效值
  v_api_json VARCHAR;--API JSON串
  n_api_id int; --API临时ID
  n_api_type_id int;--API类型临时ID
  n_payout_total numeric(20,2) :=0; --总派彩
  n_fee_amount numeric(20,2) :=0;--当期行政费用
  rec_api_grads RECORD;--API派彩记录
  n_remain_fee numeric(20,2) :=0;--剩余费用
  n_remain_payout numeric(20,2) :=0;--剩作派彩
  n_fee_total numeric(20,2) :=0;--代理总费用
  idx int := 0 ;--序号
  n_rebate_order_num int;--API返佣排序号
  unsettled RECORD;--数据库连接
  v_temp_sql VARCHAR;--临时SQL
  n_rebate_max numeric(20,2);--最大上限
  cur_agent_rebate refcursor := NULL;

BEGIN
  IF p_stat_month is null or p_stat_month = '' THEN
    raise notice '统计年月为空';
    RETURN '统计年月为空';
  END IF;

  IF (p_api_type_order_json is null or p_api_type_order_json = '') AND (p_com_url is null or p_com_url = '') THEN
    raise notice 'API返佣顺序数据为空';
    RETURN 'API返佣顺序数据为空';
  END IF;

  IF p_api_type_order_json is null or p_api_type_order_json = '' THEN
    raise notice 'API返佣顺序数据为空,从URL获取';
    v_temp_sql = 'SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT api_id, api_type_id,rebate_order_num FROM api_type_relation ORDER BY rebate_order_num ) t';

    PERFORM dblink_connect_u('mainsite', p_com_url);
    FOR unsettled IN
      SELECT * FROM dblink('mainsite', v_temp_sql) as unsettled_temp(v_api_json VARCHAR)
    LOOP
      p_api_type_order_json = unsettled.v_api_json;
    END LOOP;
    perform dblink_disconnect('mainsite');
  END IF;

  --raise notice 'p_api_type_order_json： %', p_api_type_order_json;

  --拆分统计年月
  --SELECT substring(p_stat_month FROM 1 FOR 4) INTO v_year;
  --SELECT substring(p_stat_month FROM 6 FOR 7) INTO v_month;
  v_year = substr(p_stat_month, 1, 4);
  v_month = substr(p_stat_month, 6, 2);

  --上月
  --SELECT to_char(to_date(p_stat_month,'yyyy-mm')+ interval '-1 months','yyyy-mm') INTO v_last_rebate_month;
  v_last_rebate_month = to_date(p_stat_month,'yyyy-mm')+ interval '-1 month';
  --拆分上期统计年月
  IF v_last_rebate_month is not null AND v_last_rebate_month <> '' then
    --SELECT substring(v_last_rebate_month FROM 1 FOR 4) INTO v_last_year;
    --SELECT substring(v_last_rebate_month FROM 6 FOR 7) INTO v_last_month;
    v_last_year = substr(v_last_rebate_month, 1, 4);
    v_last_month = substr(v_last_rebate_month, 6, 2);
  END IF;

  --转换时间格式
  t_start_time = p_start_time::TIMESTAMP;
  t_end_time = p_end_time::TIMESTAMP;

  --统计查询条件年月日
  --SELECT to_date(p_stat_month||'-01','yyyy-mm-dd') INTO t_start_date;
  --SELECT to_date(to_char(t_start_date+ interval '1 months','yyyy-mm-dd'),'yyyy-mm-dd') INTO t_end_date;
  t_start_date = to_date(p_stat_month, 'YYYY-MM');
  t_end_date = t_start_date + interval '1 month';

  raise notice 't_start_date %', t_start_date;
  raise notice 't_end_date %', t_end_date;

  --1、判断统计月份是否存在，有存在，先删除
  --v1.01  2017/06/05  Leisure
  --DELETE FROM agent_rebate_player WHERE rebate_year=v_year AND rebate_month=v_month;
  --DELETE FROM agent_rebate_grads WHERE rebate_year=v_year AND rebate_month=v_month;
  --DELETE FROM agent_rebate WHERE rebate_year=v_year AND rebate_month=v_month;

  --rebate_status: ("0", "未处理"), ("1", "未达到门坎"), ("2", "清除"), ("3", "已结算");
  DELETE FROM agent_rebate_player WHERE rebate_year=v_year AND rebate_month=v_month AND agent_id IN (SELECT agent_id FROM agent_rebate WHERE rebate_year=v_year AND rebate_month=v_month AND rebate_status in('0','1'));
  DELETE FROM agent_rebate_grads WHERE rebate_year=v_year AND rebate_month=v_month AND agent_id IN (SELECT agent_id FROM agent_rebate WHERE rebate_year=v_year AND rebate_month=v_month AND rebate_status in('0','1'));
  DELETE FROM agent_rebate WHERE rebate_year=v_year AND rebate_month=v_month AND rebate_status IN ('0','1');

--2、计算代理的承担费用（即生成agent_rebate_player）
  --SELECT CASE WHEN param_value is NULL THEN default_value ELSE param_value END FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.deposit.fee' INTO n_deposit_radio;
  --SELECT CASE WHEN param_value is NULL THEN default_value ELSE param_value END FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.withdraw.fee' INTO n_withdraw_radio;
  SELECT COALESCE(param_value, default_value) FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.deposit.fee' INTO n_deposit_radio;
  SELECT COALESCE(param_value, default_value) FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.withdraw.fee' INTO n_withdraw_radio;

  --插入代理返佣_玩家费用表
  INSERT INTO agent_rebate_player (
    rebate_year,rebate_month,topagent_id,topagentusername,agent_id,agentusername,user_id,username,deposit_amount,
    deposit_radio,withdraw_amount,withdraw_radio,rakeback_amount,favorable_amount,recommend_amount
  )
  SELECT v_year,v_month,d.id topagent_id,d.username topagentusername,c.id agent_id,c.username agentusername,player_id user_id,b.username username,
         (SELECT COALESCE(sum(transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='deposit' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) deposit_amount,
         COALESCE(n_deposit_radio,0) deposit_radio,
         (SELECT COALESCE(sum(-transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='withdrawals' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) withdraw_amount,
         COALESCE(n_withdraw_radio,0) withdraw_radio,
         (SELECT COALESCE(sum(transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='backwater' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) rakeback_amount,
         (SELECT COALESCE(sum(transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='favorable' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) favorable_amount,
         (SELECT COALESCE(sum(transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='recommend' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) recommend_amount
    FROM
         (SELECT player_id FROM player_transaction WHERE transaction_type<>'transfers'  AND completion_time>= t_start_time AND completion_time < t_end_time GROUP BY player_id) a
         LEFT JOIN sys_user b ON a.player_id = b.id
         LEFT JOIN sys_user c on b.owner_id = c.id
         LEFT JOIN sys_user d on c.owner_id = d.id;

  --3、每个代理生成一条主表数据
  FOR rec_agent IN
    SELECT * FROM sys_user WHERE user_type='23' AND status IN ('1','3') AND id not IN (SELECT agent_id FROM agent_rebate WHERE rebate_year=v_year AND rebate_month=v_month)
  LOOP

    --是否需要累计
    SELECT rebate_status FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id INTO v_rebate_status;
    IF v_rebate_status='0' or v_rebate_status='1' THEN
      b_need_history_count = true;
    ELSE
      b_need_history_count = false;
    END IF;

    --获取代理返佣方案
    SELECT rebate_id FROM user_agent_rebate uar WHERE uar.user_id = rec_agent.id INTO n_agent_rebate_id;
    SELECT valid_value FROM rebate_set WHERE id = n_agent_rebate_id INTO n_valid_value;

    --获取代理满足的佣金梯度、返佣上限
    SELECT id, max_rebate
      INTO n_agent_grads_id, n_rebate_max
      FROM rebate_grads
     WHERE rebate_id=n_agent_rebate_id
       AND total_profit <= (SELECT -sum(profit_loss) FROM operate_player WHERE agent_id = rec_agent.id AND static_date>=t_start_date AND static_date < t_end_date )
       AND valid_player_num <= (SELECT count(1) FROM (SELECT player_id,sum(transaction_volume) tradevalue FROM operate_player WHERE static_date>=t_start_date AND static_date < t_end_date AND agent_id=rec_agent.id  GROUP BY player_id) ta WHERE ta.tradevalue>=n_valid_value)
     ORDER BY total_profit desc, valid_player_num desc limit 1;

    --批量插入数据
    INSERT INTO agent_rebate(
      rebate_year,rebate_month,start_time,end_time,topagent_id,topagentusername,agent_id,agentusername,effective_player_amount,effective_player_num,
      payout_amount_history,payout_amount,effective_amount_history,effective_amount,fee_amount_history,favorable_amount_history,rakeback_amount_history,
      other_amount_history,fee_amount,favorable_amount,rakeback_amount,other_amount,rebate_amount,rebate_amount_actual,rebate_status,create_time
    )
    SELECT rebate_year,rebate_month,t_start_time,t_end_time,topagent_id,topagentusername,agent_id,agentusername,
           --有效玩家的有效投注额
           COALESCE(n_valid_value,0),
           --有效玩家数
           COALESCE((SELECT count(1) FROM (SELECT player_id,sum(effective_transaction) effAmount FROM operate_player WHERE static_date>=t_start_date AND static_date < t_end_date AND agent_id = rec_agent.id GROUP BY player_id) a WHERE a.effAmount>=n_valid_value),0) effective_player_num,
           --累积派彩
           COALESCE((CASE WHEN b_need_history_count THEN
             (SELECT (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) FROM agent_rebate WHERE agent_id = rec_agent.id AND rebate_year = v_last_year AND rebate_month = v_last_month)
             ELSE 0 END),0) payout_amount_history,
           --当期派彩
           COALESCE((SELECT -sum(COALESCE(profit_loss,0)) FROM operate_agent oa WHERE oa.agent_id = rec_agent.id AND oa.static_date>=t_start_date AND oa.static_date<t_end_date),0) payout_amount,
           --累积有效投注额
           COALESCE((CASE WHEN b_need_history_count THEN (
               (SELECT (COALESCE(effective_amount_history,0)+COALESCE(effective_amount,0)) FROM agent_rebate WHERE agent_id = rec_agent.id AND rebate_year = v_last_year AND rebate_month = v_last_month)
             ) ELSE 0 END),0) effective_amount_history,
           --当期有效投注额
           COALESCE((SELECT sum(COALESCE(effective_transaction,0)) FROM operate_agent oa WHERE oa.agent_id = rec_agent.id AND oa.static_date>=t_start_date AND oa.static_date<t_end_date),0) effective_amount,
           --累积行政费用(上一期的累积费用+上一期当期费用)
           COALESCE((CASE WHEN b_need_history_count THEN
               (SELECT (COALESCE(fee_amount_history,0)+COALESCE(fee_amount,0)) history_fee FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id)
             ELSE 0 END),0) fee_amount_history,
           --累积存款优惠
           COALESCE((CASE WHEN b_need_history_count THEN
               (SELECT (COALESCE(favorable_amount_history,0)+COALESCE(favorable_amount,0)) history_favorable FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id)
             ELSE 0 END),0) favorable_amount_history,
           --累积返水优惠
           COALESCE((CASE WHEN b_need_history_count THEN
               (SELECT (COALESCE(rakeback_amount_history,0)+COALESCE(rakeback_amount,0)) history_rakeback FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id)
             ELSE 0 END),0) rakeback_amount_history,
           --累积其他费用
           COALESCE((CASE WHEN b_need_history_count THEN
               (SELECT (COALESCE(other_amount_history,0)+COALESCE(other_amount,0)) FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id)
             ELSE 0 END),0) other_amount_history,
           (sum(COALESCE(deposit_amount,0)*(COALESCE(arp.deposit_radio,0)/100))+sum(COALESCE(withdraw_amount,0)*(COALESCE(arp.withdraw_radio,0)/100))) fee_amount,
           sum(COALESCE(favorable_amount,0)) favorable_amount,
           sum(COALESCE(rakeback_amount,0)) rakeback_amount,
           sum(COALESCE(recommend_amount,0)) other_amount,
           0 rebate_amount,     --返佣金额
           0 rebate_amount_actual,     --已返佣金额
           '0' rebate_status,    --返佣状态
           now()  --创建时间
      FROM agent_rebate_player arp
     WHERE rebate_year = v_year
       AND rebate_month = v_month
       AND agent_id = rec_agent.id
     GROUP BY topagent_id,topagentusername,agent_id,agentusername,rebate_year,rebate_month;

    --4、计算代理各api的总派彩(即生成agent_rebate_grads)

    --当期派彩，从player_game_order直接统计
    --累积派彩，需要看下上一期的返佣账单的状态是否需要累积，需要累积的话，等于上一期的累积派彩+上一期的当期派彩
    /*
    --v1.10  2017/03/30  Leisure
    INSERT INTO agent_rebate_grads(
      rebate_year,rebate_month,topagent_id,topagentusername,agent_id,agentusername,api_id,api_type_id,payout_amount_history,payout_amount,radio
    )
    SELECT v_year,v_month,topagent_id,topagent_name,agent_id,agent_name,api_id,api_type_id,
           COALESCE(
            (CASE
             WHEN b_need_history_count THEN
             (SELECT (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) FROM agent_rebate_grads arg WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=oa.agent_id AND arg.api_id=oa.api_id AND arg.api_type_id = oa.api_type_id
             )
             ELSE 0 END),0) payout_amount_history ,
      SUM(-COALESCE(profit_loss,0)) payout_amount,
      COALESCE((SELECT ratio FROM rebate_grads_api WHERE rebate_grads_id = n_agent_grads_id AND api_id=oa.api_id AND api_type_id=oa.api_type_id),0) radio
      FROM operate_player oa WHERE static_date>=t_start_date AND static_date < t_end_date AND agent_id=rec_agent.id GROUP BY topagent_id,topagent_name,agent_id,agent_name,api_id,api_type_id;
    */
    INSERT INTO agent_rebate_grads (
      rebate_year, rebate_month, agent_id, agentusername, topagent_id, topagentusername, api_id, api_type_id, payout_amount_history, payout_amount, radio
    )
    SELECT v_year, v_month,
           arg.agent_id, ua.username agent_name, ut.id topagent_id, ut.username topagent_name,
           arg.api_id, arg.api_type_id, arg.payout_amount_history, arg.payout_amount, rga.ratio
      FROM
      (
      SELECT COALESCE(op.agent_id, argi.agent_id) agent_id,
             COALESCE(op.api_id, argi.api_id) api_id,
             COALESCE(op.api_type_id, argi.api_type_id) api_type_id,
             CASE WHEN b_need_history_count THEN COALESCE(payout_amount_history, 0) ELSE 0 END payout_amount_history,
             COALESCE(payout_amount, 0) payout_amount
        FROM
        (
        SELECT agent_id, api_id, api_type_id ,
                SUM(-COALESCE(profit_loss,0)) payout_amount
          FROM operate_agent --v1.01  2017/06/05  Leisure
         WHERE static_date >= t_start_date AND static_date < t_end_date AND agent_id= rec_agent.id
         GROUP BY agent_id, api_id, api_type_id
        ) op
          FULL JOIN
        (
        SELECT agent_id, api_id, api_type_id,
               (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) payout_amount_history
          FROM agent_rebate_grads
         WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id = rec_agent.id
        ) argi
        ON argi.agent_id=op.agent_id AND argi.api_id=op.api_id AND argi.api_type_id = op.api_type_id
        ) arg
        LEFT JOIN rebate_grads_api rga ON rebate_grads_id = n_agent_grads_id AND arg.api_id=rga.api_id AND arg.api_type_id = rga.api_type_id
        LEFT JOIN sys_user ua ON arg.agent_id = ua."id" AND ua.user_type = '23'
        LEFT JOIN sys_user ut ON ua.owner_id = ut."id" AND ut.user_type = '22'
    ;

    v_temp_sql='SELECT * FROM agent_rebate WHERE rebate_status IN (''0'', ''1'') AND rebate_year ='|| v_year ||' AND rebate_month ='|| v_month ||' AND agent_id ='|| rec_agent.id;
    --raise notice 'v_temp_sql： %',v_temp_sql;
    open cur_agent_rebate FOR execute v_temp_sql;
    FETCH cur_agent_rebate INTO rec_api_rebate;
    IF rec_api_rebate is null THEN
      close cur_agent_rebate;
      CONTINUE;
    END IF;

    --初始数据
    n_fee_amount = 0;
    n_remain_fee = 0;
    n_remain_payout = 0;
    n_fee_total = 0;
    idx = 0;

    n_fee_amount = COALESCE(rec_api_rebate.fee_amount,0)+COALESCE(rec_api_rebate.fee_amount_history,0)+COALESCE(rec_api_rebate.favorable_amount,0)+COALESCE(rec_api_rebate.rakeback_amount,0)+COALESCE(rec_api_rebate.other_amount,0)+COALESCE(rec_api_rebate.favorable_amount_history,0)+COALESCE(rec_api_rebate.rakeback_amount_history,0)+COALESCE(rec_api_rebate.other_amount_history,0);
    --raise notice '代理的承担费用n_fee_amount为 %', n_fee_amount;

    FOR v_api_json IN
        SELECT json_array_elements(p_api_type_order_json::json)
    LOOP
        SELECT v_api_json::json->>'api_id' INTO n_api_id;
        SELECT v_api_json::json->>'api_type_id' INTO n_api_type_id;
        SELECT v_api_json::json->>'rebate_order_num' INTO n_rebate_order_num;
        --raise notice 'n_api_id % n_api_type_id %', n_api_id,n_api_type_id;
        FOR rec_api_grads IN
            SELECT * FROM agent_rebate_grads WHERE rebate_year = v_year AND rebate_month = v_month AND radio is not null AND radio>0 AND agent_id = rec_api_rebate.agent_id
        LOOP
            IF n_api_id = rec_api_grads.api_id AND n_api_type_id = rec_api_grads.api_type_id THEN
                IF idx > 0 THEN
                  n_fee_amount = n_remain_fee;--承担费用
                ELSEIF idx = 0 THEN
                  n_remain_fee = n_fee_amount;
                END IF;
                n_payout_total = rec_api_grads.payout_amount_history + rec_api_grads.payout_amount;--当前api总派彩
                --如果总派彩大于０，即需要扣掉代理承担费用，反之剩余派彩等于总派彩
                IF n_payout_total >= 0 THEN
                  n_remain_fee = n_payout_total - n_fee_amount;
                  --如果剩余费用小于０，则剩余派彩为０,剩余承担费用也是０，反之等于总派彩－当前承担费用
                  IF n_remain_fee < 0 THEN
                    n_remain_payout = 0;
                    n_remain_fee=-n_remain_fee;
                  ELSE
                    n_remain_payout = n_remain_fee;
                    n_remain_fee = 0;
                  END IF;
                ELSE
                  n_remain_payout = n_payout_total;
                END IF;

                update agent_rebate_grads set expense_amount = n_fee_amount,rebate_order_num = n_rebate_order_num,remain_expense_amount=n_remain_fee,remain_payout_amount=n_remain_payout  WHERE id = rec_api_grads.id;
                n_fee_total = n_fee_total + n_remain_payout * rec_api_grads.radio/100;
                idx = idx + 1;
            END IF;
        END LOOP;    --循环API
    END LOOP;--循环排序的API
    --raise notice '总费用为 % ，剩余承担费用为 %， 所以代理 % 的最终返佣费用为 %', n_fee_total,n_remain_fee,rec_api_rebate.agentusername,n_fee_total - n_remain_fee;
    IF n_remain_fee>0 THEN
      n_fee_total = n_fee_total - n_remain_fee;
    END IF;
    IF n_rebate_max is not null AND n_fee_total >= n_rebate_max THEN
        n_fee_total = n_rebate_max;
    END IF;
    IF n_fee_total = 0 THEN
      UPDATE agent_rebate set rebate_amount = n_fee_total,rebate_status='1' WHERE id = rec_api_rebate.id;
    ELSE
      UPDATE agent_rebate set rebate_amount = n_fee_total WHERE id = rec_api_rebate.id;
    END IF;
    --关闭游标
    CLOSE cur_agent_rebate;

  END LOOP;

  return '成功';
END;

$BODY$ LANGUAGE 'plpgsql';
COMMENT ON FUNCTION f_agent_rebate(p_stat_month text, p_start_time text, p_end_time text, p_api_type_order_json text, p_com_url text)
IS 'younger-返佣结算账单-入口';

drop function IF EXISTS gamebox_collect_site_infor(text, int);
create or replace function gamebox_collect_site_infor(
  hostinfo   text,
  site_id   int
) returns json as $$
declare
  rec record;
BEGIN
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-收集站点相关信
--v1.10  2017/07/01  Leisure  修改DBLINK的连接方式
*/
  --v1.10  2017/07/01  Leisure
  perform dblink_connect_u('mainsite', hostinfo);

  SELECT into rec * FROM
  dblink (
    'mainsite',  -- hostinfo, --v1.01  2017/07/01  Leisure
    'SELECT * from v_sys_site_info WHERE siteid='||site_id||''
  ) AS s (
    siteid     int4,    --站点ID
    sitename   VARCHAR,    --站点名称
    masterid   int4,    --站长ID
    mastername   VARCHAR,    --站长名称
    usertype   VARCHAR,    --用户类型
    subsyscode   VARCHAR,
    operationid int4,    --运营商ID
    operationname     VARCHAR,    --运营商名称
    operationusertype   VARCHAR,
    operationsubsyscode VARCHAR
  );

  perform dblink_disconnect('mainsite');

  IF FOUND THEN
    return row_to_json(rec);
  ELSE
    return (SELECT '{"siteid": -1}'::json);
  END IF;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_collect_site_infor(hostinfo text,site_id int)
IS 'Lins-经营报表-收集站点相关信息';