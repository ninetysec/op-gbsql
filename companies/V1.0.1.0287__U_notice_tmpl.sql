-- auto gen by cherry 2017-05-22 14:55:00
UPDATE notice_tmpl set
"content"='站点【${siteId}】${siteName}的盈利上限已使用${rate}%！${view}'
WHERE
event_type='PROFIT_MAX_YELLOW';