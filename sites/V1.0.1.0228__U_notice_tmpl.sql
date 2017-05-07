-- auto gen by bruce 2016-08-20 10:42:44
UPDATE notice_tmpl
    SET "content"='<p>尊敬的代理${user},您好:</p><p>管理员拒绝发放了您本期（${startDate}~${endDate}）的返佣,如有疑问,请联系客服处理!</p><p><span>本邮件为系统自动发出,请勿直接回复!</span></p><p>${sitename}</p><p><span>${sendYear}年${sendMonth}月${sendDay}日</span></p><p><br/></p>',
        "default_content"='<p>尊敬的代理${user},您好:</p><p>管理员拒绝发放了您本期（${startDate}~${endDate}）的返佣,如有疑问,请联系客服处理!</p><p><span>本邮件为系统自动发出,请勿直接回复!</span></p><p>${sitename}</p><p><span>${sendYear}年${sendMonth}月${sendDay}日</span></p><p><br/></p>'
WHERE "tmpl_type"='manual' AND "event_type"='REFUSE_RETURN_COMMISSION' AND built_in='t' AND publish_method='email';

UPDATE "notice_tmpl" SET
  "content"='<p>Dear ${user}:</p><p> Hello, congratulation for you successful register an account in our website. Welcome for login ${sitename}, enjoy the games. If you need help or have any queries, please contact us.</p><p> This mail is sent from system automatically, please don’t reply directed. Thanks.</p><p> Kindest Regards</p><p>${site}</p><p><br/></p>',
  "default_content"='<p>Dear ${user}:</p><p> Hello, congratulation for you successful register an account in our website. Welcome for login ${sitename}, enjoy the games. If you need help or have any queries, please contact us.</p><p> This mail is sent from system automatically, please don’t reply directed. Thanks.</p><p> Kindest Regards</p><p>${site}</p><p><br/></p>'
WHERE "tmpl_type"='auto' AND "event_type"='PLAYER_REGISTER_SUCCESS' AND built_in='t' AND publish_method='email' and "locale"='en_US';

UPDATE "notice_tmpl" SET
  "content"='<p>尊敬的${user}，您好：</p><p>   恭喜您成功注册账号！欢迎登录${sitename}，祝您游戏愉快！如需帮助或咨询，请联系客服处理。</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p> GameBox</p><p><span>  ${year}年${month}月${day}日</span></p><p><br/></p>',
  "default_content"='<p>尊敬的${user}，您好：</p><p>   恭喜您成功注册账号！欢迎登录${sitename}，祝您游戏愉快！如需帮助或咨询，请联系客服处理。</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p> GameBox</p><p><span>  ${year}年${month}月${day}日</span></p><p><br/></p>'
WHERE "tmpl_type"='auto' AND "event_type"='PLAYER_REGISTER_SUCCESS' AND "publish_method"='email' AND "locale"='zh_CN' AND built_in='t';

UPDATE "notice_tmpl" SET "locale"='zh_TW',
  "content"='<p>尊敬的${user}，您好：</p><p>   恭喜您成功注册账号！欢迎登录${sitename}，祝您游戏愉快！如需帮助或咨询，请联系客服处理。</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p> GameBox</p><p><span>  ${year}年${month}月${day}日</span></p><p><br/></p>',
  "default_content"='<p>尊敬的${user}，您好：</p><p>   恭喜您成功注册账号！欢迎登录${sitename}，祝您游戏愉快！如需帮助或咨询，请联系客服处理。</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p> GameBox</p><p><span>  ${year}年${month}月${day}日</span></p><p><br/></p>'
WHERE "tmpl_type"='auto' AND "event_type"='PLAYER_REGISTER_SUCCESS' AND "publish_method"='email' AND "locale"='zh_TW' AND built_in='t';

