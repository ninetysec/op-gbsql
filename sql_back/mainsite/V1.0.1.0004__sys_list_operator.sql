--修改用户自定义查询条件，列表显示保存表的description字段

select redo_sqls($$
    alter table sys_list_operator alter COLUMN description type VARCHAR(100);
$$);