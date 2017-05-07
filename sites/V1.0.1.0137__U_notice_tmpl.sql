-- auto gen by admin 2016-05-06 21:55:34
update sys_resource set privilege=true where id=20203;

update notice_tmpl set content='您于${time}申领的“${name}”优惠活动，已通过审核！优惠金额已发放至您的钱包，请注意查收！本邮件为系统自动发出，请勿直接回复！ ' where tmpl_type='auto' and event_type='PREFERENTIAL_APPLY_SUCCESS' and publish_method='siteMsg';

update notice_tmpl set title='账户异常，已被强制踢出！',"content"='您的账户可能存在异常行为，已于${time}被强制下线！如有疑问，请联系客服处理！' where tmpl_type='manual' and event_type='FORCE_KICK_OUT' and publish_method='siteMsg' and (locale='zh_CN' or locale='zh_TW');

update notice_tmpl set title='Your account is abnormal,it''s coercive logged out.',"content"='your account maybe has abnormal operation,it''s coercive logged out at ${time}.If case of any questions,please contact our online customer service.' where tmpl_type='manual' and event_type='FORCE_KICK_OUT' and publish_method='siteMsg' and locale='en_US';



update notice_tmpl set title='账户异常，已被强制踢出！',"content"='您的账户可能存在异常行为，已于${time}被强制下线！如有疑问，请联系客服处理！'

where tmpl_type='manual' and event_type='FORCE_KICK_OUT'  and publish_method='email' and (locale='zh_CN' or locale='zh_TW');


update notice_tmpl set title='Your account is abnormal,it''s coercive logged out.',

"content"='<p style="white-space: normal;">

    尊敬的${user}，您好：

</p>

<p style="white-space: normal;">

    您的账户可能存在异常行为，已于${time}被强制下线！

</p>

<p style="white-space: normal;">

    本邮件为系统自动发出，请勿直接回复！如有疑问，请联系客服处理！

</p>

<p style="white-space: normal; text-align: right;">

    ${sitename}

</p>

<p style="white-space: normal; text-align: right;">

    ${year}年${month}月${day}日

</p>

<p>

    <br/>

</p>'

where tmpl_type='manual' and event_type='FORCE_KICK_OUT' and publish_method='email' and locale='en_US';



update sys_param set param_value='[{"bulitIn":"true","id":1,"sort":1,"name":"username","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":2,"sort":2,"name":"password","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":3,"sort":3,"name":"verificationCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"false","id":4,"sort":4,"name":"regCode","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":5,"sort":5,"name":"defaultTimezone","isRequired":"2","isRegField":"1","status":"1"},{"bulitIn":"false","id":6,"sort":6,"name":"realName","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":7,"sort":7,"name":"nickName","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":8,"sort":8,"name":"110","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":9,"sort":9,"name":"201","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":10,"sort":10,"name":"301","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":11,"sort":11,"name":"countryCity","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":12,"sort":12,"name":"paymentPassword","isRequired":"2","isRegField":"1","status":"1"},{"bulitIn":"false","id":13,"sort":13,"name":"defaultLocale","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":14,"sort":14,"name":"mainCurrency","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":15,"sort":15,"name":"303","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":16,"sort":16,"name":"sex","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":17,"sort":17,"name":"302","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":18,"sort":18,"name":"birthday","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":19,"sort":19,"name":"serviceTerms","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":20,"sort":20,"name":"securityIssues","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":21,"sort":21,"name":"constellation","isRequired":"2","isRegField":"2","status":"1"}]' where param_type='reg_setting' and param_code='field_setting';

update sys_param set param_value='[{"bulitIn":"true","id":1,"sort":1,"name":"username","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":2,"sort":2,"name":"password","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"true","id":3,"sort":3,"name":"verificationCode","isRequired":"0","isRegField":"0","status":"1"},{"bulitIn":"false","id":4,"sort":4,"name":"regCode","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":5,"sort":5,"name":"defaultTimezone","isRequired":"2","isRegField":"1","status":"1"},{"bulitIn":"false","id":6,"sort":6,"name":"realName","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":7,"sort":7,"name":"nickName","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":8,"sort":8,"name":"110","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":9,"sort":9,"name":"201","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":10,"sort":10,"name":"301","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":11,"sort":11,"name":"countryCity","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":12,"sort":12,"name":"paymentPassword","isRequired":"2","isRegField":"1","status":"1"},{"bulitIn":"false","id":13,"sort":13,"name":"defaultLocale","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":14,"sort":14,"name":"mainCurrency","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":15,"sort":15,"name":"303","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":16,"sort":16,"name":"sex","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":17,"sort":17,"name":"302","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":18,"sort":18,"name":"birthday","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":19,"sort":19,"name":"serviceTerms","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":20,"sort":20,"name":"securityIssues","isRequired":"2","isRegField":"2","status":"1"},{"bulitIn":"false","id":21,"sort":21,"name":"constellation","isRequired":"2","isRegField":"2","status":"1"}]' where param_type='reg_setting_agent' and param_code='field_setting';

