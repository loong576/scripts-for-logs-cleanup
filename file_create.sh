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
