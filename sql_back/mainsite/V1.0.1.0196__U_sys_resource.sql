-- auto gen by orange 2015-12-29 20:34:22
update sys_resource set name='消息公告' where id = (select "id" from sys_resource s where s.url = 'messageAnnouncement/systemMessage.html')