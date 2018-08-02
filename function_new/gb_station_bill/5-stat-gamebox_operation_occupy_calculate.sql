drop function if exists gamebox_operation_occupy_calculate(FLOAT[], FLOAT[], FLOAT[], FLOAT, BOOLEAN);
create or replace function gamebox_operation_occupy_calculate(
  p_lower_values  FLOAT[],
	p_limit_values 	FLOAT[],
	p_retios 			FLOAT[],
	p_amount 			FLOAT,
	p_assume 			BOOLEAN
) returns FLOAT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/05/20  Laser    创建此函数: 运营商占成计算
--v1.01  2016/05/23  Laser    修正一处bug，盈亏为负，共担为负
--v1.02  2016/05/25  Laser    盈亏为正，最大上限取上限数组最大值
--v1.02  2016/10/29  Laser    由于视讯类可以互抵，盈亏为负的情况，放在外层逻辑处理
*/
DECLARE

	f_occupy FLOAT := 0;
	f_occupy_tmp FLOAT := 0;
	f_lower_val FLOAT := 0; --落在当前梯度的金额:=
	f_limit_val	FLOAT := 0; --f_limit_val - f_lower_val
	n_length	INT := 0;

BEGIN

	n_length := array_length(p_retios, 1);

	--raise info '各API盈亏 = %', p_amount;

	IF array_length(p_lower_values, 1) <> array_length(p_retios, 1) OR
		array_length(p_limit_values, 1) <> array_length(p_retios, 1) THEN
		raise info '占成梯度设置有误，请检查！';
		RETURN 0.00;
	END IF;

	IF p_amount < 0 THEN
		/*--v1.02  2016/10/29  Laser
		IF p_assume = false THEN
			raise info '盈亏不共担, 盈亏为负时, 占成计0';
			RETURN 0.00;	-- 盈亏不共担, 计税金额为负时, 占成计0.
		END IF;
		*/
		IF p_lower_values[1] >= 0 THEN
			raise info '未设置亏损占成方案, 盈亏为负时, 占成计0';
			RETURN 0.00;	-- 盈亏不共担, 计税金额为负时, 占成计0.
		END IF;

		--如果亏损超出最小梯度范围，超出部分按最小梯度计算
		IF p_amount < p_lower_values[1] THEN
			f_occupy := (p_amount - p_limit_values[1]) * p_retios[1] / 100;
		END IF;

		FOR i IN 1..n_length LOOP
			f_lower_val := p_lower_values[i];
			f_limit_val := p_limit_values[i];
			IF f_lower_val >= 0 THEN
				EXIT; --亏损时，>0的梯度信息无用
			END IF;

			IF p_amount >= f_limit_val THEN
				CONTINUE; --大于梯度上限，直接计算下一梯度
			END IF;

			--对于类似-100000~200000这种梯度设置的特殊处理
			IF f_limit_val > 0 THEN
				f_limit_val := 0;
			END IF;

			--f_lower_val 取梯度下限和亏损金额的大值
			IF f_lower_val < p_amount THEN
				f_lower_val := p_amount;
			END IF;

			f_occupy_tmp := (f_lower_val - f_limit_val) * p_retios[i] / 100; --v1.01
			f_occupy := f_occupy + f_occupy_tmp;

		END LOOP;
	ELSE
	--盈利时
		--如果盈利超出最大梯度范围，超出部分按最大梯度计算
		IF p_amount > p_limit_values[n_length] THEN --v1.02  2016/05/25  Laser
			f_occupy := (p_amount - p_limit_values[n_length]) * p_retios[n_length] / 100;
			--raise info 'p_amount :%  p_limit_values :%  p_retios:%  f_occupy :%', p_amount, p_lower_values[n_length], p_retios[n_length], f_occupy;
		END IF;

		FOR i IN 1..n_length LOOP
			f_lower_val := p_lower_values[i];
			f_limit_val := p_limit_values[i];
			IF f_limit_val <= 0 THEN
				CONTINUE; --盈利时时，<0的梯度信息无用
			END IF;
			IF p_amount <= f_lower_val THEN
				CONTINUE; --小于梯度下限，直接计算下一梯度
			END IF;

			--对于类似-100000~200000这种梯度设置的特殊处理
			IF f_lower_val < 0 THEN
				f_lower_val := 0;
			END IF;

			--f_limit_val 取梯度上限和盈利金额的小值
			IF f_limit_val > p_amount THEN
				f_limit_val := p_amount;
			END IF;

			f_occupy_tmp := (f_limit_val - f_lower_val) * p_retios[i] / 100;
			f_occupy := f_occupy + f_occupy_tmp;

			--raise info 'f_lower_val :%  f_limit_val :%  f_occupy_tmp:%  f_occupy :%', f_lower_val, f_limit_val, f_occupy_tmp, f_occupy;

		END LOOP;

	END IF;

	RETURN f_occupy;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_calculate(p_lower_values  FLOAT[], p_limit_values FLOAT[], p_retios FLOAT[], p_amount FLOAT, p_assume BOOLEAN)
IS 'Laser-运营商占成计算';
