-- auto gen by admin 2016-05-20 10:49:36
UPDATE notice_text set tmpl_content = replace(tmpl_content, 'GameBox', 'Hongtu');

ALTER TABLE player_recommend_award
   ALTER COLUMN recommend_user_id DROP NOT NULL;
COMMENT ON COLUMN player_recommend_award.recommend_user_id IS '被推荐人ID';

DROP INDEX if EXISTS fk_player_recommend_award_recommend_user_id;