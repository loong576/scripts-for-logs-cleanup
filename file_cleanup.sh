#!/bin/bash

Days1=20
Days2=90

log_directory1=/tmp/file_log
log_directory2=/tmp/file_log/log_dir1
log_directory3=/tmp/file_log/log_dir2



#删除除log_dir1(不包含log_directory2和log_directory3)，保留期限为Days1
find $log_directory1 \( -path $log_directory2 -o -path $log_directory3 \)  -prune -o -type f -mtime +$Days1  -exec rm {} \;


#删除log_dir2和log_dir3的日志，保留期限为Days2
find $log_directory2 -type f -mtime +$Days2 -exec rm {} \;
find $log_directory3 -type f -mtime +$Days2 -exec rm {} \;
