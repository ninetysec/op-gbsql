DROP FUNCTION if EXISTS gamebox_operations_occupy(TEXT, TIMESTAMP, TIMESTAMP, TEXT, INT);
DROP FUNCTION if EXISTS gamebox_operations_occupy(TEXT, INT, TIMESTAMP, TIMESTAMP, TEXT, BOOLEAN, INT);
DROP FUNCTION if EXISTS gamebox_operations_occupy(hstore[], TIMESTAMP, TIMESTAMP, TEXT, INT);
DROP FUNCTION if EXISTS gamebox_operations_occupy_calculate(hstore, json, text);
DROP FUNCTION IF EXISTS gamebox_operation_occupy(TIMESTAMP, TIMESTAMP, TEXT);
DROP FUNCTION if EXISTS gamebox_operations_occupy(TEXT, TIMESTAMP, TIMESTAMP, TEXT, INT);