-- auto gen by orange 2016-03-16 17:03:41
update notice_tmpl set title = '您于${time}申领的“${activityName}”优惠活动，申领失败！' ,content = '您于${time}申领的“${activityName}”优惠活动，由于未满足活动优惠条件，申领失败。感谢您的参与！' where group_code = '14419646138180-smfddgdfg' and publish_method='siteMsg';
update notice_tmpl set title = '您于${time}申领的“${activityName}”优惠活动，申领失败！' ,content = '尊敬的${user}，您好：很抱歉地通知您，您于${time}申领的“${activityName}”优惠活动，由于未满足活动优惠条件，申领失败。感谢您的参与！本邮件为系统自动发出，请勿直接回复！如有疑问，请联系客服处理。GameBox${year}年${month}月${day}日' where group_code = '14419646138180-smfddgdfg' and publish_method='email';