-- auto gen by cherry 2016-03-11 19:35:08
--代理注册 玩家注册信息模版内容更新为需求提供的文案
UPDATE "notice_tmpl" SET "title" = 'New member account registers successful.',

 "content" = 'Congratulation for you successful registered an account. We suggest you complete the account information in time because your current account security level is low now.'

WHERE	event_type = 'PLAYER_REGISTER_SUCCESS' AND "locale" = 'en_US' AND publish_method ='siteMsg';



UPDATE "notice_tmpl" SET "title" = '新玩家注册成功！',

 "content" = '恭喜您已成功注册账号！当前账户安全级别较低，建议您及时完善资料。'

WHERE	event_type = 'PLAYER_REGISTER_SUCCESS' AND "locale" = 'zh_TW' AND publish_method ='siteMsg';



UPDATE "notice_tmpl" SET "title" = '新玩家注册成功！',

 "content" = '恭喜您已成功注册账号！当前账户安全级别较低，建议您及时完善资料。'

WHERE	event_type = 'PLAYER_REGISTER_SUCCESS' AND "locale" = 'zh_CN' AND publish_method ='siteMsg';





UPDATE "notice_tmpl" SET "title" = '${sitename}账号注册成功！',

  "content" = '<p>尊敬的${user}，您好：</p><p>   恭喜您成功注册账号！欢迎登录${sitename}，祝您游戏愉快！如需帮助或咨询，请联系客服处理。</p><p style=""><span style="">本邮件为系统自动发出，请勿直接回复！</span></p><p style=""> GameBox</p><p style="line-height: normal;"><span style="">  ${year}年${month}月${day}日</span></p><p><br/></p>'

WHERE	event_type = 'PLAYER_REGISTER_SUCCESS' AND "locale" = 'zh_CN' AND publish_method ='email';



UPDATE "notice_tmpl" SET "title" = '${sitename}账号注册成功！',

 "content" = '<p>尊敬的${user}，您好：</p><p>   恭喜您成功注册账号！欢迎登录${sitename}，祝您游戏愉快！如需帮助或咨询，请联系客服处理。</p><p style=""><span style="">本邮件为系统自动发出，请勿直接回复！</span></p><p style=""> GameBox</p><p style="line-height: normal;"><span style="">  ${year}年${month}月${day}日</span></p><p><br/></p>'

WHERE	event_type = 'PLAYER_REGISTER_SUCCESS' AND "locale" = 'zh_TW' AND publish_method ='email';



UPDATE "notice_tmpl" SET "title" = 'Your account of  ${sitename} registers successful.',

 "content" = '<p>Dear ${user}:</p><p> Hello, congratulation for you successful register an account in our website. Welcome for login ${sitename}, enjoy the games. If you need help or have any queries, please contact us.</p><p> This mail is sent from system automatically, please don’t reply directed. Thanks.</p><p> Kindest Regards</p><p>${site}</p><p><br/></p>'

WHERE	event_type = 'PLAYER_REGISTER_SUCCESS' AND "locale" = 'en_US' AND publish_method ='email';





UPDATE "notice_tmpl" SET  "title" = 'The account registers successful.',

 "content" = 'Congratulation for you successful register an agent account of GameBox. You can login the agent center for account management now and expanding subordinate players by the promoting URL in the homepage. Thank you for your support and attention, looking forward cooperate with you.'

WHERE	event_type = 'AGENT_REGISTER_SUCCESS' AND "locale" = 'en_US' AND publish_method ='siteMsg';



UPDATE "notice_tmpl" SET "title" = '注册成功！ ',

 "content" = '恭喜您成功注册 ${sitename} 的代理账号！您现在可以通过首页的推广网址发展玩家了。感谢您对我们的支持与厚爱，期待与您合作愉快！'

WHERE	event_type = 'AGENT_REGISTER_SUCCESS' AND "locale" = 'zh_CN' AND publish_method ='siteMsg';



UPDATE "notice_tmpl" SET  "title" = '注册成功！ ',

 "content" = '恭喜您成功注册 ${sitename} 的代理账号！您现在可以通过首页的推广网址发展玩家了。感谢您对我们的支持与厚爱，期待与您合作愉快！'

WHERE	event_type = 'AGENT_REGISTER_SUCCESS' AND "locale" = 'zh_TW' AND publish_method ='siteMsg';



UPDATE "notice_tmpl"  SET  "title" = 'The agent account of ${sitename} registers successful.',

 "content" = '<p>Dear ${user}:</p><p> Hello, congratulation for you successful register an agent account of ${sitename}.</p><p>You can login the agent center for account management now and you can get the login URL from our customer service. You also can expand subordinate players by the promoting URLs in the homepage. Thank you for your support and attention, looking forward cooperate with you.</p><p> This mail is sent from system automatically, please don’t reply directed. Thanks.</p><p>Kindest Regards</p><p>${sitename}</p><p><br/></p>'

 WHERE	event_type = 'AGENT_REGISTER_SUCCESS' AND "locale" = 'en_US' AND publish_method ='email';



UPDATE "notice_tmpl" SET "title" = '${sitename}代理账号注册成功！',

 "content" = '  <p>尊敬的${user}，您好：</p><p>   恭喜您成功注册 ${sitename}的代理账号！</p><p>   现在您可以登录代理中心进行账户管理，登录地址请联系客服获取！您还可以：登录代理中心，通过首页的推广网址发展玩家；</p><p>   感谢您对我们的支持与厚爱，期待与您合作愉快！</p><p>   本邮件为系统自动发出，请勿直接回复！ </p><p> ${sitename}</p><p>${year}年${month}月${day}日</p><p><br/></p>'

WHERE	event_type = 'AGENT_REGISTER_SUCCESS' AND "locale" = 'zh_TW' AND publish_method ='email';



UPDATE "notice_tmpl" SET "title" = '${sitename}代理账号注册成功！',

 "content" = '<p>尊敬的${user}，您好：</p><p>   恭喜您成功注册 ${sitename}的代理账号！</p><p>   现在您可以登录代理中心进行账户管理，登录地址请联系客服获取！您还可以：登录代理中心，通过首页的推广网址发展玩家；</p><p>   感谢您对我们的支持与厚爱，期待与您合作愉快！</p><p>   本邮件为系统自动发出，请勿直接回复！ </p><p>${sitename}</p><p>${year}年${month}月${day}日</p><p><br/></p>'

WHERE	event_type = 'AGENT_REGISTER_SUCCESS' AND "locale" = 'zh_CN' AND publish_method ='email';



