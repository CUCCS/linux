#!/bin/bash
host_top()
{
echo -e "统计访问来源主机TOP 100和分别对应出现的总次数 \n"
more +2 log/web_log.tsv | awk -F\\t '{print $1}' |  sort | uniq -c | sort -nr | head -n 10
}

ip_top()
{
echo -e  "统计访问来源主机TOP 100 IP和分别对应出现的总次数 \n"
more +2 log/web_log.tsv | awk -F\\t '{print $1}' | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sort | uniq -c | sort -nr | head -n 100
}

frequency_url_top()
{
#统计最频繁被访问的URL TOP 100
echo -e "统计最频繁被访问的URL TOP 100 \n"
more +2 log/web_log.tsv |awk -F\\t '{print $5}'|sort|uniq -c |sort -n -k 1 -r|head -n 10 
} 



responsecode_top()
{
#4xxURL状态码对应的TOP 10 URL和对应出现的总次数
echo -e "4xxURL状态码对应的TOP 10 URL和对应出现的总次数 \n"
more +2 log/web_log.tsv |awk -F\\t '{print $6,$5}' | grep '4[0-9][0-9] ' | sort|uniq -c |sort -n -k 1 -r|head -n 10
}


url_host()
{
echo -e "给定URL输出TOP 100访问来源主机 \n"
more +2 log/web_log.tsv |grep "/ksc.html "|awk -F\\t '{print $1}'|sort|uniq -c|sort -nr|head -n 10
}

responsecode_stat()
{
a=$(more +2 log/web_log.tsv |awk -F\\t '{print $6}'|sort|uniq -c |sort -n -k 1 -r|head -n 10|awk '{print $1}')
b=$(more +2 log/web_log.tsv |awk -F\\t '{print $6}'|sort|uniq -c |sort -n -k 1 -r|head -n 10|awk '{print $2}')
sum=0
count=($a)
responsecode=($b)

for i in $a ;do
	sum=$(($sum+$i)) 
done

i=0
for n in ${count[@]};do
b[$i]=$(echo "scale=2; 100*${n} / $sum"|bc)
  i=$((i+1))
done

echo -e "------Responsecode Statistics----------  \n"
i=0
for n in ${count[@]};do
echo -e "response code: ${responsecode[$i]}  count: $n   porprotion: ${b[$i]} \n " 
i=$((i+1))
done
}
