-- auto gen by cheery 2015-11-05 07:56:28

UPDATE sys_resource SET "icon"='home',url='home/homeIndex.html' WHERE id='41';
UPDATE sys_resource SET "icon"='capital' WHERE id='42';
UPDATE sys_resource SET "icon"='gamerecord' WHERE id='43';
UPDATE sys_resource SET "icon"='sale',url='preferential/list.html' WHERE id='44';
UPDATE sys_resource SET "icon"='info' WHERE id='45';
UPDATE sys_resource SET "icon"='accout' WHERE id='46';
UPDATE sys_resource SET "icon"='recommend' WHERE id='47';

update sys_resource set url = '/fund/transaction/chart.html' where name = '资金记录' and subsys_code = 'pcenter';
UPDATE sys_resource set url='personalInformation/list.html' where id='4602';
UPDATE sys_resource SET url='loginLog/list.html' WHERE id='4603';
UPDATE sys_resource SET url='fund/playerRecharge/recharge.html' WHERE id='4202';
UPDATE sys_resource SET url='playerRecommendAward/recommend.html' WHERE id='4701';
UPDATE sys_resource SET url='operation/pAnnouncementMessage/messageList.html' WHERE id='4501';
UPDATE sys_resource SET url='player/withdraw/withdrawList.html' WHERE id='4203';
UPDATE sys_resource SET url='fund/playerTransfer/transfers.html' WHERE id='4201';
UPDATE sys_resource SET url='accountSettings/list.html' WHERE id='4601';
UPDATE sys_resource SET url='playerRecommendAward/recommendRecord.html' WHERE id='4702';
UPDATE "sys_resource" SET "url"='playerGameOrder/list.html'  WHERE ("id"='4301');
UPDATE "sys_resource" SET "url"='playerGameOrder/list.html?search.orderState=pending_settle' WHERE ("id"='4302');

update sys_resource set  privilege='t' where id=706;