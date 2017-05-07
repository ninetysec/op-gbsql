-- auto gen by fei 2016-07-14 21:15:16
UPDATE sys_user SET default_locale = 'zh_CN' WHERE default_locale IS NULL OR default_locale = '' AND user_type = '21';
UPDATE sys_user SET default_currency = 'CNY' WHERE default_currency IS NULL OR default_currency = '' AND user_type = '21';
