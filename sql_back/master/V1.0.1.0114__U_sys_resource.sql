-- auto gen by fly 2015-10-14 10:23:53
UPDATE sys_resource
   SET url = 'report/settlementRebate/report.html',
    remark = '统计报表-佣金报表'
WHERE ID = ( SELECT ID
               FROM sys_resource
              WHERE NAME = '佣金报表'
                AND parent_id = (SELECT ID
                                   FROM sys_resource
                                  WHERE NAME = '统计报表'
                                )
           );
