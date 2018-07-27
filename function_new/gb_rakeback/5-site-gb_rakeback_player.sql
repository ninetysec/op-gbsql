DROP FUNCTION IF EXISTS gb_rakeback_player(INT, TEXT);
create or replace function gb_rakeback_player(
  p_bill_id   INT,
  p_settle_flag   TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2017/01/18  Laser   创建此函数: 返水.玩家返水
--v1.10  2017/07/01  Laser   增加pending_lssuing字段，以支持返水重结
--v1.20  2018/06/28  Linsen  添加代理线
--v1.21  2018/07/25  Laser   修改分组条件保证player_id, agent_id唯一
*/
DECLARE

BEGIN

  IF p_settle_flag = 'Y' THEN--已出账
    --v1.20  2018/06/28  Linsen
    INSERT INTO rakeback_player(
        rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker, settlement_state,
        agent_id, top_agent_id, audit_num, rakeback_total, rakeback_actual, rakeback_paid, rakeback_pending, agent_username, topagent_username
    )
    SELECT p_bill_id, ut.id, ut.username, ut.rank_id, ut.rank_name, ut.risk_marker, 'pending_lssuing',
           --agent_id, top_agent_id,
           ra.agent_id, uta.id topagent_id, ra.audit_num, ra.rakeback, ra.rakeback, 0, ra.rakeback, ua.username agent_username, uta.username topagent_username
      FROM (
            SELECT player_id,
									 agent_id, --v1.20  2018/06/28  Linsen
									 --agent_username,
									 --topagent_id,
									 --topagent_username,
                   CASE WHEN SUM(rakeback) > MIN(rakeback_limit) THEN COALESCE(MIN(rakeback_limit),0) ELSE COALESCE(SUM(rakeback),0) END rakeback, --顺序不能改，因为返水上限可能为NULL
                   MIN(audit_num) audit_num,
                   SUM(effective_transaction) effective_transaction
              FROM rakeback_api
             WHERE rakeback_bill_id = p_bill_id
             --v1.20  2018/06/28  Linsen
             --GROUP BY player_id, agent_id, agent_username, topagent_id, topagent_username
             --v1.21  2018/07/25
             GROUP BY player_id, agent_id
          ) ra
            LEFT JOIN
          v_sys_user_tier ut ON ra.player_id = ut.id
            LEFT JOIN
          sys_user ua ON ra.agent_id = ua.id
            LEFT JOIN
          sys_user uta ON ua.owner_id = uta.id
     ORDER BY ra.rakeback DESC, ut.id, ra.agent_id;

  ELSEIF p_settle_flag = 'N' THEN--未出账
    --v1.20  2018/06/28  Linsen
    INSERT INTO rakeback_player_nosettled (
        rakeback_bill_nosettled_id, player_id, username, rank_id, rank_name, risk_marker,
        agent_id, top_agent_id, audit_num, rakeback_total, agent_username, topagent_username
    )
    SELECT p_bill_id, ut.id, ut.username, ut.rank_id, ut.rank_name, ut.risk_marker,
           ra.agent_id, uta.id topagent_id, ra.audit_num, ra.rakeback, ua.username agent_username, uta.username topagent_username
      FROM (
            SELECT player_id,
									 agent_id, --v1.20  2018/06/28  Linsen
									 --agent_username,
									 --topagent_id,
									 --topagent_username,
                   CASE WHEN SUM(rakeback) > MIN(rakeback_limit) THEN COALESCE(MIN(rakeback_limit),0) ELSE COALESCE(SUM(rakeback),0) END rakeback, --顺序不能改，因为返水上限可能为NULL
                   MIN(audit_num) audit_num,
                   SUM(effective_transaction) effective_transaction
              FROM rakeback_api_nosettled
             WHERE rakeback_bill_nosettled_id = p_bill_id
             --v1.20  2018/06/28  Linsen
             --GROUP BY player_id, agent_id, agent_username, topagent_id, topagent_username
             --v1.21  2018/07/25
             GROUP BY player_id, agent_id
          ) ra
            LEFT JOIN
          v_sys_user_tier ut ON ra.player_id = ut.id
            LEFT JOIN
          sys_user ua ON ra.agent_id = ua.id
            LEFT JOIN
          sys_user uta ON ua.owner_id = uta.id
     ORDER BY ra.rakeback DESC, ut.id;

  END IF;

END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_player(p_bill_id INT, p_settle_flag TEXT)
IS 'Laser-返水.玩家返水';