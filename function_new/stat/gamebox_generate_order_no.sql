DROP FUNCTION if exists gamebox_generate_order_no(TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_generate_order_no(
	trans_type 	TEXT,
	site_code 	TEXT,
	order_type 	TEXT,
	url 		TEXT
) returns TEXT as $$
DECLARE
	order_no TEXT:='';
BEGIN
	SELECT INTO order_no seq FROM dblink(
		url,
		'SELECT gamebox_generate_order_no('''||trans_type||''', '''||site_code||''' , '''||order_type||''')'
	) as p(seq TEXT);
	RETURN order_no;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_generate_order_no(trans_type TEXT, site_code TEXT, order_type TEXT, url TEXT)
IS 'Lins-生成流水号';
