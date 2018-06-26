drop function if exists gamebox_operation_occupy_to_array(TEXT, INT);
create or replace function gamebox_operation_occupy_to_array(
    val 		TEXT,
    subscript 	INT
) returns FLOAT[] as $$
DECLARE
	vals 	TEXT[];
	subs 	TEXT[];
	cs 		TEXT = '_';
	rs 		TEXT = '\^&\^';
	limit_values FLOAT[];
BEGIN
	-- "1_01"=>"0_1000000_50^&^1000000_2000000_40^&^2000000_3000000_30"
	-- API 1,GameType 01在0到1000000比例为50...
	IF val is not null THEN
		vals = regexp_split_to_array(val, rs);
		-- raise info 'vals = %', vals;

		IF vals is not null AND array_length(vals,  1) > 0 THEN

			FOR i IN 1..array_length(vals,  1) LOOP
				subs = regexp_split_to_array(vals[i], cs);

				IF subs is not null AND array_length(subs,  1) = 3 THEN
					IF limit_values is null THEN
						limit_values = array[subs[subscript]::FLOAT];
					ELSE
						limit_values = array_append(limit_values, subs[subscript]::FLOAT);
					END IF;
				END IF;

			END LOOP;

		END IF;
	END IF;
	RETURN limit_values;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_to_array(val TEXT, subscript INT)
IS 'Lins-包网方案-梯度转数组';