UPDATE "notice_tmpl" SET
  "content"='<p><span>尊敬的</span><span>${user}</span><span>，您好：</span></p><p><span>您于</span><span>${</span><span>orderlaunchtime</span><span>}</span><span>提交的</span><span>${</span><span>orderamount</span><span>}</span><span>存款订单${</span><span>ordernum</span><span>}</span><span>已成功到账，请登录${sitename}查收！如未到账，请联系客服处理。</span></p><p><span>本邮件为系统自动发出，请勿直接回复！</span><span>&nbsp;</span></p><p><span>${sitename}</span></p><p><span>${year}</span><span>年</span><span>${month}</span><span>月</span><span>${day}</span><span>日</span></p><p><br/></p>',
  "default_content"='<p><span>尊敬的</span><span>${user}</span><span>，您好：</span></p><p><span>您于</span><span>${</span><span>orderlaunchtime</span><span>}</span><span>提交的</span><span>${</span><span>orderamount</span><span>}</span><span>存款订单${</span><span>ordernum</span><span>}</span><span>已成功到账，请登录${sitename}查收！如未到账，请联系客服处理。</span></p><p><span>本邮件为系统自动发出，请勿直接回复！</span><span>&nbsp;</span></p><p><span>${sitename}</span></p><p><span>${year}</span><span>年</span><span>${month}</span><span>月</span><span>${day}</span><span>日</span></p><p><br/></p>'
WHERE "tmpl_type"='auto' AND "event_type"='DEPOSIT_AUDIT_SUCCESS' AND "publish_method"='email' AND "locale"='zh_CN' AND built_in='t';

UPDATE "notice_tmpl" SET
  "content"='<p><span>尊敬的</span><span>${user}</span><span>，您好：</span></p><p><span>您于</span><span>${</span><span>orderlaunchtime</span><span>}</span><span>提交的</span><span>${</span><span>orderamount</span><span>}</span><span>存款订单${</span><span>ordernum</span><span>}</span><span>已成功到账，请登录${sitename}查收！如未到账，请联系客服处理。</span></p><p><span>本邮件为系统自动发出，请勿直接回复！</span><span>&nbsp;</span></p><p><span>${sitename}</span></p><p><span>${year}</span><span>年</span><span>${month}</span><span>月</span><span>${day}</span><span>日</span></p><p><br/></p>',
  "default_content"='<p><span>尊敬的</span><span>${user}</span><span>，您好：</span></p><p><span>您于</span><span>${</span><span>orderlaunchtime</span><span>}</span><span>提交的</span><span>${</span><span>orderamount</span><span>}</span><span>存款订单${</span><span>ordernum</span><span>}</span><span>已成功到账，请登录${sitename}查收！如未到账，请联系客服处理。</span></p><p><span>本邮件为系统自动发出，请勿直接回复！</span><span>&nbsp;</span></p><p><span>${sitename}</span></p><p><span>${year}</span><span>年</span><span>${month}</span><span>月</span><span>${day}</span><span>日</span></p><p><br/></p>'
WHERE "tmpl_type"='auto' AND "event_type"='DEPOSIT_AUDIT_SUCCESS' AND "publish_method"='email' AND "locale"='zh_TW' AND built_in='t';

