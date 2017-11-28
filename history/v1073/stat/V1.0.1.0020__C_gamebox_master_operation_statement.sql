-- auto gen by admin 2016-05-04 20:59:45
drop function IF EXISTS gamebox_master_operation_statement(text, int, text, text, date, text);

CREATE OR REPLACE FUNCTION gamebox_master_operation_statement(

	conn 		TEXT,

	siteid 		INT,

	startTime 	TEXT,

	endTime 		TEXT,

	curday 		DATE,

	url 		TEXT

) RETURNS TEXT AS $$

DECLARE

	rtn TEXT:='' ;

BEGIN

	SELECT

		INTO rtn P .msg

	FROM

		dblink (conn,

			'SELECT * from gamebox_operations_statement('''||url||''', '||siteid||', '''||startTime||''', '''||endTime||''')'

		) AS P (msg TEXT);

	RETURN rtn ;

	END $$ LANGUAGE plpgsql;



COMMENT ON FUNCTION gamebox_master_operation_statement(conn TEXT, siteid INT, startTime TEXT, endTime TEXT, curday DATE, url text)

IS 'Lins-经营报表-玩家.代理.总代报表';