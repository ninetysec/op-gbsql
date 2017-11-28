-- auto gen by longer 2015-12-23 20:41:21

--Longer maintain for orange

SELECT redo_sqls($$
  ALTER TABLE "system_announcement" ADD COLUMN "announcement_subtype" varchar(32);
$$);

ALTER TABLE "system_announcement" RENAME "center_id" TO "site_id";

COMMENT ON COLUMN "system_announcement"."announcement_subtype" IS '公告子类型（游戏公告：日常公告，维护公告）';


--Longer for river
CREATE TABLE if not EXISTS  site_game_tag (
  id SERIAL4 NOT NULL , -- 主键
  site_id INTEGER, -- 站点ID
  game_id INTEGER, -- 游戏ID
  tag_id CHARACTER VARYING(64) -- 标签ID，site_i18n中setting.game_tag的key值
);
CREATE INDEX fk_site_game_tag_site_id ON site_game_tag USING BTREE (site_id);
CREATE INDEX fk_site_game_tag_game_id ON site_game_tag USING BTREE (game_id);
CREATE INDEX fk_site_game_tag_tag_id ON site_game_tag USING BTREE (tag_id);
COMMENT ON TABLE site_game_tag IS '游戏标签表 by River';
COMMENT ON COLUMN site_game_tag.id IS '主键';
COMMENT ON COLUMN site_game_tag.site_id IS '站点ID';
COMMENT ON COLUMN site_game_tag.game_id IS '游戏ID';
COMMENT ON COLUMN site_game_tag.tag_id IS '标签ID，site_i18n中setting.game_tag的key值';

----------------------------------

