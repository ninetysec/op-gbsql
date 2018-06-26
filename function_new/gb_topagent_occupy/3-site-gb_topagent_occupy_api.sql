DROP FUNCTION IF EXISTS gb_topagent_occupy_api( TEXT, INT, INT, hstore[]);
CREATE OR REPLACE FUNCTION gb_topagent_occupy_api(
  p_occupy_bill_no TEXT,
  p_occupy_year   INT,
  p_occupy_month   INT,
  p_net_maps hstore[]
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Laser  创建此函数: 总代占成账单-API占成
*/
DECLARE

  h_occupy_map hstore;

  rec_opt RECORD; --rec_agent_rebate_grads
  t_start_date DATE;
  t_end_date DATE;

  v_key VARCHAR;
  n_operation_ratio FLOAT:=0.00; --运营商占比
  n_operation_value FLOAT := 0.00;

  n_occupy_value FLOAT:=0.00; --总代占成金额

BEGIN

  --取得运营商占成
  h_occupy_map = p_net_maps[2];

  t_start_date = '' || p_occupy_year ||'-'|| p_occupy_month  ||'-'|| '1';
  t_end_date = t_start_date + INTERVAL'1 month';

  FOR rec_opt IN
    SELECT opt.topagent_id, opt.topagent_name, opt.api_id, opt.api_type_id, opt.game_type, opt.profit_amount, COALESCE(uaa.ratio, 0) topagent_ratio
      FROM
      (
      SELECT topagent_id, topagent_name, api_id, api_type_id, game_type,
             -COALESCE(SUM(profit_loss), 0) profit_amount
        FROM operate_topagent
       WHERE static_date >= t_start_date
         AND static_date < t_end_date
       GROUP BY topagent_id, topagent_name, api_id, api_type_id, game_type
      ) opt
      LEFT JOIN user_agent_api uaa
      ON opt.topagent_id = uaa.user_id AND opt.api_id = uaa.api_id AND opt.game_type = uaa.game_type
  LOOP

    v_key = rec_opt.api_id || '_' || rec_opt.game_type;

    n_operation_ratio = 0.00;

    --盈亏为负，运营商不占成
    IF rec_opt.profit_amount > 0 THEN
      IF isexists(h_occupy_map, v_key) THEN
        n_operation_ratio = (h_occupy_map->v_key)::FLOAT;
      ELSE
        RAISE NOTICE 'api: % game_type: % 未设置运营商占成！', rec_opt.api_id, rec_opt.game_type;
      END IF;
    END IF;

    n_operation_value = rec_opt.profit_amount * n_operation_ratio/100;

    n_occupy_value = rec_opt.profit_amount * (1 - n_operation_ratio/100) * rec_opt.topagent_ratio / 100;

    --插入总代API占成表
    INSERT INTO topagent_occupy_api ( occupy_bill_no, occupy_year, occupy_month, topagent_id, topagent_name, api_id, api_type_id, game_type,
      profit_amount, operation_ratio, operation_occupy, occupy_ratio, occupy_value)
    VALUES ( p_occupy_bill_no, p_occupy_year, p_occupy_month, rec_opt.topagent_id, rec_opt.topagent_name, rec_opt.api_id, rec_opt.api_type_id, rec_opt.game_type,
      rec_opt.profit_amount,n_operation_ratio, n_operation_value, rec_opt.topagent_ratio, n_occupy_value);

  END LOOP;

  RETURN 0;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_topagent_occupy_api( p_occupy_bill_no TEXT, p_occupy_year INT, p_occupy_month INT, p_net_maps hstore[])
IS 'Laser-总代占成账单-API占成';
