-- auto gen by cherry 2017-10-24 14:11:13
INSERT INTO "digiccy_api_provider" ("code", "public_url", "private_url", "provider_class")
SELECT 'draglet', 'http://3rd.game.api.com/digiccy-api/gateway/public/', 'http://3rd.game.api.com/digiccy-api/gateway/private/', 'so.wwb.gamebox.service.master.digiccy.DragletClient'
WHERE not EXISTS (SELECT id FROM digiccy_api_provider where code='draglet');


UPDATE task_schedule SET job_method_arg='["site_job_101","site_job_110"]'
WHERE job_code='site-job-online-recharge';