-- auto gen by george 2017-10-27 16:59:42
CREATE TABLE IF not EXISTS "import_agent" (
"id" varchar(50) COLLATE "default" NOT NULL,
"agentid" varchar(32) COLLATE "default",
"name" varchar(32) COLLATE "default",
"parentid" varchar(20) COLLATE "default"

)
WITH (OIDS=FALSE)
;