-- update sys_role set site_id=-2 where site_id=-1;
-- update sys_role set site_id=-1 where site_id=0;
-- update sys_role set site_id=0 where site_id=-2;
--
-- update sys_site set id=-2 where id=-1;
-- update sys_site set id=-1 where id=0;
-- update sys_site set id=0 where id=-2;
-- update sys_site set parent_id = -2 where parent_id = -1;
-- update sys_site set parent_id = -1 where parent_id = 0;
-- update sys_site set parent_id = -0 where parent_id = -2;
--
-- update sys_site_visitor set site_id=-2 where site_id=-1;
-- update sys_site_visitor set site_id=-1 where site_id=0;
-- update sys_site_visitor set site_id=0 where site_id=-2;
-- update system_announcement set site_id=-2 where site_id=-1;
-- update system_announcement set site_id=-1 where site_id=0;
-- update system_announcement set site_id=0 where site_id=-2;
-- update site_confine_area set site_id=-2 where site_id=-1;
-- update site_confine_area set site_id=-1 where site_id=0;
-- update site_confine_area set site_id=0 where site_id=-2;
-- update site_api_i18n set site_id=-2 where site_id=-1;
-- update site_api_i18n set site_id=-1 where site_id=0;
-- update site_api_i18n set site_id=0 where site_id=-2;
-- update sys_param set site_id=-2 where site_id=-1;
-- update sys_param set site_id=-1 where site_id=0;
-- update sys_param set site_id=0 where site_id=-2;
-- update sys_on_line_session set site_id=-2 where site_id=-1;
-- update sys_on_line_session set site_id=-1 where site_id=0;
-- update sys_on_line_session set site_id=0 where site_id=-2;
-- update v_site_api_type set site_id=-2 where site_id=-1;
-- update v_site_api_type set site_id=-1 where site_id=0;
-- update v_site_api_type set site_id=0 where site_id=-2;
-- update site_game set site_id=-2 where site_id=-1;
-- update site_game set site_id=-1 where site_id=0;
-- update site_game set site_id=0 where site_id=-2;
-- update site_introducer set site_id=-2 where site_id=-1;
-- update site_introducer set site_id=-1 where site_id=0;
-- update site_introducer set site_id=0 where site_id=-2;
-- update sys_domain set site_id=-2 where site_id=-1;
-- update sys_domain set site_id=-1 where site_id=0;
-- update sys_domain set site_id=0 where site_id=-2;
-- update site_api_type_relation set site_id=-2 where site_id=-1;
-- update site_api_type_relation set site_id=-1 where site_id=0;
-- update site_api_type_relation set site_id=0 where site_id=-2;
-- update site_i18n set site_id=-2 where site_id=-1;
-- update site_i18n set site_id=-1 where site_id=0;
-- update site_i18n set site_id=0 where site_id=-2;
-- update system_feedback set site_id=-2 where site_id=-1;
-- update system_feedback set site_id=-1 where site_id=0;
-- update system_feedback set site_id=0 where site_id=-2;
-- update sys_dept set site_id=-2 where site_id=-1;
-- update sys_dept set site_id=-1 where site_id=0;
-- update sys_dept set site_id=0 where site_id=-2;
-- update site_confine_ip set site_id=-2 where site_id=-1;
-- update site_confine_ip set site_id=-1 where site_id=0;
-- update site_confine_ip set site_id=0 where site_id=-2;
-- update site_contacts_position set site_id=-2 where site_id=-1;
-- update site_contacts_position set site_id=-1 where site_id=0;
-- update site_contacts_position set site_id=0 where site_id=-2;
-- update site_customer_service set site_id=-2 where site_id=-1;
-- update site_customer_service set site_id=-1 where site_id=0;
-- update site_customer_service set site_id=0 where site_id=-2;
-- update site_content set site_id=-2 where site_id=-1;
-- update site_content set site_id=-1 where site_id=0;
-- update site_content set site_id=0 where site_id=-2;
-- update sys_user set site_id=-2 where site_id=-1;
-- update sys_user set site_id=-1 where site_id=0;
-- update sys_user set site_id=0 where site_id=-2;
-- update site_language set site_id=-2 where site_id=-1;
-- update site_language set site_id=-1 where site_id=0;
-- update site_language set site_id=0 where site_id=-2;
-- update site_operate_area set site_id=-2 where site_id=-1;
-- update site_operate_area set site_id=-1 where site_id=0;
-- update site_operate_area set site_id=0 where site_id=-2;
-- update site_other_expenses set site_id=-2 where site_id=-1;
-- update site_other_expenses set site_id=-1 where site_id=0;
-- update site_other_expenses set site_id=0 where site_id=-2;
-- update site_api set site_id=-2 where site_id=-1;
-- update site_api set site_id=-1 where site_id=0;
-- update site_api set site_id=0 where site_id=-2;
-- update site_content_check set site_id=-2 where site_id=-1;
-- update site_content_check set site_id=-1 where site_id=0;
-- update site_content_check set site_id=0 where site_id=-2;
-- update site_currency set site_id=-2 where site_id=-1;
-- update site_currency set site_id=-1 where site_id=0;
-- update site_currency set site_id=0 where site_id=-2;
-- update site_api_type set site_id=-2 where site_id=-1;
-- update site_api_type set site_id=-1 where site_id=0;
-- update site_api_type set site_id=0 where site_id=-2;
-- update sys_domain_check set site_id=-2 where site_id=-1;
-- update sys_domain_check set site_id=-1 where site_id=0;
-- update sys_domain_check set site_id=0 where site_id=-2;
-- update site_api_type_i18n set site_id=-2 where site_id=-1;
-- update site_api_type_i18n set site_id=-1 where site_id=0;
-- update site_api_type_i18n set site_id=0 where site_id=-2;
-- update site_contacts set site_id=-2 where site_id=-1;
-- update site_contacts set site_id=-1 where site_id=0;
-- update site_contacts set site_id=0 where site_id=-2;
-- update sys_list_operator set site_id=-2 where site_id=-1;
-- update sys_list_operator set site_id=-1 where site_id=0;
-- update sys_list_operator set site_id=0 where site_id=-2;
-- update site_game_i18n set site_id=-2 where site_id=-1;
-- update site_game_i18n set site_id=-1 where site_id=0;
-- update site_game_i18n set site_id=0 where site_id=-2;
-- update site_game_tag set site_id=-2 where site_id=-1;
-- update site_game_tag set site_id=-1 where site_id=0;
-- update site_game_tag set site_id=0 where site_id=-2;
-- update sys_currency set center_id=-1 where center_id=0;
-- update system_feedback set center_id=-1 where center_id=0;
-- update site_contract_scheme set center_id=-1 where center_id=0;