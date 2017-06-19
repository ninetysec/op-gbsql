DROP FUNCTION IF EXISTS gamebox_rakeback(TEXT, TEXT, TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
DROP FUNCTION IF EXISTS gamebox_rakeback_api(INT, TIMESTAMP, TIMESTAMP, TEXT);
DROP FUNCTION IF EXISTS gamebox_rakeback_player(INT, TEXT);
DROP FUNCTION IF EXISTS gamebox_rakeback_limit(int, hstore, hstore);
DROP FUNCTION IF EXISTS gamebox_rakeback_api_map(TIMESTAMP, TIMESTAMP, hstore, hstore, TEXT);
DROP FUNCTION if exists gamebox_rakeback_api_grads();
DROP FUNCTION IF EXISTS gamebox_agent_rakeback();
DROP FUNCTION IF EXISTS gamebox_rakeback_limit(int, hstore, hstore, float);
