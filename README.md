## 一、需求

生产上有40多个微服务部署的应用，每个应用都会产生日志，随着时间的增长，日志量不断增大，现需要清理。有两个重要的应用日志需保留90天，其它应用保留20天。

## 二、模拟产生日志文件

```bash
[root@ansible-awx ~]# more file_create.sh 
#/bin/bash
for k in {1..10}
do
  mkdir -p /tmp/file_log/log_dir"$k"
  for i in {03..06}
  do
    for j in {01..30}
    do 
      touch -mt 2020"$i""$j"0000 /tmp/file_log/log_dir"$k"/file_log_2020-"$i"-"$j".log
    done
  done
done
```

在/tmp/file_log目录新建log_dir1--log_dir10共10个目录，每个目录下生成3月到6月的日志文件；日志的创建时间和文件名时间后缀相同。

![image-20200717175029076](https://i.loli.net/2020/07/17/yBFeHcM31YDxCGr.png)

文件生成时间模拟生产日志文件时间。

## 三、清理脚本

```bash
#!/bin/bash

Days1=20
Days2=90

log_directory1=/tmp/file_log
log_directory2=/tmp/file_log/log_dir1
log_directory3=/tmp/file_log/log_dir2



#删除除log_dir1和log_dir2的日志，保留期限为Days1
find $log_directory1 \( -path $log_directory2 -o -path $log_directory3 \)  -prune -o -type f -mtime +$Days1  -exec rm {} \;


#删除log_dir1和log_dir2的日志，保留期限为Days2
find $log_directory2 -type f -mtime +$Days2 -exec rm {} \;
find $log_directory3 -type f -mtime +$Days2 -exec rm {} \;
```

清理脚本原理：使用find查找指定目录($log_directory)下所有日志文件(-type f)，有时会去除不需要的目录"\\( -path \$log_directory2 -o -path \$log_directory3 \\)"，再按照文件生成日期和时间参数(-mtime \$Day)来清除(exec rm {} \\)     

![image-20200717175539948](https://i.loli.net/2020/07/17/gQdO67C2F8D5YkT.png)

清理脚本执行前每个日志目录log_dir有121个日志文件，执行完清理脚本后对应的减少。

## 四、定时任务

将脚本部署为定时任务，每天零点定时执行：

```bash
[root@ansible-awx ~]# crontab -l
0 0 * * * /root/file_cleanup.sh >/dev/null 2>&1
```

