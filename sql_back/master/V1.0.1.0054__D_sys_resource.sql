-- auto gen by tom 2015-09-08 15:59:02
DELETE FROM SYS_ROLE_RESOURCE where resource_id IN (SELECT ID FROM SYS_RESOURCE WHERE NAME='偏好设置' AND URL='setting/preference/index.html');
DELETE from SYS_RESOURCE WHERE NAME='偏好设置' AND URL='setting/preference/index.html';
