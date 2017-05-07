gamebox_agent_rakeback()
gamebox_agent_statement(curday date, rec json)
gamebox_collect_site_infor(hostinfo text, site_id int4)
gamebox_collect_site_infor(hostinfo text, site_id int4, vname text)
gamebox_current_site()
gamebox_expense_calculate(cost_map "hstore", sys_map "hstore", category text)
gamebox_expense_gather(start_time timestamp, end_time timestamp)
gamebox_expense_gather(start_time timestamp, end_time timestamp, category text)
gamebox_expense_gather(start_time timestamp, end_time timestamp, row_split text, col_split text)
gamebox_expense_map(start_time timestamp, end_time timestamp, sys_map "hstore")
gamebox_expense_share(cost_map "hstore", sys_map "hstore")
gamebox_generate_order_no(trans_type text, site_code text, order_type text)
gamebox_occupy(name text, start_time text, end_time text, url text)
gamebox_occupy_agent(bill_id int4)
gamebox_occupy_api(bill_id int4, start_time timestamp, end_time timestamp, occupy_grads_map "hstore", operation_occupy_map "hstore", rakeback_map "hstore", rebate_grads_map "hstore", agent_check_map "hstore")
gamebox_occupy_api_calculator(occupy_grads_map "hstore", operation_occupy_map "hstore", owner_id int4, player_id int4, api_id int4, game_type text, profit_amount float8)
gamebox_occupy_api_map(start_time timestamp, end_time timestamp, occupy_grads_map "hstore", operation_occupy_map "hstore")
gamebox_occupy_api_set()
gamebox_occupy_bill(name text, start_time timestamp, end_time timestamp, bill_id int8, op text)
gamebox_occupy_expense_gather(bill_id int4, start_time timestamp, end_time timestamp)
gamebox_occupy_expense_map(start_time timestamp, end_time timestamp, sys_map "hstore")
gamebox_occupy_map(name text, start_time text, end_time text, url text)
gamebox_occupy_map(url text, start_time text, end_time text)
gamebox_occupy_player(bill_id int4, cost_map "hstore", sys_map "hstore")
gamebox_occupy_topagent(bill_id int4)
gamebox_occupy_value(start_time timestamp, end_time timestamp, expense_map "hstore")
gamebox_operation_occupy(category text)
gamebox_operation_occupy(start_time timestamp, end_time timestamp, category text)
gamebox_operations_agent(curday text, rec json)
gamebox_operations_occupy(hashs "_hstore", start_time timestamp, end_time timestamp, category text, key_type int4)
gamebox_operations_occupy(url text, site_id int4, start_time timestamp, end_time timestamp, category text, is_max bool, key int4)
gamebox_operations_occupy(url text, start_time timestamp, end_time timestamp, category text, key_type int4)
gamebox_operations_occupy_calculate(hash "hstore", rec json, category text)
gamebox_operations_player(start_time text, end_time text, curday text, rec json)
gamebox_operations_site(curday text)
gamebox_operations_statement(mainhost text, sid int4, start_time text, end_time text)
gamebox_operations_topagent(curday text, rec json)
gamebox_player_statement(start_time text, end_time text, curday date, rec json)
gamebox_rakeback(name text, starttime text, endtime text, url text, flag text)
gamebox_rakeback_api(bill_id int4, start_time timestamp, end_time timestamp, gradshash "hstore", agenthash "hstore", flag text)
gamebox_rakeback_api_grads()
gamebox_rakeback_api_map(start_time timestamp, end_time timestamp, gradshash "hstore", agenthash "hstore", category text)
gamebox_rakeback_bill(name text, start_time timestamp, end_time timestamp, bill_id int4, op text, flag text)
gamebox_rakeback_calculator(gradshash "hstore", agenthash "hstore", rec json)
gamebox_rakeback_map(starttime timestamp, endtime timestamp, url text, category text)
gamebox_rakeback_player(bill_id int4, flag text)
gamebox_rebate(name text, starttime text, endtime text, url text, flag text)
gamebox_rebate_agent(bill_id int4, flag text)
gamebox_rebate_agent_check(gradshash "hstore", agenthash "hstore", start_time timestamp, end_time timestamp)
gamebox_rebate_agent_default_set()
gamebox_rebate_api(bill_id int4, start_time timestamp, end_time timestamp, gradshash "hstore", checkhash "hstore", mainhash "hstore", flag text)
gamebox_rebate_api(rebate_bill_id int4, start_time timestamp, e(rebate_bill_id int4, start_time timestamp, end_time timestamp, gradshash "hstore", checkhash "hstore", mainhash "hstore")
gamebox_rebate_api_grads()
gamebox_rebate_bill(name text, start_time timestamp, end_time timestamp, bill_id int4, op text, flag text)
gamebox_rebate_calculator(rebate_grads_map "hstore", agent_check_map "hstore", agent_id int4, api_id int4, game_type text, profit_amount float8, operation_occupy float8)
gamebox_rebate_expense_gather(bill_id int4, rakebackhash "hstore", start_time timestamp, end_time timestamp, row_split text, col_split text)
gamebox_rebate_map(start_time timestamp, end_time timestamp, key_type int4, rebate_grads_map "hstore", agent_check_map "hstore", operation_occupy_map "hstore")
gamebox_rebate_map(url text, start_time text, end_time text, category text)
gamebox_rebate_player(syshash "hstore", expense_map "hstore", rakeback_map "hstore", bill_id int4, row_split text, col_split text, flag text)
gamebox_rebate_rakeback_map(starttime timestamp, endtime timestamp)
gamebox_site_game(url text, vname text, site_id int4, op text)
gamebox_site_statement(curday date)
gamebox_site_statement(curday text)
gamebox_station_bill(main_url text, master_url text, start_time text, end_time text, flag int4)
gamebox_sys_param(paramtype text)
gamebox_topagent_statement(curday date, rec json)