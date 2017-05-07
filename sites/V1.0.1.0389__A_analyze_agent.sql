-- auto gen by cherry 2017-02-23 14:26:18
select redo_sqls($$
	ALTER TABLE analyze_agent ADD COLUMN rakeback_count int4;

	ALTER TABLE analyze_agent ADD COLUMN rakeback_amount numeric(20,2);

ALTER TABLE analyze_agent ADD COLUMN activity_count int4;

ALTER TABLE analyze_agent ADD COLUMN activity_amount numeric(20,2);

ALTER TABLE analyze_agent ADD COLUMN recommend_count int4;

ALTER TABLE analyze_agent ADD COLUMN recommend_amount numeric(20,2);

ALTER TABLE analyze_agent ADD COLUMN return_fee_count int4;

ALTER TABLE analyze_agent ADD COLUMN return_fee_amount numeric(20,2);

ALTER TABLE analyze_agent_domain ADD COLUMN rakeback_count int4;

ALTER TABLE analyze_agent_domain ADD COLUMN rakeback_amount numeric(20,2);

ALTER TABLE analyze_agent_domain ADD COLUMN activity_count int4;

ALTER TABLE analyze_agent_domain ADD COLUMN activity_amount numeric(20,2);

ALTER TABLE analyze_agent_domain ADD COLUMN recommend_count int4;

ALTER TABLE analyze_agent_domain ADD COLUMN recommend_amount numeric(20,2);

ALTER TABLE analyze_agent_domain ADD COLUMN return_fee_count int4;

ALTER TABLE analyze_agent_domain ADD COLUMN return_fee_amount numeric(20,2);

ALTER TABLE analyze_player ADD COLUMN activity_count int4;

ALTER TABLE analyze_player ADD COLUMN activity_amount numeric(20,2);

ALTER TABLE analyze_player ADD COLUMN rakeback_count int4;

ALTER TABLE analyze_player ADD COLUMN rakeback_amount numeric(20,2);

ALTER TABLE analyze_player ADD COLUMN recommend_count int4;

ALTER TABLE analyze_player ADD COLUMN recommend_amount numeric(20,2);

ALTER TABLE analyze_player ADD COLUMN return_fee_count int4;

ALTER TABLE analyze_player ADD COLUMN return_fee_amount numeric(20,2);

$$);

COMMENT ON COLUMN analyze_agent.rakeback_count IS '返水次数/人次';

COMMENT ON COLUMN analyze_agent.rakeback_amount IS '返水总额';

COMMENT ON COLUMN analyze_agent.activity_count IS '优惠次数/人次';

COMMENT ON COLUMN analyze_agent.activity_amount IS '优惠总额';

COMMENT ON COLUMN analyze_agent.recommend_count IS '推荐次数/人次';

COMMENT ON COLUMN analyze_agent.recommend_amount IS '推荐总额';

COMMENT ON COLUMN analyze_agent.return_fee_count IS '返手续费次数/人次';

COMMENT ON COLUMN analyze_agent.return_fee_amount IS '返手续费总额';

COMMENT ON COLUMN analyze_agent_domain.rakeback_count IS '返水次数/人次';

COMMENT ON COLUMN analyze_agent_domain.rakeback_amount IS '返水总额';

COMMENT ON COLUMN analyze_agent_domain.activity_count IS '优惠次数/人次';

COMMENT ON COLUMN analyze_agent_domain.activity_amount IS '优惠总额';

COMMENT ON COLUMN analyze_agent_domain.recommend_count IS '推荐次数/人次';

COMMENT ON COLUMN analyze_agent_domain.recommend_amount IS '推荐总额';

COMMENT ON COLUMN analyze_agent_domain.return_fee_count IS '返手续费次数/人次';

COMMENT ON COLUMN analyze_agent_domain.return_fee_amount IS '返手续费总额';

COMMENT ON COLUMN analyze_player.rakeback_count IS '返水次数/人次';

COMMENT ON COLUMN analyze_player.rakeback_amount IS '返水总额';

COMMENT ON COLUMN analyze_player.activity_count IS '优惠次数/人次';

COMMENT ON COLUMN analyze_player.activity_amount IS '优惠总额';

COMMENT ON COLUMN analyze_player.recommend_count IS '推荐次数/人次';

COMMENT ON COLUMN analyze_player.recommend_amount IS '推荐总额';

COMMENT ON COLUMN analyze_player.return_fee_count IS '返手续费次数/人次';

COMMENT ON COLUMN analyze_player.return_fee_amount IS '返手续费总额';