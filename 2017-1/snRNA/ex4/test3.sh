#!/bin/bash
url="/"
host_top()
{
echo -e "统计访问来源主机TOP 100和分别对应出现的总次数 \n"
more +2 log/web_log.tsv | awk -F\\t '{print $1}' |  sort | uniq -c | sort -nr | head -n 10
exit 0
}

ip_top()
{
echo -e  "统计访问来源主机TOP 100 IP和分别对应出现的总次数 \n"
more +2 log/web_log.tsv | awk -F\\t '{print $1}' | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sort | uniq -c | sort -nr | head -n 100
exit 0
}

frequency_url_top()
{
#统计最频繁被访问的URL TOP 100
echo -e "统计最频繁被访问的URL TOP 100 \n"
more +2 log/web_log.tsv |awk -F\\t '{print $5}'|sort|uniq -c |sort -n -k 1 -r|head -n 10 
exit 0
} 



responsecode_stat()
{
#统计不同响应状态码的出现次数和对应百分比
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

exit 0
}

responsecode_top()
{
#4xxURL状态码对应的TOP 10 URL和对应出现的总次数
echo -e "4xxURL状态码对应的TOP 10 URL和对应出现的总次数 \n"
echo "Responsecode: 404:"
more +2 log/web_log.tsv |awk -F\\t '{print $6,$5}' | grep '404 ' | sort|uniq -c |sort -n -k 1 -r|head -n 10

echo "Responsecode: 403:"
more +2 log/web_log.tsv |awk -F\\t '{print $6,$5}' | grep '403 ' | sort|uniq -c |sort -n -k 1 -r|head -n 10

exit 0
}

url_host()
{
url=$1
url="	"$url"	"
echo -e "给定URL输出TOP 100访问来源主机 \n"
temp="more +2 log/web_log.tsv |grep \""'${url}'"\"|awk -F'\t' '{print "'$1'"}'|sort|uniq -c|sort -nr|head -n 10"
echo $temp

eval -- $temp
exit 0
}

useage()
{
	echo "Usage: bash test3.sh [OPTION]"

	echo "-a				show TOP 100 host and count"
	echo "-b 				show TOP 100 IP and count"
	echo "-c 				show TOP 100 frequency url and count"
	echo "-d 				show responsecode and count and porprotion"
	echo "-e 				show TOP 10 4XX responsecode  url and count"
	echo "-f [url]			show TOP 100 given url of host and count"	
	exit 0
}


option=`getopt -o a,b,c,d,e,f: --long help --"$@"`

eval set -- "$option"

while true; do
	case "$1" in 
		-a) host_top ;shift ; break;;
        -b) ip_top ; shift ; break;;
		-c) frequency_url_top ; shift ; break;;
		-d) responsecode_stat ; shift ; break;;
		-e) responsecode_top ; shift ; break;;
		-f) url=$2; shift ; break ;;
     	--help) useage ; shift ; break ;;
        --)shift; break ;;
 		*) echo "Internal error! see --help for more information"; exit 1 ;;
	esac
done 