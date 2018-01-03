
select redo_sqls($$
		DROP TABLE IF EXISTS "net_contract_scheme";
		DROP TABLE IF EXISTS "favorable_scheme";
		DROP TABLE IF EXISTS "favorable_scheme_detail";
		DROP TABLE IF EXISTS "assume_scheme";
		DROP TABLE IF EXISTS "assume_scheme_detail";
		DROP TABLE IF EXISTS "occupy_scheme";
		DROP TABLE IF EXISTS "occupy_scheme_grads";
		DROP TABLE IF EXISTS "occupy_scheme_detail";
$$);

