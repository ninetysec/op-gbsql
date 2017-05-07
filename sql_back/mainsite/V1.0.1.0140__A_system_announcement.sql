-- auto gen by cheery 2015-12-10 09:10:08
UPDATE sys_resource SET url = 'report/operate/operateIndex.html', remark = '运营中心-报表-经营报表', sort_num = 3 WHERE id = (SELECT id FROM sys_resource WHERE "name" = '经营报表' AND parent_id = 5 AND subsys_code = 'ccenter');

select redo_sqls($$
 ALTER TABLE system_announcement ADD COLUMN center_id int4 NULL;
$$);

COMMENT ON COLUMN system_announcement.center_id IS '总控或运营商ID';

/* -------- 系统公告视图 -------- */
DROP VIEW IF EXISTS v_system_announcement;
