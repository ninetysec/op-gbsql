-- auto gen by george 2017-10-27 16:55:12
CREATE TABLE IF not EXISTS "import_qj" (
"agent" varchar(255) COLLATE "default",
"user_account" varchar(255) COLLATE "default",
"blance" varchar(255) COLLATE "default",
"real_name" varchar(255) COLLATE "default",
"mobile" varchar(255) COLLATE "default",
"email" varchar(255) COLLATE "default",
"bank_name" varchar(255) COLLATE "default",
"bank_short_name" varchar(255) COLLATE "default",
"bank_card_master_name" varchar(255) COLLATE "default",
"bankcard_number" varchar(255) COLLATE "default",
"bank_depoist" varchar(255) COLLATE "default",
"custom_bank_name" varchar(255) COLLATE "default",
"id" varchar(50) COLLATE "default" NOT NULL,
"rank" varchar(255) COLLATE "default",
"page" varchar(20) COLLATE "default",
"crypmobile" varchar(255) COLLATE "default",
"crypemail" varchar(200) COLLATE "default",
"crypassword" varchar(200) COLLATE "default",
"password" varchar(100) COLLATE "default",
"regist_code" varchar(50) COLLATE "default",
CONSTRAINT "import_qj_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;