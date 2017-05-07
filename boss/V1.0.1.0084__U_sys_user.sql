-- auto gen by fei 2016-07-14 21:13:30
UPDATE sys_user SET default_locale = 'zh_CN' WHERE default_locale IS NULL OR default_locale = '';
UPDATE sys_user SET default_currency = 'CNY' WHERE default_currency IS NULL OR default_currency = '';
