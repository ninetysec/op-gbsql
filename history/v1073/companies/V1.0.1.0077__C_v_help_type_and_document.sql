-- auto gen by admin 2016-04-13 21:23:23
DROP VIEW if  EXISTS  v_help_type_and_document;
CREATE or REPLACE VIEW "v_help_type_and_document" AS
 SELECT h.id,
    h.parent_id,
    h.order_num,
    (( SELECT array_to_json(array_agg(row_to_json(a1.*))) AS array_to_json
           FROM ( SELECT help_type_i18n.name,
                    help_type_i18n.local AS language
                   FROM  help_type_i18n
                  WHERE (help_type_i18n.help_type_id = h.id)) a1))::text AS help_type_name_json,
    (( SELECT array_to_json(array_agg(row_to_json(a2.*))) AS ss
           FROM ( SELECT help_document.id
                   FROM help_document
                  WHERE ((help_document.help_type_id = h.id) AND (help_document.is_delete = false))
                  ORDER BY help_document.order_num ASC, help_document.create_time ASC) a2))::text AS document_id_json
   FROM help_type h
  WHERE (h.is_delete = false)
  ORDER BY h.id;