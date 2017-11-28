-- auto gen by admin 2016-04-13 21:19:29
DROP view IF EXISTS  v_player_game_order;

CREATE OR REPLACE VIEW  "v_player_game_order" AS
 SELECT
    g.*,
    u.username,
    u.site_id,
    u.user_type,
    agentuser.id AS agentid,
    agentuser.username AS agentusername,
    topagentuser.id AS topagentid,
    topagentuser.username AS topagentusername
   FROM (((player_game_order g
     LEFT JOIN sys_user u ON ((g.player_id = u.id)))
     LEFT JOIN sys_user agentuser ON ((u.owner_id = agentuser.id)))
     LEFT JOIN  sys_user topagentuser ON ((agentuser.owner_id = topagentuser.id)));


COMMENT ON VIEW "gb-site-1"."v_player_game_order" IS '交易记录视图-catban';

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)

  SELECT 20603,'查看总代详情的联系方式','userAgent/topagent/veiwDetail.html','查看总代详情的联系方式',206,'',1,'mcenter','role:topagent_veiwdetail','2','',true,true,true

  WHERE NOT EXISTS (select id from sys_resource t where t.id = 20603);



  insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)

  SELECT 20404,'查看代理详情的联系方式','userAgent/agent/veiwDetail.html','查看代理详情的联系方式',204,'',1,'mcenter','role:agent_veiwdetail','2','',true,true,true

  WHERE NOT EXISTS (select id from sys_resource t where t.id = 20404);