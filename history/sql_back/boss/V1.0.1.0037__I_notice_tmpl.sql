-- auto gen by cheery 2015-12-23 15:25:18
--创建找回密码模板
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'RESET_LOGIN_PASSWORD_SUCCESS', 'email', '1441964613861-iopqwere', 't', 'zh_TW', '${GameBox}-找回密码',
'<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">尊敬的</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${user}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">您好：</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;&nbsp;您于</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span><span style="font-size: 21px; font-family: 宋体;">申请重置登录密码的请求，已由</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">管理员</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${operator}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">授权</span><span style="font-size: 21px; font-family: 宋体;">处理成功！欢迎您使用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">新密码登录</span><span style="font-size: 21px; font-family: 宋体;">。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${GameBox}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">修改登录密码需</span><span style="font-size: 21px; font-family: 宋体;">启用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">最高权限，</span><span style="font-size: 21px; font-family: 宋体;">未经您本人同意，管理员将无权进行修改！若您担心账号安全，建议您</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">登录后</span><span style="font-size: 21px; font-family: 宋体;">通过</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">自助流程</span><span style="font-size: 21px; font-family: 宋体;">重设密码。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">请勿直接回复本邮件！如有疑问，请联系</span><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">在线客服</span><span style="font-size: 21px; font-family: 宋体;">或通过站内信的形式与我们取得联系。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
  <a href="${href}" target="_blank"><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">马上登录</span></a>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">$</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">{GameBox}</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span>
</p>
<p>
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;"><br/></span>
</p>
<p>
    <br/>
</p>',
 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
WHERE 'RESET_LOGIN_PASSWORD_SUCCESS' NOT in(SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='zh_TW');


INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'RESET_LOGIN_PASSWORD_SUCCESS', 'email', '1441964613861-iopqwere', 't', 'en_US', '${GameBox}-找回密码',
 '<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">尊敬的</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${user}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">您好：</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;&nbsp;您于</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span><span style="font-size: 21px; font-family: 宋体;">申请重置登录密码的请求，已由</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">管理员</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${operator}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">授权</span><span style="font-size: 21px; font-family: 宋体;">处理成功！欢迎您使用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">新密码登录</span><span style="font-size: 21px; font-family: 宋体;">。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${GameBox}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">修改登录密码需</span><span style="font-size: 21px; font-family: 宋体;">启用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">最高权限，</span><span style="font-size: 21px; font-family: 宋体;">未经您本人同意，管理员将无权进行修改！若您担心账号安全，建议您</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">登录后</span><span style="font-size: 21px; font-family: 宋体;">通过</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">自助流程</span><span style="font-size: 21px; font-family: 宋体;">重设密码。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">请勿直接回复本邮件！如有疑问，请联系</span><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">在线客服</span><span style="font-size: 21px; font-family: 宋体;">或通过站内信的形式与我们取得联系。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
  <a href="${href}" target="_blank"><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">马上登录</span></a>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">$</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">{GameBox}</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span>
</p>
<p>
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;"><br/></span>
</p>
<p>
    <br/>
</p>',
 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
WHERE 'RESET_LOGIN_PASSWORD_SUCCESS' NOT in(SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='en_US');


INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'RESET_LOGIN_PASSWORD_SUCCESS', 'email', '1441964613861-iopqwere', 't', 'zh_CN', '${GameBox}-找回密码',
'<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">尊敬的</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${user}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">您好：</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;&nbsp;您于</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span><span style="font-size: 21px; font-family: 宋体;">申请重置登录密码的请求，已由</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">管理员</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${operator}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">授权</span><span style="font-size: 21px; font-family: 宋体;">处理成功！欢迎您使用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">新密码登录</span><span style="font-size: 21px; font-family: 宋体;">。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${GameBox}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">修改登录密码需</span><span style="font-size: 21px; font-family: 宋体;">启用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">最高权限，</span><span style="font-size: 21px; font-family: 宋体;">未经您本人同意，管理员将无权进行修改！若您担心账号安全，建议您</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">登录后</span><span style="font-size: 21px; font-family: 宋体;">通过</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">自助流程</span><span style="font-size: 21px; font-family: 宋体;">重设密码。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">请勿直接回复本邮件！如有疑问，请联系</span><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">在线客服</span><span style="font-size: 21px; font-family: 宋体;">或通过站内信的形式与我们取得联系。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
  <a href="${href}" target="_blank"><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">马上登录</span></a>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">$</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">{GameBox}</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span>
</p>
<p>
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;"><br/></span>
</p>
<p>
    <br/>
</p>',
 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
WHERE 'RESET_LOGIN_PASSWORD_SUCCESS' NOT in(SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='zh_CN');




