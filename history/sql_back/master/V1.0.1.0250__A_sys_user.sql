-- auto gen by cheery 2015-12-07 12:44:59
select redo_sqls($$
   ALTER TABLE sys_user ADD COLUMN freeze_title varchar(128);
   ALTER TABLE sys_user ADD COLUMN freeze_content TEXT;
$$);

COMMENT ON COLUMN sys_user.freeze_title IS '账号冻结标题';

COMMENT ON COLUMN sys_user.freeze_content IS '账号冻结内容';

--更新菜单
UPDATE sys_resource SET url='fund/companyDespoit/list.html?search.rechargeStatus=1' WHERE name='公司入款审核' AND subsys_code='mcenter';