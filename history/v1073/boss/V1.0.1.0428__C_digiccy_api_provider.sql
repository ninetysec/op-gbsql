-- auto gen by cherry 2017-10-17 17:21:53
CREATE TABLE IF not EXISTS digiccy_api_provider(
id serial4 not null PRIMARY key,
code varchar(16),
public_url varchar(128),
private_url varchar(128),
provider_class varchar(256)
);
COMMENT on TABLE digiccy_api_provider is '数字货币接口';
COMMENT on COLUMN digiccy_api_provider.id is '主键';
COMMENT on COLUMN digiccy_api_provider.code is '数字货币接口唯一标志';
COMMENT on COLUMN digiccy_api_provider.public_url is '数字货币公共接口url';
COMMENT on COLUMN digiccy_api_provider.private_url is '数字货币私有接口url';
COMMENT on COLUMN digiccy_api_provider.provider_class is '数字货币class类';


UPDATE task_schedule SET job_method_arg='["site_job_102","site_job_108","site_job_109"]'
WHERE job_code='site-job-transfer';