-- auto gen by cherry 2017-01-08 21:09:27
UPDATE game_api_provider set jar_url= "replace"(jar_url, '/impl-jars/api-', '/impl-jars/api/api-');
UPDATE pay_api_provider set jar_url= "replace"(jar_url, '/impl-jars/pay-', '/impl-jars/pay/pay-');