UPDATE "notice_tmpl" SET
  "content"='<p><span>Dear&nbsp;${user},&nbsp;</span></p><p><span>Hello,&nbsp;the ${</span><span>orderamount</span><span>} </span><span>deposit order ${</span><span>ordernum</span><span>} when you submitted at ${</span><span>orderlaunchtime</span><span>}</span><span>&nbsp;has been successfully. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;Please login&nbsp;your account&nbsp;to check whether the amount arrive your&nbsp;wallet.&nbsp;If&nbsp;it&nbsp;doesn&#39;t,&nbsp;please&nbsp;contact&nbsp;us.</span></p><p><span>This&nbsp;mail&nbsp;is&nbsp;sent&nbsp;from&nbsp;system&nbsp;automatically,&nbsp;please&nbsp;don&#39;t&nbsp;reply&nbsp;directly.&nbsp;</span></p><p><span>Best&nbsp;Regards</span></p><p><span>${sitename}</span></p><p><br/></p>',
  "default_content"='<p><span>Dear&nbsp;${user},&nbsp;</span></p><p><span>Hello,&nbsp;the ${</span><span>orderamount</span><span>} </span><span>deposit order ${</span><span>ordernum</span><span>} when you submitted at ${</span><span>orderlaunchtime</span><span>}</span><span>&nbsp;has been successfully. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;Please login&nbsp;your account&nbsp;to check whether the amount arrive your&nbsp;wallet.&nbsp;If&nbsp;it&nbsp;doesn&#39;t,&nbsp;please&nbsp;contact&nbsp;us.</span></p><p><span>This&nbsp;mail&nbsp;is&nbsp;sent&nbsp;from&nbsp;system&nbsp;automatically,&nbsp;please&nbsp;don&#39;t&nbsp;reply&nbsp;directly.&nbsp;</span></p><p><span>Best&nbsp;Regards</span></p><p><span>${sitename}</span></p><p><br/></p>'
WHERE "tmpl_type"='auto' AND "event_type"='DEPOSIT_AUDIT_SUCCESS' AND "publish_method"='email' AND "locale"='en_US' AND built_in='t';

UPDATE notice_tmpl SET
  "content"='<p>尊敬的${user}，您好：</p><p>本期（${startDate}~${endDate}）（返佣周期）期间的返佣已发放至您的账户，请注意查收！</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p>${sitename}</p><p><span>${sendYear}年${sendMonth}月${sendDay}日</span></p><p><br/></p>',
  "default_content"='<p>尊敬的${user}，您好：</p><p>本期（${startDate}~${endDate}）（返佣周期）期间的返佣已发放至您的账户，请注意查收！</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p>${sitename}</p><p><span>${sendYear}年${sendMonth}月${sendDay}日</span></p><p><br/></p>'
WHERE "tmpl_type"='auto' AND "event_type"='RETURN_COMMISSION_SUCCESS' AND "publish_method"='email' AND "locale"='en_US' AND built_in='t';

UPDATE notice_tmpl SET
  "content"='<p>尊敬的${user}，您好：</p><p>本期（${startDate}~${endDate}）（返佣周期）期间的返佣已发放至您的账户，请注意查收！</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p>${sitename}</p><p><span>${sendYear}年${sendMonth}月${sendDay}日</span></p><p><br/></p>',
  "default_content"='<p>尊敬的${user}，您好：</p><p>本期（${startDate}~${endDate}）（返佣周期）期间的返佣已发放至您的账户，请注意查收！</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p>${sitename}</p><p><span>${sendYear}年${sendMonth}月${sendDay}日</span></p><p><br/></p>'
WHERE "tmpl_type"='auto' AND "event_type"='RETURN_COMMISSION_SUCCESS' AND "publish_method"='email' AND "locale"='zh_CN' AND built_in='t';

UPDATE notice_tmpl SET
  "content"='<p>尊敬的${user}，您好：</p><p>本期（${startDate}~${endDate}）（返佣周期）期间的返佣已发放至您的账户，请注意查收！</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p>${sitename}</p><p><span>${sendYear}年${sendMonth}月${sendDay}日</span></p><p><br/></p>',
  "default_content"='<p>尊敬的${user}，您好：</p><p>本期（${startDate}~${endDate}）（返佣周期）期间的返佣已发放至您的账户，请注意查收！</p><p><span>本邮件为系统自动发出，请勿直接回复！</span></p><p>${sitename}</p><p><span>${sendYear}年${sendMonth}月${sendDay}日</span></p><p><br/></p>'
WHERE "tmpl_type"='auto' AND "event_type"='RETURN_COMMISSION_SUCCESS' AND "publish_method"='email' AND "locale"='zh_TW' AND built_in='t';