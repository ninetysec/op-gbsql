drop function if exists gb_rakeback_task(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gb_rakeback_task(
  p_comp_url  TEXT,
	p_period 	TEXT,
	p_start_time 	TEXT,
	p_end_time 	TEXT,
	p_settle_flag 	TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/06/17  Leisure   创建此函数: 返水结算账单.入口(调度)

  返回值说明：0成功，1警告，2错误
*/
DECLARE

	t_start_time 	TIMESTAMP;
	t_end_time 	TIMESTAMP;
  n_sid  INT;
  n_return_code INT := 0;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  t_start_time = clock_timestamp()::timestamp(0);

  perform gb_rakeback(p_period, p_start_time, p_end_time, p_settle_flag);

  t_end_time = clock_timestamp()::timestamp(0);

  IF p_settle_flag = 'Y' THEN

    SELECT gamebox_current_site() INTO n_sid;

    --perform dblink_close_all();
    --perform dblink_connect('master',  p_comp_url);

    SELECT t.return_code
      INTO n_return_code
      FROM
      dblink (p_comp_url,
              'SELECT * from gb_task_infomation_site( ''' || n_sid || ''', ''gb_rakeback'', ''返水结算账单'', ''' || p_period || ''', ''1'', ''' ||
               t_start_time || ''', ''' || t_end_time || ''', '''')'
             ) AS t(return_code INT);
    --perform dblink_disconnect('master');
  END IF;

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

COMMENT ON FUNCTION gb_rakeback_task( p_comp_url  TEXT, p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Leisure-返水结算账单.入口(调度)';

/**
 * 返水结算账单.入口
 * @author 	Leisure
 * @date 	  2017-01-15
 * @param 	返水期数.
 * @param 	返水周期开始时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	返水周期结束时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	出账标示:Y-已出账, N-未出账
**/
drop function if exists gb_rakeback(TEXT, TEXT, TEXT, TEXT);
create or replace function gb_rakeback(
	p_period 	TEXT,
	p_start_time 	TEXT,
	p_end_time 	TEXT,
	p_settle_flag 	TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/15  Leisure   创建此函数: 返水结算账单.入口
*/
DECLARE

	t_start_time 	TIMESTAMP;
	t_end_time 	TIMESTAMP;

	n_rakeback_bill_id INT:=-1; --返水主表键值.
	n_bill_count 	INT :=0;

	n_sid 			INT;--站点ID.
	--b_is_max 		BOOLEAN := true;

	redo_status BOOLEAN:=false; --重跑标志，默认不允许重跑

BEGIN
	t_start_time = p_start_time::TIMESTAMP;
	t_end_time = p_end_time::TIMESTAMP;

	SELECT gamebox_current_site() INTO n_sid;

	RAISE INFO '开始统计站点 %，周期 %( %-% )返水', n_sid, p_period, p_start_time, p_end_time;

	IF p_settle_flag = 'Y' THEN
		--查找是否本期有已支付的返水
		SELECT COUNT("id")
		  INTO n_bill_count
		  FROM rakeback_bill rb
		 WHERE rb.period = p_period
		   AND rb."start_time" = t_start_time
		   AND rb."end_time" = t_end_time
		   AND rb.lssuing_state <> 'pending_pay';

		IF n_bill_count = 0 THEN
			DELETE FROM rakeback_api ra WHERE ra.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rakeback_player rp WHERE rp.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rakeback_bill rb WHERE "id" IN (SELECT "id" FROM rakeback_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
		ELSE
			RAISE INFO '已生成本期返水账单，不能重新生成！';
			RETURN;
		END IF;
	ELSEIF p_settle_flag = 'N' THEN
		TRUNCATE TABLE rakeback_api_nosettled;
		TRUNCATE TABLE rakeback_player_nosettled;
		TRUNCATE TABLE rakeback_bill_nosettled;
	END IF;

	RAISE INFO '返水总表数据预新增.';
	SELECT gamebox_rakeback_bill(p_period, t_start_time, t_end_time, n_rakeback_bill_id, 'I', p_settle_flag) INTO n_rakeback_bill_id;

	RAISE INFO '统计玩家API返水';
	perform gb_rakeback_api(n_rakeback_bill_id, p_settle_flag, t_start_time, t_end_time);
	RAISE INFO '统计玩家API返水.完成';

	RAISE INFO '统计玩家返水';
	perform gb_rakeback_player(n_rakeback_bill_id, p_settle_flag);
	RAISE INFO '统计玩家返水.完成';

	RAISE INFO '更新返水总表';
	perform gamebox_rakeback_bill(p_period, t_start_time, t_end_time, n_rakeback_bill_id, 'U', p_settle_flag);
	RAISE INFO '站点 %，周期 %( %-% )返水.完成', n_sid, p_period, p_start_time, p_end_time;

END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback(p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Leisure-返水结算账单.入口';

/**
 * 返水结算账单.玩家API返水
 * @author 	Leisure
 * @date    2017-01-15
 * @param 	返水账单ID
 * @param 	出账标示:Y-已出账, N-未出账
 * @param 	返水周期开始时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	返水周期结束时间(yyyy-mm-dd hh24:mi:ss)
**/
DROP FUNCTION IF EXISTS gb_rakeback_api(INT, TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_rakeback_api(
  p_bill_id   INT,
  p_settle_flag   TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/15  Leisure  创建此函数: 返水结算账单.玩家API返水
--v1.01  2017/01/22  Leisure  增加返水金额空值处理
*/
DECLARE

  h_occupy_map   hstore;    -- API占成梯度map
  --h_assume_map   hstore;    -- 盈亏共担map

  --h_sys_config   hstore;
  --sp       TEXT:='@';
  --rs       TEXT:='\~';
  --cs       TEXT:='\^';
  b_meet_or_not   BOOLEAN; --是否达到返水条件

  n_rakeback_set_id   INT;
  n_audit_num   numeric(20,2); --优惠稽核
  --v_rakeback_set_name   TEXT:='';
  --n_valid_value     FLOAT:=0.00;

  v_key_name         TEXT:='';
  COL_SPLIT       TEXT:='_';

  rec_player   record;
  rec_api   record;
  --rec_grad   record;
  n_grad_id   INT;
  n_max_rakeback   FLOAT:=0.00;--返水上限

  --rec_grad_api   record;
  n_grad_api_id   INT;
  n_rakeback_ratio   FLOAT := 0.00;

  n_player_id   INT;
  v_player_name   TEXT;
  n_agent_id   INT;
  v_agent_name   TEXT;
  --n_topagent_id   INT;
  n_api_id     INT;
  v_game_type   TEXT;

  n_profit_amount       FLOAT:=0.00;--盈亏总和
  n_effective_transaction   FLOAT:=0.00;--有效交易量

  n_row_count   INT :=0;
  n_effective_player_num INT :=0;

  n_rakeback_value   FLOAT:=0.00;--代理API返水金额

  n_rakeback_api_id   INT :=0;

BEGIN
  --取得系统变量
  --SELECT sys_config() INTO h_sys_config;
  --sp = h_sys_config->'sp_split';
  --rs = h_sys_config->'row_split';
  --cs = h_sys_config->'col_split';

  DELETE FROM rakeback_api_base WHERE rakeback_time >= p_start_time AND rakeback_time < p_end_time;

  --玩家循环
  FOR rec_player IN
    SELECT su."id"                   as player_id,
           su.username               as player_name,
           up.rakeback_id            as rakeback_id,
           ua."id"                   as agent_id,
           ua.username               as agent_name,
           ut."id"                   as topagent_id,
           ut.username               as topagent_name,
           pgo.effective_transaction,
           pgo.profit_amount
      FROM
    (
      SELECT player_id,
             COALESCE( SUM(pg.effective_trade_amount), 0.00) as effective_transaction,
             COALESCE( SUM(pg.profit_amount), 0.00) as profit_amount
          FROM player_game_order pg
       WHERE pg.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pg.payout_time >= p_start_time
         AND pg.payout_time < p_end_time
       GROUP BY player_id
    ) pgo
        LEFT JOIN user_player up ON pgo.player_id = up."id"
        LEFT JOIN sys_user su ON up.id = su."id"  AND su.user_type = '24'
        LEFT JOIN sys_user ua ON su.owner_id = ua.id AND ua.user_type = '23'
        LEFT JOIN sys_user ut ON ua.owner_id = ut.id AND ut.user_type = '22'
     ORDER BY effective_transaction DESC, su."id"
  LOOP
    --重新初始化变量
    b_meet_or_not = TRUE;
    n_player_id = rec_player.player_id;
    v_player_name = rec_player.player_name;

    n_agent_id = rec_player.agent_id;
    v_agent_name = rec_player.agent_name;
    --n_topagent_id = rec_player.topagent_id;
    n_effective_transaction = rec_player.effective_transaction;
    n_profit_amount = rec_player.profit_amount;

    --取得玩家返水方案
    --n_rakeback_set_id = rec_player.rakeback_id;

    SELECT rs.id, rs.audit_num
      INTO n_rakeback_set_id, n_audit_num
      FROM rakeback_set rs
     WHERE rs.id = rec_player.rakeback_id;

    --若玩家未设置返水方案，取代理返水方案
    IF n_rakeback_set_id IS NULL THEN
      --取得代理返水方案
      SELECT ua.rakeback_id, rs.audit_num
        INTO n_rakeback_set_id, n_audit_num
        FROM user_agent_rakeback ua, rakeback_set rs
       WHERE ua.user_id = n_agent_id
         AND rs.status = '1'
         AND rs.id = ua.rakeback_id;

      GET DIAGNOSTICS n_row_count = ROW_COUNT;
      IF n_row_count = 0 THEN
        RAISE INFO '玩家ID: %, 名称: %, 未设置返水方案！代理ID: %, 名称: %, 亦未设置返水方案！',
                   n_player_id, v_player_name, n_agent_id, v_agent_name;
        --CONTINUE;
        b_meet_or_not = FALSE;
      END IF;
    END IF;

    IF b_meet_or_not THEN

      --取得返水梯度
      SELECT rg.id AS grads_id,   --返水梯度ID
             rg.max_rakeback       --返水上限
        FROM rakeback_grads rg
       WHERE rg.rakeback_id = n_rakeback_set_id
         AND n_effective_transaction >= rg.valid_value --实际有效交易量 >= 梯度有效交易量
       ORDER BY rg.valid_value DESC
       LIMIT 1
        --INTO rec_grad;
        INTO n_grad_id, n_max_rakeback;

      GET DIAGNOSTICS n_row_count = ROW_COUNT;
      IF n_row_count = 0 THEN
        RAISE INFO '玩家ID: %, 名称: %, 代理ID: %, 名称: %, 返水方案ID: %, 未达返水梯度！',
                   n_player_id, v_player_name, n_agent_id, v_agent_name, n_rakeback_set_id;
        --CONTINUE;
        b_meet_or_not = FALSE;
      END IF; --返水梯度

    END IF; --返水方案

    --玩家api循环
    FOR rec_api IN
      SELECT pgo.api_id,
             pgo.game_type,
             COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
             COALESCE(SUM(-pgo.profit_amount), 0.00)  as profit_amount
          FROM player_game_order pgo
          LEFT JOIN sys_user su ON pgo.player_id = su."id"
          --LEFT JOIN sys_user ua ON su.owner_id = ua.id
       WHERE pgo.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pgo.payout_time >= p_start_time
         AND pgo.payout_time < p_end_time
         AND su.user_type = '24'
         --AND ua.user_type = '23'
         AND su."id" = n_player_id
       GROUP BY pgo.api_id, pgo.game_type
       ORDER BY effective_transaction DESC, pgo.api_id, pgo.game_type
    LOOP

      --重新初始化变量
      n_api_id       = rec_api.api_id;
      v_game_type     = rec_api.game_type;
      n_effective_transaction   = rec_api.effective_transaction;
      n_profit_amount   = rec_api.profit_amount;

      n_grad_api_id = NULL;
      n_rakeback_ratio = 0.00;

      n_rakeback_value = 0.00;

      IF b_meet_or_not THEN
        --取得返水比率
        SELECT rga.id AS grads_api_id, --返水梯度API比率ID
               rga.ratio --API返水比例
          FROM rakeback_grads_api rga
         WHERE rga.rakeback_grads_id = n_grad_id --rec_grad.grads_id
           AND rga.api_id = n_api_id
           AND rga.game_type = v_game_type
         LIMIT 1
          --INTO rec_grad_api;
          INTO n_grad_api_id, n_rakeback_ratio;
      END IF;

      IF b_meet_or_not THEN
        --计算返水
        n_rakeback_value := n_effective_transaction * n_rakeback_ratio/100;
      END IF;

      --返水不能超过返水上限
      --IF n_rakeback_value > rec_grad.max_rakeback THEN
      --  n_rakeback_value = rec_grad.max_rakeback;
      --END IF;

      INSERT INTO rakeback_api_base (
          top_agent_id, agent_id, player_id, api_id, game_type,
          effective_transaction, profit_loss, rakeback, rakeback_time
      )
      VALUES (
          rec_player.topagent_id, rec_player.agent_id, rec_player.player_id, rec_api.api_id, rec_api.game_type,
          rec_api.effective_transaction, rec_api.profit_amount, n_rakeback_value, p_start_time
      );

      --v1.01  2016/01/22  Leisure
      IF n_rakeback_value > 0 THEN

        IF p_settle_flag = 'Y' THEN
          INSERT INTO rakeback_api (
              rakeback_bill_id, player_id, api_id, game_type, rakeback,
              effective_transaction, profit_loss, audit_num, rakeback_limit
          )
          VALUES (
              p_bill_id, rec_player.player_id, rec_api.api_id, rec_api.game_type, n_rakeback_value,
              rec_api.effective_transaction, rec_api.profit_amount, n_audit_num, n_max_rakeback
          ) RETURNING id INTO n_rakeback_api_id;

        ELSEIF p_settle_flag = 'N' THEN
          INSERT INTO rakeback_api_nosettled (
              rakeback_bill_nosettled_id, player_id, api_id, game_type, rakeback,
              effective_transaction, profit_loss, audit_num, rakeback_limit
          )
          VALUES (
              p_bill_id, rec_player.player_id, rec_api.api_id, rec_api.game_type, n_rakeback_value,
              rec_api.effective_transaction, rec_api.profit_amount, n_audit_num, n_max_rakeback
          ) RETURNING id INTO n_rakeback_api_id;
        END IF;

          RAISE INFO 'rakeback_api.新增键值 %.玩家 %, API %, GAME_TYPE %, .金额 %.', n_rakeback_api_id, rec_player.player_id, rec_api.api_id, rec_api.game_type, n_rakeback_value;
      END IF;

    END LOOP;
  END LOOP;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_api(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-返水.玩家API返水';

/**
 * 返水.玩家返水
 * @author 	Leisure
 * @date    2017-01-15
 * @param 	返水账单ID
 * @param 	出账标示:Y-已出账, N-未出账
**/
DROP FUNCTION IF EXISTS gb_rakeback_player(INT, TEXT);
create or replace function gb_rakeback_player(
	p_bill_id 	INT,
	p_settle_flag 	TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/18  Leisure  创建此函数: 返水.玩家返水
*/
DECLARE

BEGIN

	IF p_settle_flag = 'Y' THEN--已出账

		INSERT INTO rakeback_player(
		    rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker,
		    rakeback_total, rakeback_actual, settlement_state, agent_id, top_agent_id, audit_num
		)
		SELECT p_bill_id, ut.id, ut.username, ut.rank_id, ut.rank_name, ut.risk_marker,
		       ra.rakeback, ra.rakeback, 'pending_lssuing', ut.agent_id, ut.topagent_id, ra.audit_num
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
		    rakeback_total, agent_id, top_agent_id, audit_num
		)
		SELECT p_bill_id, ut.id, ut.username, ut.rank_id, ut.rank_name, ut.risk_marker,
		       ra.rakeback, ut.agent_id, ut.topagent_id, ra.audit_num
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

/**
 * 返水结算账单.API返水基础表
 * @author 	Leisure
 * @date    2017-01-15
 * @param 	返水账单ID
 * @param 	出账标示:Y-已出账, N-未出账
 * @param 	返水周期开始时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	返水周期结束时间(yyyy-mm-dd hh24:mi:ss)
**/
DROP FUNCTION IF EXISTS gb_rakeback_api_base(INT, TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_rakeback_api_base(
  p_bill_id   INT,
  p_settle_flag   TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/15  Leisure  创建此函数: 返水结算账单.API返水基础表
--v1.01  2016/01/22  Leisure  增加返水金额空值处理
*/
DECLARE

  h_occupy_map   hstore;    -- API占成梯度map
  --h_assume_map   hstore;    -- 盈亏共担map

  --h_sys_config   hstore;
  --sp       TEXT:='@';
  --rs       TEXT:='\~';
  --cs       TEXT:='\^';
  b_meet_or_not   BOOLEAN; --是否达到返水条件

  n_rakeback_set_id   INT;
  n_audit_num   numeric(20,2); --优惠稽核
  --v_rakeback_set_name   TEXT:='';
  --n_valid_value     FLOAT:=0.00;

  v_key_name         TEXT:='';
  COL_SPLIT       TEXT:='_';

  rec_player   record;
  rec_api   record;
  --rec_grad   record;
  n_grad_id   INT;
  --rec_grad_api   record;
  n_grad_api_id   INT;
  n_rakeback_ratio   FLOAT := 0.00;

  n_player_id   INT;
  v_player_name   TEXT;
  n_agent_id   INT;
  v_agent_name   TEXT;
  --n_topagent_id  INT;
  n_api_id     INT;
  v_game_type   TEXT;

  n_profit_amount       FLOAT:=0.00;--盈亏总和
  n_effective_transaction   FLOAT:=0.00;--有效交易量

  n_row_count   INT :=0;
  n_effective_player_num INT :=0;

  n_rakeback_value   FLOAT:=0.00;--代理API返水金额

BEGIN
  --取得系统变量
  --SELECT sys_config() INTO h_sys_config;
  --sp = h_sys_config->'sp_split';
  --rs = h_sys_config->'row_split';
  --cs = h_sys_config->'col_split';

  DELETE FROM rakeback_api_base WHERE rakeback_time >= p_start_time AND rakeback_time < p_end_time;

  --玩家循环
  FOR rec_player IN
    SELECT su."id"                   as player_id,
           su.username               as player_name,
           up.rakeback_id            as rakeback_id,
           ua."id"                   as agent_id,
           ua.username               as agent_name,
           ut."id"                   as topagent_id,
           ut.username               as topagent_name,
           pgo.effective_transaction,
           pgo.profit_amount
      FROM
    (
      SELECT player_id,
             COALESCE( SUM(pg.effective_trade_amount), 0.00) as effective_transaction,
             COALESCE( SUM(pg.profit_amount), 0.00) as profit_amount
          FROM player_game_order pg
       WHERE pg.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pg.payout_time >= p_start_time
         AND pg.payout_time < p_end_time
       GROUP BY player_id
    ) pgo
        LEFT JOIN user_player up ON pgo.player_id = up."id"
        LEFT JOIN sys_user su ON up.id = su."id"  AND su.user_type = '24'
        LEFT JOIN sys_user ua ON su.owner_id = ua.id AND ua.user_type = '23'
        LEFT JOIN sys_user ut ON ua.owner_id = ut.id AND ut.user_type = '22'
     ORDER BY effective_transaction DESC, su."id"
  LOOP
    --重新初始化变量
    b_meet_or_not = TRUE;
    n_player_id = rec_player.player_id;
    v_player_name = rec_player.player_name;

    n_agent_id = rec_player.agent_id;
    v_agent_name = rec_player.agent_name;
    --n_topagent_id = rec_player.topagent_id;
    n_effective_transaction = rec_player.effective_transaction;
    n_profit_amount = rec_player.profit_amount;

    --取得玩家返水方案
    n_rakeback_set_id = rec_player.rakeback_id;

    --若玩家未设置返水方案，取代理返水方案
    IF n_rakeback_set_id IS NULL THEN
      --取得代理返水方案
      SELECT ua.rakeback_id, rs.audit_num
        INTO n_rakeback_set_id, n_audit_num
        FROM user_agent_rakeback ua, rakeback_set rs
       WHERE ua.user_id = n_agent_id
         AND rs.status = '1'
         AND rs.id = ua.rakeback_id;

      GET DIAGNOSTICS n_row_count = ROW_COUNT;
      IF n_row_count = 0 THEN
        RAISE INFO '玩家ID: %, 名称: %，未设置返水方案！代理ID: %, 名称: %，亦未设置返水方案！',
                   n_player_id, v_player_name, n_agent_id, v_agent_name;
        --CONTINUE;
        b_meet_or_not = FALSE;
      END IF;
    END IF;

    IF b_meet_or_not THEN

      --取得返水梯度
      SELECT rg.id AS grads_id   --返水梯度ID
             --rg.total_profit,     --有效盈利总额
             --rg.max_rakeback,       --返水上限
             --rg.valid_player_num  --有效玩家数
        FROM rakeback_grads rg
       WHERE rg.rakeback_id = n_rakeback_set_id
         AND n_effective_transaction >= rg.valid_value --实际有效交易量 >= 梯度有效交易量
       ORDER BY rg.valid_value DESC
       LIMIT 1
        --INTO rec_grad;
        INTO n_grad_id;

      GET DIAGNOSTICS n_row_count = ROW_COUNT;
      IF n_row_count = 0 THEN
        RAISE INFO '玩家ID: %, 名称: %, 代理ID: %, 名称: %, 返水方案ID: %, 未达返水梯度！',
                   n_player_id, v_player_name, n_agent_id, v_agent_name, n_rakeback_set_id;
        --CONTINUE;
        b_meet_or_not = FALSE;
      END IF; --返水梯度

    END IF; --返水方案

    --玩家api循环
    FOR rec_api IN
      SELECT pgo.api_id,
             pgo.game_type,
             COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
             COALESCE(SUM(-pgo.profit_amount), 0.00) as profit_amount
          FROM player_game_order pgo
          LEFT JOIN sys_user su ON pgo.player_id = su."id"
          --LEFT JOIN sys_user ua ON su.owner_id = ua.id
       WHERE pgo.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pgo.payout_time >= p_start_time
         AND pgo.payout_time < p_end_time
         AND su.user_type = '24'
         --AND ua.user_type = '23'
         AND su."id" = n_player_id
       GROUP BY pgo.api_id, pgo.game_type
       ORDER BY pgo.api_id, pgo.game_type
    LOOP

      --重新初始化变量
      n_api_id       = rec_api.api_id;
      v_game_type     = rec_api.game_type;
      n_effective_transaction   = rec_api.effective_transaction;
      n_profit_amount   = rec_api.profit_amount;

      n_grad_api_id = NULL;
      n_rakeback_ratio = 0.00;

      n_rakeback_value = 0.00;

      IF b_meet_or_not THEN
        --取得返水比率
        SELECT rga.id AS grads_api_id, --返水梯度API比率ID
               rga.ratio --API返水比例
          FROM rakeback_grads_api rga
         WHERE rga.rakeback_grads_id = n_grad_id --rec_grad.grads_id
           AND rga.api_id = n_api_id
           AND rga.game_type = v_game_type
         LIMIT 1
          --INTO rec_grad_api;
          INTO n_grad_api_id, n_rakeback_ratio;
      END IF;

      IF b_meet_or_not THEN
        --计算返水
        n_rakeback_value := n_effective_transaction * n_rakeback_ratio/100;
      END IF;

      --返水不能超过返水上限
      --IF n_rakeback_value > rec_grad.max_rakeback THEN
      --  n_rakeback_value = rec_grad.max_rakeback;
      --END IF;

      --v1.01  2016/01/22  Leisure
      IF n_rakeback_value > 0 THEN

        INSERT INTO rakeback_api_base (
            top_agent_id, agent_id, player_id, api_id, game_type,
            effective_transaction, profit_loss, rakeback, rakeback_time
        )
        VALUES (
            rec_player.topagent_id, rec_player.agent_id, rec_player.player_id, rec_api.api_id, rec_api.game_type,
            rec_api.effective_transaction, rec_api.profit_amount, n_rakeback_value, p_start_time
        );

      /*
      --写入API返水基础表
      INSERT INTO rakeback_api_base (
          settle_flag, rakeback_bill_id, agent_id, agent_name, api_id, game_type, effective_transaction, effective_player_num, profit_loss,
          operation_retio, operation_occupy, rakeback_set_id, rakeback_grads_id, rakeback_grads_api_id, rakeback_retio, rakeback_value)
      VALUES (
          p_settle_flag, p_bill_id, n_agent_id, v_agent_name, n_api_id, v_game_type, n_effective_transaction, n_effective_player_num, n_profit_amount,
          n_operation_occupy_retio, n_operation_occupy_value, n_rakeback_set_id, n_grad_id, n_grad_api_id, n_rakeback_ratio, n_rakeback_value
      );
      */

        RAISE INFO 'rakeback_api_base.新增.玩家 %, API %, GAME_TYPE %, .金额 %.', rec_player.player_id, rec_api.api_id, rec_api.game_type, n_rakeback_value;
      END IF;

    END LOOP;
  END LOOP;
END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_api_base(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-返水结算账单.API返水基础表';

/**
 * 根据返水周期统计各个API, 各个玩家的返水数据.
 * @author 	Lins
 * @date 	2015.11.10
 * @param 	返水期数.
 * @param 	返水周期开始时间(yyyy-mm-dd)
 * @param 	返水周期结束时间(yyyy-mm-dd)
 * @param 	运营商库的dblink 格式数据
 * @param 	出账标示:Y-已出账, N-未出账
**/
drop function IF EXISTS gamebox_rakeback(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_rakeback(
	name 		text,
	startTime 	text,
	endTime 	text,
	url 		text,
	flag 		TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-玩家返水入口
--v1.01  2016/05/30  Leisure  增加重跑标识，默认禁止重跑
*/
DECLARE
	stTime 	TIMESTAMP;
	edTime 	TIMESTAMP;
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
	bill_id 		INT:=-1;
	sid 			INT;
	bill_count	INT :=0;
	redo_status BOOLEAN := false; --重跑标识，默认禁止重跑
BEGIN
	raise info '开始统计( % )的返水, 周期( %-% )', name, startTime, endTime;
	raise info '创建站点游戏视图';

	SELECT gamebox_current_site() INTO sid;

	stTime = startTime::TIMESTAMP;
	edTime = endTime::TIMESTAMP;

	--v1.01  2016/05/30  Leisure
	IF flag = 'Y' THEN
		SELECT COUNT("id")
		 INTO bill_count
			FROM rakeback_bill rb
		 WHERE rb.period = name
			 AND rb."start_time" = stTime
			 AND rb."end_time" = edTime;

		IF bill_count > 0 THEN
			IF redo_status THEN
				DELETE FROM rakeback_api ra WHERE ra.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
				DELETE FROM rakeback_player rp WHERE rp.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
				DELETE FROM rakeback_bill rb WHERE "id" IN (SELECT "id" FROM rakeback_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
			ELSE
				raise info '已生成本期返水账单，无需重新生成。';
				RETURN;
			END IF;
		END IF;
	END IF;

	raise info '返水总表数据预新增.';
	SELECT gamebox_rakeback_bill(name, stTime, edTime, bill_id, 'I', flag) INTO bill_id;

	-- 收集每个API下每个玩家的返水.
	raise info '统计玩家API返水';
	perform gamebox_rakeback_api(bill_id, stTime, edTime, flag);
	raise info '统计玩家API返水.完成';

	raise info '统计玩家返水';
	perform gamebox_rakeback_player(bill_id, flag);
	raise info '统计玩家返水.完成';

	raise info '更新返水总表';
	perform gamebox_rakeback_bill(name, stTime, edTime, bill_id, 'U', flag);

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback(name text, startTime text, endTime text, url text, flag TEXT)
IS 'Lins-返水-玩家返水入口';

/**
 * 返水插入与更新数据.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	周期数.
 * @param 	返水周期开始时间(yyyy-mm-dd)
 * @param 	返水周期结束时间(yyyy-mm-dd)
 * @param 	返水键值
 * @param 	操作类型.I:新增.U:更新.
 * @param 	出账标示:Y.已出账, N.未出账
**/
DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rakeback_bill (
	name 			TEXT,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	INOUT bill_id 	INT,
	op 				TEXT,
	flag 			TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-返水周期主表
--v1.01  2016/05/30  Leisure  改为returning，防止并发
--v1.01  2017/01/18  Leisure  没有返水玩家，依然保留返水总表记录
*/
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
	rec 			record;
	max_back_water 	float:=0.00;
	backwater 		float:=0.00;
	rp_count		INT:=0;	-- rakeback_player 条数

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
						   COUNT(DISTINCT player_id) 	as cl,
						   SUM(rakeback_total) 			as sl
					  FROM rakeback_player
					 WHERE rakeback_bill_id = bill_id
					 GROUP BY rakeback_bill_id
				LOOP
					UPDATE rakeback_bill SET player_count = rec.cl, rakeback_total = rec.sl WHERE id = bill_id;
				END LOOP;
			--ELSE
				--DELETE FROM rakeback_bill WHERE id = bill_id;
			END IF;
		END IF;

	ELSEIF flag='N' THEN--未出账

		IF op='I' THEN
			--先插入返水总记录并取得键值.
			INSERT INTO rakeback_bill_nosettled (
			 	start_time, end_time, rakeback_total, create_time
			) VALUES (
			 	start_time, end_time, 0, now()
			) returning id into bill_id;

			--改为returning，防止并发 Leisure 20160530
			--SELECT currval(pg_get_serial_sequence('rakeback_bill_nosettled', 'id')) into bill_id;
		ELSE
			SELECT COUNT(1) FROM rakeback_player_nosettled WHERE rakeback_bill_nosettled_id = bill_id INTO rp_count;
			-- raise info '---- rp_count = %', rp_count;
			IF rp_count > 0 THEN
				FOR rec in
					SELECT rakeback_bill_nosettled_id,
						   COUNT(DISTINCT player_id) 	as cl,
						   SUM(rakeback_total) 			as sl
					  FROM rakeback_player_nosettled
					 WHERE rakeback_bill_nosettled_id = bill_id
					 GROUP BY rakeback_bill_nosettled_id
				LOOP
					UPDATE rakeback_bill_nosettled SET rakeback_total = rec.sl WHERE id = bill_id;
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

/**
 * 各玩家API返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	bill_id 	返水键值
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	flag 		出账标示:Y-已出账, N-未出账
**/
DROP FUNCTION IF EXISTS gamebox_rakeback_api(INT, TIMESTAMP, TIMESTAMP, TEXT);
create or replace function gamebox_rakeback_api(
	bill_id 	INT,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	flag 		TEXT
) returns void as $$

DECLARE
	rakeback 	FLOAT:=0.00;
	tmp 		INT:=0;
	rec 		record;

BEGIN
	IF flag = 'N' THEN
		TRUNCATE TABLE rakeback_api_nosettled;
  		TRUNCATE TABLE rakeback_player_nosettled;
	END IF;

	FOR rec IN
		SELECT rab.player_id,
			   rab.api_id,
			   rab.api_type_id,
			   rab.game_type,
			   up.rakeback_id,
			   up.rank_id,
			   SUM(rab.rakeback)				as rakeback,
			   SUM(rab.effective_transaction)	as effective_trade_amount,
			   SUM(rab.profit_loss) 			as profit_amount
	 	  FROM rakeback_api_base rab
	 	  LEFT JOIN sys_user su ON rab.player_id = su."id"
	 	  LEFT JOIN user_player up ON rab.player_id = up."id"
		 WHERE rakeback_time >= start_time
		   AND rakeback_time < end_time
		 GROUP BY rab.player_id, rab.api_id, rab.api_type_id, rab.game_type, up.rakeback_id, up.rank_id

    LOOP
		IF flag = 'Y' THEN
			INSERT INTO rakeback_api (
				rakeback_bill_id, player_id, api_id, api_type_id, game_type,
				rakeback, effective_transaction, profit_loss
			) VALUES (
			 	bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,
			 	rec.rakeback, rec.effective_trade_amount, rec.profit_amount
			);
		 	SELECT currval(pg_get_serial_sequence('rakeback_api', 'id')) into tmp;
		ELSEIF flag = 'N' THEN
			INSERT INTO rakeback_api_nosettled (
				rakeback_bill_nosettled_id, player_id, api_id, api_type_id, game_type,
				rakeback, effective_transaction, profit_loss
			) VALUES (
				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,
				rec.rakeback, rec.effective_trade_amount, rec.profit_amount
			);
		 	SELECT currval(pg_get_serial_sequence('rakeback_api_nosettled', 'id')) into tmp;
		END IF;
			raise info '各API玩家返水键值:%', tmp;
	END LOOP;

	raise info '收集每个API下每个玩家的返水.完成';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, flag TEXT)
IS 'Lins-返水-各玩家API返水';

/**
 * 各玩家返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	bill_id 	返水键值
 * @param 	flag 		出账标示:Y.已出账, N.未出账
**/
DROP FUNCTION IF EXISTS gamebox_rakeback_player(INT, TEXT);
create or replace function gamebox_rakeback_player(
	bill_id INT,
	flag TEXT
) returns void as $$

/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-各玩家返水
--v1.01  2016/05/16  Leisure  插入rekeback增加audit_num字段
*/

DECLARE
	rec 				record;
	pending_lssuing 	text:='pending_lssuing';
	pending_pay 		text:='pending_pay';
	max_back_water 		float:=0.00; -- 返水上限
	backwater 			float:=0.00;
	gradshash 			hstore;
	agenthash 			hstore;
  n_audit_num     numeric(20,2);
BEGIN
	raise info '取得当前返水梯度设置信息.';
 	SELECT gamebox_rakeback_api_grads() into gradshash;
 	raise info '取得代理返水设置.';
 	SELECT gamebox_agent_rakeback() 	into agenthash;

	IF flag = 'Y' THEN--已出账
		FOR rec IN
			SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
				   s.rakeback, pending_lssuing, u.agent_id, u.topagent_id, up.rakeback_id, s.effTrans
		  	  FROM ( SELECT player_id,
						    SUM(rakeback) rakeback,
							SUM(effective_transaction) effTrans
					   FROM rakeback_api
					  WHERE rakeback_bill_id = bill_id
					  GROUP BY player_id) s,
		  	   	   v_sys_user_tier u,
				   user_player up
		 	 WHERE s.player_id = u.id
			   AND s.player_id = up."id"
			 ORDER BY u.id, s.effTrans asc
		LOOP
			SELECT gamebox_rakeback_limit(rec.rakeback_id, gradshash, agenthash, rec.effTrans) into max_back_water;
			backwater = rec.rakeback;
			-- max_back_water 为0表示未设置返水上限
			IF backwater > max_back_water AND max_back_water<>0 THEN
				backwater = max_back_water;
			END IF;

			SELECT r.audit_num
			  INTO n_audit_num
				FROM user_player u,
						 rakeback_set r
			 WHERE u.rakeback_id = r."id"
				 AND u."id" = rec."id";

			n_audit_num := coalesce(n_audit_num, 0.00);

			INSERT INTO rakeback_player(
				rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker,
				rakeback_total, rakeback_actual, settlement_state, agent_id, top_agent_id, audit_num
			) VALUES (
				bill_id, rec.id, rec.username, rec.rank_id, rec.rank_name, rec.risk_marker,
				backwater, backwater, pending_lssuing, rec.agent_id, rec.topagent_id, n_audit_num
			);
		END LOOP;

	ELSEIF flag = 'N' THEN--未出账
		FOR rec IN
			SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
				   s.rakeback, u.agent_id, u.topagent_id, up.rakeback_id, s.effTrans
		  	  FROM ( SELECT player_id,
						    SUM(rakeback) rakeback,
							SUM(effective_transaction) effTrans
					   FROM rakeback_api_nosettled
					  WHERE rakeback_bill_nosettled_id = bill_id
					  GROUP BY player_id) s,
		  	   	   v_sys_user_tier u, user_player up
		 	 WHERE s.player_id = u.id
			   AND s.player_id = up."id"

		LOOP
			SELECT gamebox_rakeback_limit(rec.rakeback_id, gradshash, agenthash, rec.effTrans) into max_back_water;
			backwater = rec.rakeback;
			IF backwater > max_back_water AND max_back_water <> 0 THEN
				backwater = max_back_water;
			END IF;

			SELECT r.audit_num
			  INTO n_audit_num
				FROM user_player u,
						 rakeback_set r
			 WHERE u.rakeback_id = r."id"
				 AND u."id" = rec."id";

			n_audit_num := coalesce(n_audit_num, 0.00);

			INSERT INTO rakeback_player_nosettled (
				rakeback_bill_nosettled_id, player_id, username, rank_id, rank_name, risk_marker,
				rakeback_total, agent_id, top_agent_id, audit_num
			) VALUES (
				bill_id, rec.id, rec.username, rec.rank_id, rec.rank_name, rec.risk_marker,
				backwater, rec.agent_id, rec.topagent_id, n_audit_num
			);
		END LOOP;
	END IF;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_player(bill_id INT, flag TEXT)
IS 'Lins-返水-各玩家返水';

/**
 * 计算返水上限
 * @author 	Fei
 * @date 	2016.03.22
 * @return 	返回float类型，返水值.
**/
drop function IF EXISTS gamebox_rakeback_limit(int, hstore, hstore, float);
CREATE OR REPLACE FUNCTION gamebox_rakeback_limit(
	rakeback_id int,
	gradshash 	hstore,
	agenthash 	hstore,
	volume 		float
) RETURNS FLOAT as $$
DECLARE
	keys 		text[];
	subkeys 	text[];
	keyname 	text:='';
	val 		text:='';
	hash 		hstore;
	max_back_water 	float:=0.00;	--最大返水上限
	tmp_back_water 	float:=0.00;
	tmp_rb_id		int;
  	tmp_rb_volume 	FLOAT;
BEGIN
	keys = akeys(gradshash);
	FOR i IN 1..array_length(keys, 1)
	LOOP
		subkeys = regexp_split_to_array(keys[i], '_');
		keyname = keys[i];
		val = gradshash->keyname;
		SELECT * FROM strToHash(val) INTO hash;
		tmp_rb_id = hash->'id';
 		tmp_rb_volume = (hash->'valid_value')::FLOAT;

		IF rakeback_id = tmp_rb_id THEN
			IF volume >= (tmp_rb_volume::float) THEN
				tmp_back_water = (hash->'max_rakeback')::float;

				IF tmp_back_water > 0 THEN
					IF tmp_back_water > max_back_water THEN
						max_back_water = tmp_back_water;
					END IF;
				ELSE
					max_back_water = 0.0;
				END IF;
			END IF;
		END IF;

	END LOOP;
	RETURN max_back_water;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_limit(rakeback_id int, gradshash hstore, agenthash hstore, volume float)
IS 'Lins-返水-计算返水上限';

/**
 * 玩家[API]返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	gradshash 	返水梯度
 * @param 	agenthash 	各代理设置的梯度ID.
 * @param 	category 	类型.API或PLAYER,  区别在于KEY值不同. 另外GAME_TYPE 区别在于统计的维度不同.
**/
/*
DROP FUNCTION IF EXISTS gamebox_rakeback_api_map(TIMESTAMP, TIMESTAMP, hstore, hstore, TEXT);
create or replace function gamebox_rakeback_api_map(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	gradshash 	hstore,
	agenthash 	hstore,
	category 	TEXT
) returns hstore as $$

DECLARE
	hash 		hstore;--玩家API或玩家返水.
	rakeback 	FLOAT:=0.00;
	val 		FLOAT:=0.00;
	key 		TEXT:='';
	col_split 	TEXT:='_';
	rec 		record;
	param 		TEXT:='';
	sql 		TEXT:='';

BEGIN
	SELECT '-1=>-1' INTO hash;
	IF category = 'GAME_TYPE' THEN
		sql = 'SELECT rab.api_id,
					  rab.game_type,
					  rab.player_id,
					  COUNT(DISTINCT rab.player_id) 					as player_num,
				 FROM rakeback_api_base rab
			    WHERE rab.rakeback_time >= $1
				  AND rab.rakeback_time < $2
				  AND up.rakeback_id IS NOT NULL
			    GROUP BY rab.api_id, rab.game_type, rab.player_id';
	ELSE
		sql = 'SELECT rab.api_id,
					  rab.game_type,
					  rab.player_id,
					  SUM(rakeback)	rakeback
				 FROM rakeback_api_base rab
				WHERE rab.rakeback_time >= $1
				  AND rab.rakeback_time < $2
				GROUP BY rab.api_id, rab.game_type, rab.player_id';
	END IF;

	FOR rec IN EXECUTE sql USING start_time, end_time
	LOOP
		-- SELECT gamebox_rakeback_calculator(gradshash, agenthash, row_to_json(rec), NULL) into rakeback;

	  	IF category = 'GAME_TYPE' THEN
			key 	= rec.api_id||col_split||rec.game_type;
			param 	= key||'=>'||rec.rakeback||col_split||rec.player_num;
			hash 	= (SELECT param::hstore)||hash;
		ELSEIF category = 'API' THEN
			key 	= rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
			param 	= key||'=>'||rec.rakeback;
			hash 	= (SELECT param::hstore)||hash;
		ELSE
			key 	= rec.player_id;
			param 	= key||'=>'||rakeback;
			IF isexists(hash,  key) THEN
				val = (hash->key)::FLOAT;
				val = val + rakeback;
				param = key||'=>'||val;
			END IF;
			hash = (SELECT param::hstore)||hash;
		END IF;
	END LOOP;
	-- raise info 'Last Hash = %',  hash;

	RETURN hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_map(start_time TIMESTAMP, end_time TIMESTAMP, gradshash hstore, agenthash hstore, category TEXT)
IS 'Lins-返水-玩家[API]返水-返佣调用';
*/
/**
 * 玩家[API]返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	gradshash 	返水梯度
 * @param 	agenthash 	各代理设置的梯度ID.
 * @param 	category 	类型.API或PLAYER,  区别在于KEY值不同. 另外GAME_TYPE 区别在于统计的维度不同.
**/
--DROP FUNCTION IF EXISTS gamebox_rakeback_api_map(TIMESTAMP, TIMESTAMP, hstore, hstore, TEXT);
DROP FUNCTION IF EXISTS gamebox_rakeback_api_map(TIMESTAMP, TIMESTAMP, TEXT);
create or replace function gamebox_rakeback_api_map(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	--gradshash 	hstore, --v1.01  2016/06/01
	--agenthash 	hstore, --v1.01  2016/06/01
	category 	TEXT
) returns hstore as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-玩家[API]返水-返佣调用
--v1.01  2016/06/01  Leisure  修改参数，返水梯度改为内部获取
*/
DECLARE
	hash 		hstore;--玩家API或玩家返水.
	rakeback 	FLOAT:=0.00;
	val 		FLOAT:=0.00;
	key 		TEXT:='';
	col_split 	TEXT:='_';
	rec 		record;
	param 		TEXT:='';
	sql 		TEXT:='';
	gradshash 	hstore; --v1.01  2016/06/01  Leisure
	agenthash 	hstore; --v1.01  2016/06/01  Leisure
BEGIN

	--SELECT gamebox_rakeback_api_grads() into gradshash;
	--SELECT gamebox_agent_rakeback() into agenthash;

	SELECT '-1=>-1' INTO hash;
	IF category = 'GAME_TYPE' THEN
		sql = 'SELECT rab.api_id,
					  rab.game_type,
					  rab.player_id,
					  COUNT(DISTINCT rab.player_id) 					as player_num,
				 FROM rakeback_api_base rab
			    WHERE rab.rakeback_time >= $1
				  AND rab.rakeback_time < $2
				  AND up.rakeback_id IS NOT NULL
			    GROUP BY rab.api_id, rab.game_type, rab.player_id';
	ELSE
		sql = 'SELECT rab.api_id,
					  rab.game_type,
					  rab.player_id,
					  SUM(rakeback)	rakeback
				 FROM rakeback_api_base rab
				WHERE rab.rakeback_time >= $1
				  AND rab.rakeback_time < $2
				GROUP BY rab.api_id, rab.game_type, rab.player_id';
	END IF;

	FOR rec IN EXECUTE sql USING start_time, end_time
	LOOP
		-- SELECT gamebox_rakeback_calculator(gradshash, agenthash, row_to_json(rec), NULL) into rakeback;

	  IF category = 'GAME_TYPE' THEN
			key 	= rec.api_id||col_split||rec.game_type;
			param 	= key||'=>'||rec.rakeback||col_split||rec.player_num;
			hash 	= (SELECT param::hstore)||hash;
		ELSEIF category = 'API' THEN
			key 	= rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
			param 	= key||'=>'||rec.rakeback;
			hash 	= (SELECT param::hstore)||hash;
		ELSE
			key 	= rec.player_id;
			param 	= key||'=>'||rakeback;
			IF isexists(hash,  key) THEN
				val = (hash->key)::FLOAT;
				val = val + rakeback;
				param = key||'=>'||val;
			END IF;
			hash = (SELECT param::hstore)||hash;
		END IF;
	END LOOP;
	-- raise info 'Last Hash = %',  hash;

	RETURN hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_map(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT)
IS 'Lins-返水-玩家[API]返水-返佣调用';

/**
 * 返水API梯度.
 * @author 	Lins
 * @date	2015.11.10
**/
drop function if exists gamebox_rakeback_api_grads();
create or replace function gamebox_rakeback_api_grads()
returns hstore as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-API梯度
--v1.01  2016/08/01  Leisure  增加json字符串格式化，使之可以支持空格
*/
DECLARE
	rec 		record;
	param 		text:='';
	gradshash 	hstore;
	tmphash 	hstore;
	keyname 	text:='';
	val 		text:='';
	val2 		text:='';

BEGIN
	FOR rec in
		SELECT m.id,
					 s.id as grads_id,
					 d.api_id,
					 d.game_type,
					 COALESCE(d.ratio,0) 			as ratio,
					 COALESCE(s.max_rakeback,0) 	as max_rakeback,
					 COALESCE(s.valid_value,0) 	as valid_value,
					 m.name,
					 COALESCE(m.audit_num,0) 		as audit_num
		  FROM rakeback_grads s, rakeback_grads_api d, rakeback_set m
		 WHERE s.id = d.rakeback_grads_id
		   AND s.rakeback_id = m.id
		   AND m.status='1'
		 ORDER BY m.id, s.valid_value desc, d.api_id, d.game_type
	LOOP
		-- 判断主方案是否存在.
		-- 键值格式:ID + gradsId + API + gameType
		keyname = rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text||'_'||rec.valid_value::float;

		raise info 'keyname : %', keyname;

		val:=row_to_json(rec);

		val:=replace(val,',','\|');
		val:=replace(val,'null','-1');
		--v1.01  2016/08/01  Leisure
		val:='"' || replace(val,'"','\"') || '"';

		raise info 'val : %', val;

		IF (gradshash?keyname) is null OR (gradshash?keyname) = false THEN
			--gradshash=hash||tmphash;
			IF gradshash is null THEN
				select keyname||'=>'||val into gradshash;
			ELSE
				select keyname||'=>'||val into tmphash;
				raise info 'tmphash1 : %', tmphash;
				gradshash = gradshash||tmphash;
			END IF;

		ELSE
			val2 = gradshash->keyname;
			select keyname||'=>'||val||'^&^'||val2 into tmphash;
			--raise info 'tmphash2 : %', tmphash;
			gradshash = gradshash||tmphash;
		END IF;
	END LOOP;

	return gradshash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_grads()
IS 'Lins-返水-API梯度';

/**
 * 代理默认返水方案.
 * @author 	Lins
 * @date 	2015-11-10
 * @return 	hstore类型
**/
drop function IF EXISTS gamebox_agent_rakeback();
CREATE OR REPLACE FUNCTION gamebox_agent_rakeback()
	returns hstore as $$
DECLARE
	hash 	hstore;
	rec		record;
	param 	text:='';
BEGIN
	FOR rec IN
		SELECT a.user_id,
			   a.rakeback_id
		  FROM user_agent_rakeback a,
			   sys_user u
	     WHERE a.user_id = u.id
		   AND u.user_type = '23'
		   AND a.rakeback_id >= 0
    LOOP
		param = param||rec.user_id||'=>'||rec.rakeback_id||',';
	END LOOP;
	IF length(param) > 0 THEN
		param = substring(param,  1 , length(param)-1);
	END IF;
	SELECT param::hstore INTO hash;
	RETURN hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_agent_rakeback()
IS '返水-代理默认方案萃取-Lins';

/*
--测试返水已出账
SELECT  * FROM gamebox_rakeback(
	'5',
	'2016-03-01',
	'2016-03-31',
	'host=192.168.0.88 dbname=gb-companies user=gb-companies password=postgres',
	'Y'
);

--测试返水未出账
SELECT  * FROM gamebox_rakeback(
	'6',
	'2015-01-25',
	'2015-01-27',
	'host = 192.168.0.88 port = 5432 dbname = gamebox-mainsite user = postgres password = postgres',
	'N'
 );
*/
