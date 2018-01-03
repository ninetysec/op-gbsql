-- auto gen by admin 2016-05-20 15:07:02
UPDATE "notice_tmpl" SET  "content" = '您于${time}申领的“${name}”优惠活动，已通过审核！优惠金额已发放至您的钱包，请注意查收！' ,
default_content = '您于${time}申领的“${name}”优惠活动，已通过审核！优惠金额已发放至您的钱包，请注意查收！'
WHERE	event_type = 'PREFERENCE_AUDIT_SUCCESS'  and locale='zh_CN' AND publish_method ='siteMsg';