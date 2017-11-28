-- auto gen by admin 2016-05-27 15:51:55
--site库
--添加邮箱验证的模板

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select 'auto', 'BIND_EMAIL_VERIFICATION_CODE', 'email', '1423934613861-iopqwere1', 't', 'zh_CN', '邮箱验证', '亲爱的用户，您好：
感谢您使用${sitename}！您正在进行邮箱验证，本次请求的验证码为：${verificationCode}（30分钟内有效）。请将此验证码填入验证框内，以完成验证！
本邮件为系统自动发出，请勿直接回复！如有疑问，请联系<a href="${customer}">在线客服</a>。

                                            ${sitename}
                                                                                                    ${year}年${month}月${day}日', 't', '邮箱验证', '亲爱的用户，您好：
感谢您使用${sitename}！您正在进行邮箱验证，本次请求的验证码为：${verificationCode}（30分钟内有效）。请将此验证码填入验证框内，以完成验证！
本邮件为系统自动发出，请勿直接回复！如有疑问，请联系<a href="${customer}">在线客服</a>。

                                            ${sitename}
                                                                                                    ${year}年${month}月${day}日', '2016-05-24 08:23:03', '0', NULL, NULL, 't'
where 'BIND_EMAIL_VERIFICATION_CODE' not  in (select event_type from notice_tmpl where event_type='BIND_EMAIL_VERIFICATION_CODE' and locale='zh_CN' );

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select 'auto', 'BIND_EMAIL_VERIFICATION_CODE', 'email', '1423934613861-iopqwere1', 't', 'zh_TW', '邮箱验证', '亲爱的用户，您好：
感谢您使用${sitename}！您正在进行邮箱验证，本次请求的验证码为：${verificationCode}（30分钟内有效）。请将此验证码填入验证框内，以完成验证！
本邮件为系统自动发出，请勿直接回复！如有疑问，请联系<a href="${customer}">在线客服</a>。

                                            ${sitename}
                                                                                                    ${year}年${month}月${day}日', 't', '邮箱验证', '亲爱的用户，您好：
感谢您使用${sitename}！您正在进行邮箱验证，本次请求的验证码为：${verificationCode}（30分钟内有效）。请将此验证码填入验证框内，以完成验证！
本邮件为系统自动发出，请勿直接回复！如有疑问，请联系<a href="${customer}">在线客服</a>。

                                            ${sitename}
                                                                                                    ${year}年${month}月${day}日', '2016-05-24 08:23:03', '0', NULL, NULL, 't'
where 'BIND_EMAIL_VERIFICATION_CODE' not  in (select event_type from notice_tmpl where event_type='BIND_EMAIL_VERIFICATION_CODE' and locale='zh_TW' );

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select 'auto', 'BIND_EMAIL_VERIFICATION_CODE', 'email', '1423934613861-iopqwere1', 't', 'en_US', '邮箱验证', '亲爱的用户，您好：
感谢您使用${sitename}！您正在进行邮箱验证，本次请求的验证码为：${verificationCode}（30分钟内有效）。请将此验证码填入验证框内，以完成验证！
本邮件为系统自动发出，请勿直接回复！如有疑问，请联系<a href="${customer}">在线客服</a>。

                                            ${sitename}
                                                                                                    ${year}年${month}月${day}日', 't', '邮箱验证', '亲爱的用户，您好：
感谢您使用${sitename}！您正在进行邮箱验证，本次请求的验证码为：${verificationCode}（30分钟内有效）。请将此验证码填入验证框内，以完成验证！
本邮件为系统自动发出，请勿直接回复！如有疑问，请联系<a href="${customer}">在线客服</a>。

                                            ${sitename}
                                                                                                    ${year}年${month}月${day}日', '2016-05-24 08:23:03', '0', NULL, NULL, 't'
where 'BIND_EMAIL_VERIFICATION_CODE' not  in (select event_type from notice_tmpl where event_type='BIND_EMAIL_VERIFICATION_CODE' and locale='en_US' );

