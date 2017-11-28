-- auto gen by wayne 2016-08-27 10:08:28
CREATE TABLE IF NOT EXISTS "bank_orders" (
	"id" serial4 NOT NULL,
	"center_id" int4,
	"site_id" int4,
	"master_id" int4,
	"user_id" int4,
	"user_name" varchar(50) COLLATE "default",
	"serialid" varchar(100) COLLATE "default" NOT NULL,
	"frombank" varchar(50) COLLATE "default",
	"fkname" varchar(50) COLLATE "default",
	"skname" varchar(50) COLLATE "default",
	"fkbankid" varchar(50) COLLATE "default",
	"skbankid" varchar(50) COLLATE "default",
	"fkarea" varchar(50) COLLATE "default",
	"skarea" varchar(50) COLLATE "default",
	"fkpoint" varchar(50) COLLATE "default",
	"skpoint" varchar(50) COLLATE "default",
	"jyqd" varchar(50) COLLATE "default",
	"money" numeric(20,2),
	"fee" numeric(20,2),
	"moneyflag" varchar(50) COLLATE "default",
	"messages" text COLLATE "default",
	"tradetime" timestamp(6),
	"tradestatus" varchar(50) COLLATE "default",
	"adddate" timestamp(6),
	"rstateid" int4,
	"explain" varchar(50) COLLATE "default",
	CONSTRAINT "bankorders_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
