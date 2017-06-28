-- auto gen by Water 2017-06-28 20:07:59
-- Online New SiteJob,offline the old SiteJob
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.AccountClearJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.PreferentialProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.PlayerRecommendAwardJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.RakebakeNotSettledProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.RakebakeProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.RebateProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.stat.SiteRakebackStatProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.stat.SiteRebateStatProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.stat.OperationProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.AgentOccupyProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.stat.StationBillProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.stat.TopAgentBillProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.stat.OperationProfileProcedureJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.AnalyzePlayerJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.AgentRebateJob';
update task_schedule set status='2' where job_class='so.wwb.gamebox.service.master.StationProfitLossJob';

