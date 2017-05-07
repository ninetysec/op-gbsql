-- auto gen by cherry 2016-12-07 11:46:12
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '408', '结算账单', 'operation/stationbill/list.html', '结算账单', '4', '', '8', 'boss', 'operate:jszd', '1', NULL, 'f', 't', 't'
where 408 not in (select id from sys_resource where id=408);
