#!/bin/bash

sqlName=$1
#手工版本号
#version=0001
#远程版本号
version=`curl http://dev:8000/SqlVersion/master.version`
prefix='V1.0.1.'
author=`whoami`
sqlFile=${prefix}${version}__${sqlName}.sql
touch $sqlFile
now=`date -d today +"%Y-%m-%d %H:%M:%S"`
echo '-- auto gen by '$author $now> $sqlFile
