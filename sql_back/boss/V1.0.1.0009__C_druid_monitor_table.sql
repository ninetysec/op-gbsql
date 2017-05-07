-- auto gen by longer 2015-09-14 21:03:52

--druid 监控脚本
create table IF NOT EXISTS druid_domain (
	id SERIAL8 NOT NULL,
	domain varchar(45) NOT NULL,
	PRIMARY KEY (id)
);






create table IF NOT EXISTS druid_app (
	id SERIAL8  NOT NULL,
	domain varchar(45) NOT NULL,
	app varchar(45) NOT NULL,
	PRIMARY KEY (id)
);



create table IF NOT EXISTS druid_cluster (
	id SERIAL8  NOT NULL,
	domain varchar(45) NOT NULL,
	app varchar(45) NOT NULL,
	cluster varchar(45) NOT NULL,
	PRIMARY KEY (id)
);





create table IF NOT EXISTS druid_inst (
	id SERIAL8  NOT NULL,
	app varchar(45) NOT NULL,
	domain varchar(45) NOT NULL,
	cluster varchar(45) NOT NULL,
	host varchar(128) NOT NULL,
	ip varchar(32) NOT NULL,
	lastActiveTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	lastPID bigint NOT NULL,
	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS druid_const (
	id SERIAL8 NOT NULL,
	domain varchar(45) NOT NULL, 
	app varchar(45) NOT NULL, 
	type varchar(45) NOT NULL,
	hash bigint NOT NULL,
	value text,
	PRIMARY KEY (id)
);




CREATE TABLE IF NOT EXISTS druid_datasource (
	id SERIAL8 NOT NULL,
	domain varchar(45) NOT NULL, 
	app varchar(45) NOT NULL, 
	cluster varchar(45) NOT NULL, 
	host varchar(128), 
	pid integer NOT NULL,
	collectTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	name varchar(256), 
	dbType varchar(256), 
	driverClassName varchar(256), 
	activeCount integer,
	activePeak integer,
	activePeakTime bigint,
	poolingCount integer,
	poolingPeak integer,
	poolingPeakTime bigint,
	connectCount bigint,
	closeCount bigint,
	waitThreadCount bigint,
	notEmptyWaitCount bigint,
	notEmptyWaitNanos bigint,
	logicConnectErrorCount bigint,
	physicalConnectCount bigint,
	physicalCloseCount bigint,
	physicalConnectErrorCount bigint,
	executeCount bigint,
	errorCount bigint,
	commitCount bigint,
	rollbackCount bigint,
	pstmtCacheHitCount bigint,
	pstmtCacheMissCount bigint,
	startTransactionCount bigint,
	txn_0_1 bigint,
	txn_1_10 bigint,
	txn_10_100 bigint,
	txn_100_1000 bigint,
	txn_1000_10000 bigint,
	txn_10000_100000 bigint,
	txn_more bigint,
	clobOpenCount bigint,
	blobOpenCount bigint,
	sqlSkipCount bigint,
	PRIMARY KEY (id)
);



CREATE TABLE IF NOT EXISTS druid_springmethod (
	id SERIAL8 NOT NULL, 
	domain varchar(45) NOT NULL, 
	app varchar(45) NOT NULL, 
	cluster varchar(45) NOT NULL, 
	host varchar(128), 
	pid integer NOT NULL,
	collectTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	className varchar(256), 
	signature varchar(256), 
	runningCount integer,
	concurrentMax integer,
	executeCount bigint,
	executeErrorCount bigint,
	executeTimeNano bigint,
	jdbcFetchRowCount bigint,
	jdbcUpdateCount bigint,
	jdbcExecuteCount bigint,
	jdbcExecuteErrorCount bigint,
	jdbcExecuteTimeNano bigint,
	jdbcCommitCount bigint,
	jdbcRollbackCount bigint,
	jdbcPoolConnectionOpenCount bigint,
	jdbcPoolConnectionCloseCount bigint,
	jdbcResultSetOpenCount bigint,
	jdbcResultSetCloseCount bigint,
	lastErrorClass varchar(256), 
	lastErrorMessage varchar(256), 
	lastErrorStackTrace varchar(256), 
	lastErrorTimeMillis bigint,
	h1 bigint,
	h10 bigint,
	h100 bigint,
	h1000 bigint,
	h10000 integer,
	h100000 integer,
	h1000000 integer,
	hmore integer,
	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS druid_sql (
	id SERIAL8 NOT NULL, 
	domain varchar(45) NOT NULL, 
	app varchar(45) NOT NULL, 
	cluster varchar(45) NOT NULL, 
	host varchar(128), 
	pid integer NOT NULL,
	collectTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	sqlHash bigint,
	dataSource varchar(256), 
	lastStartTime bigint,
	batchTotal bigint,
	batchToMax integer,
	execSuccessCount bigint,
	execNanoTotal bigint,
	execNanoMax bigint,
	running integer,
	concurrentMax integer,
	rsHoldTime bigint,
	execRsHoldTime bigint,
	name varchar(256), 
	file varchar(256), 
	dbType varchar(256), 
	execNanoMaxOccurTime bigint,
	errorCount bigint,
	errorLastMsg varchar(256), 
	errorLastClass varchar(256), 
	errorLastStackTrace varchar(256), 
	errorLastTime bigint,
	updateCount bigint,
	updateCountMax bigint,
	fetchRowCount bigint,
	fetchRowCountMax bigint,
	inTxnCount bigint,
	lastSlowParameters varchar(256), 
	clobOpenCount bigint,
	blobOpenCount bigint,
	readStringLength bigint,
	readBytesLength bigint,
	inputStreamOpenCount bigint,
	readerOpenCount bigint,
	h1 bigint,
	h10 bigint,
	h100 integer,
	h1000 integer,
	h10000 integer,
	h100000 integer,
	h1000000 integer,
	hmore integer,
	eh1 bigint,
	eh10 bigint,
	eh100 integer,
	eh1000 integer,
	eh10000 integer,
	eh100000 integer,
	eh1000000 integer,
	ehmore integer,
	f1 bigint,
	f10 bigint,
	f100 bigint,
	f1000 integer,
	f10000 integer,
	fmore integer,
	u1 bigint,
	u10 bigint,
	u100 bigint,
	u1000 integer,
	u10000 integer,
	umore integer,
	PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS druid_wall(
	id SERIAL8 NOT NULL , 
	domain varchar(45)  NOT NULL, 
	app varchar(45)  NOT NULL, 
	cluster varchar(45)  NOT NULL, 
	host varchar(128), 
	pid integer  NOT NULL,
	collectTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	name varchar(256), 
	checkCount bigint,
	hardCheckCount bigint,
	violationCount bigint,
	whiteListHitCount bigint,
	blackListHitCount bigint,
	syntaxErrorCount bigint,
	violationEffectRowCount bigint,
	PRIMARY KEY(id)
);



CREATE TABLE IF NOT EXISTS druid_wall_sql(
	id SERIAL8 NOT NULL , 
	domain varchar(45)  NOT NULL, 
	app varchar(45)  NOT NULL, 
	cluster varchar(45)  NOT NULL, 
	host varchar(128), pid integer  NOT NULL,
	collectTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	sqlHash bigint,
	sqlSHash bigint,
	sqlSampleHash bigint,
	executeCount bigint,
	fetchRowCount bigint,
	updateCount bigint,
	syntaxError INTEGER,
	violationMessage varchar(256), 
	PRIMARY KEY(id)
);



CREATE TABLE IF NOT EXISTS druid_wall_table(
	id SERIAL8 NOT NULL , 
	domain varchar(45)  NOT NULL, 
	app varchar(45)  NOT NULL, 
	cluster varchar(45)  NOT NULL, 
	host varchar(128), 
	pid integer  NOT NULL,
	collectTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	name varchar(256), 
	selectCount bigint,
	selectIntoCount bigint,
	insertCount bigint,
	updateCount bigint,
	deleteCount bigint,
	truncateCount bigint,
	createCount bigint,
	alterCount bigint,
	dropCount bigint,
	replaceCount bigint,
	deleteDataCount bigint,
	updateDataCount bigint,
	insertDataCount bigint,
	fetchRowCount bigint,
	PRIMARY KEY(id)
);



CREATE TABLE IF NOT EXISTS druid_wall_function(
	id SERIAL8 NOT NULL , 
	domain varchar(45)  NOT NULL, 
	app varchar(45)  NOT NULL, 
	cluster varchar(45)  NOT NULL, 
	host varchar(128), 
	pid integer  NOT NULL,
	collectTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	name varchar(256), 
	invokeCount bigint,
	PRIMARY KEY(id)
);



CREATE TABLE IF NOT EXISTS druid_webapp (
	id SERIAL8 NOT NULL, 
	domain varchar(45) NOT NULL, 
	app varchar(45) NOT NULL, 
	cluster varchar(45) NOT NULL, 
	host varchar(128), 
	pid integer NOT NULL,
	collectTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	contextPath varchar(256), 
	runningCount integer,
	concurrentMax integer,
	requestCount bigint,
	sessionCount bigint,
	jdbcFetchRowCount bigint,
	jdbcUpdateCount bigint,
	jdbcExecuteCount bigint,
	jdbcExecuteTimeNano bigint,
	jdbcCommitCount bigint,
	jdbcRollbackCount bigint,
	osMacOSXCount bigint,
	osWindowsCount bigint,
	osLinuxCount bigint,
	osSymbianCount bigint,
	osFreeBSDCount bigint,
	osOpenBSDCount bigint,
	osAndroidCount bigint,
	osWindows98Count bigint,
	osWindowsXPCount bigint,
	osWindows2000Count bigint,
	osWindowsVistaCount bigint,
	osWindows7Count bigint,
	osWindows8Count bigint,
	osAndroid15Count bigint,
	osAndroid16Count bigint,
	osAndroid20Count bigint,
	osAndroid21Count bigint,
	osAndroid22Count bigint,
	osAndroid23Count bigint,
	osAndroid30Count bigint,
	osAndroid31Count bigint,
	osAndroid32Count bigint,
	osAndroid40Count bigint,
	osAndroid41Count bigint,
	osAndroid42Count bigint,
	osAndroid43Count bigint,
	osLinuxUbuntuCount bigint,
	browserIECount bigint,
	browserFirefoxCount bigint,
	browserChromeCount bigint,
	browserSafariCount bigint,
	browserOperaCount bigint,
	browserIE5Count bigint,
	browserIE6Count bigint,
	browserIE7Count bigint,
	browserIE8Count bigint,
	browserIE9Count bigint,
	browserIE10Count bigint,
	browser360SECount bigint,
	deviceAndroidCount bigint,
	deviceIpadCount bigint,
	deviceIphoneCount bigint,
	deviceWindowsPhoneCount bigint,
	botCount bigint,
	botBaiduCount bigint,
	botYoudaoCount bigint,
	botGoogleCount bigint,
	botMsnCount bigint,
	botBingCount bigint,
	botSosoCount bigint,
	botSogouCount bigint,
	botYahooCount bigint,
	PRIMARY KEY (id)
);




CREATE TABLE IF NOT EXISTS druid_weburi (
	id SERIAL8 NOT NULL, 
	domain varchar(45) NOT NULL, 
	app varchar(45) NOT NULL, 
	cluster varchar(45) NOT NULL, 
	host varchar(128), 
	pid integer NOT NULL,
	collectTime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	uri varchar(256), 
	runningCount integer,
	concurrentMax integer,
	requestCount bigint,
	requestTimeNano bigint,
	jdbcFetchRowCount bigint,
	jdbcFetchRowPeak bigint,
	jdbcUpdateCount bigint,
	jdbcUpdatePeak bigint,
	jdbcExecuteCount bigint,
	jdbcExecuteErrorCount bigint,
	jdbcExecutePeak bigint,
	jdbcExecuteTimeNano bigint,
	jdbcCommitCount bigint,
	jdbcRollbackCount bigint,
	jdbcPoolConnectionOpenCount bigint,
	jdbcPoolConnectionCloseCount bigint,
	jdbcResultSetOpenCount bigint,
	jdbcResultSetCloseCount bigint,
	errorCount bigint,
	lastAccessTime TIMESTAMP(6) WITHOUT TIME ZONE,
	h1 bigint,
	h10 bigint,
	h100 bigint,
	h1000 bigint,
	h10000 integer,
	h100000 integer,
	h1000000 integer,
	hmore integer,
	PRIMARY KEY (id)
);




select redo_sqls($$
  CREATE UNIQUE INDEX uq_druid_domain ON druid_domain (domain);
  CREATE UNIQUE INDEX uq_druid_app ON druid_app (domain, app);
	CREATE UNIQUE INDEX uq_druid_cluster ON druid_cluster (domain, app, cluster);
	CREATE UNIQUE INDEX uq_druid_inst ON druid_inst (domain, app, cluster, host);
	CREATE UNIQUE INDEX uq_druid_const ON druid_const (domain, app, type, hash);

	CREATE INDEX idx_druid_datasource ON druid_datasource (collectTime, domain, app);
	CREATE INDEX idx_druid_springmethod ON druid_springmethod (collectTime, domain, app);
	CREATE INDEX idx_druid_sql ON druid_sql (collectTime, domain, app);
	CREATE INDEX idx_druid_wall ON druid_wall (collectTime, domain, app);
	CREATE INDEX idx_druid_wall_sql ON druid_wall_sql (collectTime, domain, app);
	CREATE INDEX idx_druid_wall_table ON druid_wall_table (collectTime, domain, app);
	CREATE INDEX idx_druid_wall_function ON druid_wall_function (collectTime, domain, app);
	CREATE INDEX idx_druid_webapp ON druid_webapp (collectTime, domain, app);
	CREATE INDEX idx_druid_weburi ON druid_weburi (collectTime, domain, app);
$$);

insert into druid_domain (domain) SELECT 'default' where not exists(select id from druid_domain where domain = 'default');
insert into druid_app (domain, app) SELECT 'default', 'default' where not exists(select id from druid_app where domain = 'default' and app = 'default');
insert into druid_cluster (domain, app, cluster) SELECT 'default', 'default', 'default' where not exists(select id from druid_cluster where domain = 'default' and app = 'default' and cluster= 'default');