--创建重置安全密码模板
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'RESET_PERMISSION_PWD_SUCCESS', 'email', 'ac47dc50d5ec43dd965865c65f8be30c', 't', 'zh_TW', '${GameBox}-找回安全密码',
'<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">尊敬的</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${user}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">您好：</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;&nbsp;您于</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span><span style="font-size: 21px; font-family: 宋体;">申请重置安全密码的请求，已由</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">管理员</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${operator}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">授权</span><span style="font-size: 21px; font-family: 宋体;">处理成功！欢迎您使用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">新安全密码</span><span style="font-size: 21px; font-family: 宋体;">。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${GameBox}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">修改安全密码需</span><span style="font-size: 21px; font-family: 宋体;">启用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">最高权限，</span><span style="font-size: 21px; font-family: 宋体;">未经您本人同意，管理员将无权进行修改！若您担心账号安全，建议您</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">登录后</span><span style="font-size: 21px; font-family: 宋体;">通过</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">自助流程</span><span style="font-size: 21px; font-family: 宋体;">重设密码。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">请勿直接回复本邮件！如有疑问，请联系</span><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">在线客服</span><span style="font-size: 21px; font-family: 宋体;">或通过站内信的形式与我们取得联系。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <a href="${href}" target="_blank"><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">马上登录</span></a>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">$</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">{GameBox}</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span>
</p>
<p>
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;"><br/></span>
</p>
<p>
    <br/>
</p>',
 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
WHERE 'RESET_PERMISSION_PWD_SUCCESS' NOT in(SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='zh_TW');


INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'RESET_PERMISSION_PWD_SUCCESS', 'email', 'ac47dc50d5ec43dd965865c65f8be30c', 't', 'en_US', '${GameBox}-找回安全密码',
 '<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">尊敬的</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${user}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">您好：</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;&nbsp;您于</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span><span style="font-size: 21px; font-family: 宋体;">申请重置安全密码的请求，已由</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">管理员</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${operator}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">授权</span><span style="font-size: 21px; font-family: 宋体;">处理成功！欢迎您使用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">新安全密码</span><span style="font-size: 21px; font-family: 宋体;">。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${GameBox}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">修改安全密码需</span><span style="font-size: 21px; font-family: 宋体;">启用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">最高权限，</span><span style="font-size: 21px; font-family: 宋体;">未经您本人同意，管理员将无权进行修改！若您担心账号安全，建议您</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">登录后</span><span style="font-size: 21px; font-family: 宋体;">通过</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">自助流程</span><span style="font-size: 21px; font-family: 宋体;">重设密码。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">请勿直接回复本邮件！如有疑问，请联系</span><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">在线客服</span><span style="font-size: 21px; font-family: 宋体;">或通过站内信的形式与我们取得联系。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <a href="${href}" target="_blank"><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">马上登录</span></a>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">$</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">{GameBox}</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span>
</p>
<p>
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;"><br/></span>
</p>
<p>
    <br/>
</p>',
 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
WHERE 'RESET_PERMISSION_PWD_SUCCESS' NOT in(SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='en_US');


INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'RESET_PERMISSION_PWD_SUCCESS', 'email', 'ac47dc50d5ec43dd965865c65f8be30c', 't', 'zh_CN', '${GameBox}-找回安全密码',
'<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">尊敬的</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${user}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">您好：</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;&nbsp;您于</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span><span style="font-size: 21px; font-family: 宋体;">申请重置安全密码的请求，已由</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">管理员</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${operator}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">授权</span><span style="font-size: 21px; font-family: 宋体;">处理成功！欢迎您使用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">新安全密码</span><span style="font-size: 21px; font-family: 宋体;">。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;&nbsp;&nbsp;</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${GameBox}</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">修改安全密码需</span><span style="font-size: 21px; font-family: 宋体;">启用</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">最高权限，</span><span style="font-size: 21px; font-family: 宋体;">未经您本人同意，管理员将无权进行修改！若您担心账号安全，建议您</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">登录后</span><span style="font-size: 21px; font-family: 宋体;">通过</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">自助流程</span><span style="font-size: 21px; font-family: 宋体;">重设密码。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">请勿直接回复本邮件！如有疑问，请联系</span><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">在线客服</span><span style="font-size: 21px; font-family: 宋体;">或通过站内信的形式与我们取得联系。</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <span style="font-size: 21px; font-family: 宋体;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 43px;">
    <a href="${href}" target="_blank"><span style="color: rgb(91, 155, 213); font-size: 21px; font-family: 宋体;">马上登录</span></a>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px;">
    <span style="color: rgb(91, 155, 213); font-size: 21px; font-family: &#39;Times New Roman&#39;;">&nbsp;</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">$</span><span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">{GameBox}</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; white-space: normal; text-indent: 704px; text-align: right;">
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;">${date}</span>
</p>
<p>
    <span style="font-size: 21px; font-family: &#39;Times New Roman&#39;;"><br/></span>
</p>
<p>
    <br/>
</p>',
 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
WHERE 'RESET_PERMISSION_PWD_SUCCESS' NOT in(SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='zh_CN');

