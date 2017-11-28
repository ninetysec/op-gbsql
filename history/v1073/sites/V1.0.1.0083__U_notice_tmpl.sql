-- auto gen by cherry 2016-03-23 10:07:14
UPDATE notice_tmpl SET  "title" = '${sitename}注册验证码',  "content"='<p>亲爱的用户，您好：</p><p>   感谢您使用${sitename}！您正在进行邮箱验证，本次请求的验证码为：<strong>${verificationCode}</strong>。请将此验证码填入验证框内，以完成验证！</p><p>   本邮件为系统自动发出，请勿直接回复！如有疑问，请联系<a href="${customer}" target="_blank">在线客服</a>。</p><p> ${sitename}</p><p> ${year}年${month}月${day}日</p><p><br/></p>'

WHERE event_type='BIND_EMAIL_VERIFICATION_CODE' AND locale='zh_CN' AND  publish_method='email';



UPDATE notice_tmpl SET  "title" = '${sitename}注册验证码',  "content"='<p>亲爱的用户，您好：</p><p>   感谢您使用${sitename}！您正在进行邮箱验证，本次请求的验证码为：<strong>${verificationCode}</strong>。请将此验证码填入验证框内，以完成验证！</p><p>   本邮件为系统自动发出，请勿直接回复！如有疑问，请联系<a href="${customer}" target="_blank">在线客服</a>。</p><p> ${sitename}</p><p> ${year}年${month}月${day}日</p><p><br/></p>'

WHERE event_type='BIND_EMAIL_VERIFICATION_CODE' AND locale='zh_TW' AND  publish_method='email';



UPDATE notice_tmpl SET  "title" = '${sitename}注册验证码',  "content"='<p>亲爱的用户，您好：</p><p>   感谢您使用${sitename}！您正在进行邮箱验证，本次请求的验证码为：<strong>${verificationCode}</strong>。请将此验证码填入验证框内，以完成验证！</p><p>   本邮件为系统自动发出，请勿直接回复！如有疑问，请联系<a href="${customer}" target="_blank">在线客服</a>。</p><p> ${sitename}</p><p> ${year}年${month}月${day}日</p><p><br/></p>'

WHERE event_type='BIND_EMAIL_VERIFICATION_CODE' AND locale='en_US' AND  publish_method='email';

