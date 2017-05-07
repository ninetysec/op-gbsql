/**
 * Lins-运营商占成计算.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	limit_values 	梯度限值.
 * @param 	retios 			占成值.
 * @param 	amount 			盈亏额
 * @param 	assume 			盈亏共担
**/
drop function if exists gamebox_operation_occupy_calculate(FLOAT[], FLOAT[], FLOAT, BOOLEAN);
create or replace function gamebox_operation_occupy_calculate(
	limit_values 	FLOAT[],
	retios 			FLOAT[],
	amount 			FLOAT,
	assume 			BOOLEAN
) returns FLOAT as $$
DECLARE
	val 		FLOAT;
	pre_value 	FLOAT:=0.00;
	occupy 		FLOAT:=0.00;
	cal_amount 	FLOAT:=0.00;
	o_val 		FLOAT;
	c_val 		FLOAT;	-- 当前上限值.
	retio 		FLOAT;	-- 当前占成比例.
BEGIN
	val = amount;
	IF assume AND val < 0 THEN
		amount =- amount;
	ELSEIF assume = false AND val < 0 THEN
		raise info '盈亏不共担, 盈亏为负时, 占成计0';
		RETURN 0.00;	-- 盈亏不共担, 计税金额为负时, 占成计0.
	END IF;

	raise info '各API盈亏 = %', amount;
	IF array_length(limit_values,  1) = array_length(retios,  1) THEN
		FOR i IN 1..array_length(limit_values,  1) LOOP
			IF amount < 0 THEN
			 	exit;
			END IF;

			c_val = limit_values[i];
			-- raise info '------ c_val = %', c_val;

			--盈亏共担 且 计税金额为负 且 当前梯度为负
			IF assume AND val < 0 AND c_val < 0 THEN
				c_val = -c_val;
			END IF;

			retio = retios[i];
			cal_amount = c_val - pre_value;
			amount = amount - cal_amount;
			-- raise info '------ retio = %, cal_amount = %, amount = %, pre_value = %', retio, cal_amount, amount, pre_value;

			IF amount < 0 THEN
				o_val = (amount + cal_amount) * retio / 100;
				occupy = occupy + o_val;
				-- raise info '-----1 o_val = %, occupy = %', o_val, occupy;
				exit;
			ELSE
				o_val = cal_amount * retio / 100;
				occupy = occupy + o_val;
				pre_value = c_val;
				-- raise info '-----2 o_val = %, occupy = %', o_val, occupy;
			END IF;
		END LOOP;
	END IF;
	-- raise info '------ val2 = %', val;
	IF val < 0 THEN
		occupy = -occupy;
	END IF;

	-- raise info '各API盈亏 = %, 占成 = %', val, occupy;
	RETURN occupy;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_calculate(limit_values FLOAT[], retios FLOAT[], amount FLOAT, assume BOOLEAN)
IS 'Lins-运营商占成计算';