-- auto gen by steffan 2018-09-09 20:22:05
--add by hanson
create table if not exists devloper_tool_i18n
(
        trno varchar(32),
        plid integer,
        store_text varchar(60)
)
;


create index if not exists devloper_tool_i18n_plid_index
        on devloper_tool_i18n (plid)
;

create index if not exists devloper_tool_i18n_trno_index
        on devloper_tool_i18n (trno)
;

