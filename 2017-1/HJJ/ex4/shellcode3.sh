#!/bin/bash
function sourcehost
{
    sed -e '1d' web_log.tsv|awk -F '\t' '{a[$1]++} END {for(i in a) {print i,a[i]}}'|sort -nr -k2|head -n 100
}
function sourceip
{
    sed -e '1d' web_log.tsv|awk -F '\t' '{if($1~/^(([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+))$/) print $1}'|awk '{a[$1]++} END {for(i in a){print i,a[i]}}'|sort -nr -k2|head -n 100
}
function commonurl
{
    sed -e '1d' web_log.tsv | awk -F '\t' '{a[$5]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | head -n 100
}
function response
{
    sed -e '1d' web_log.tsv | awk -F '\t' '{a[$6]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | head -n 100
    sed -e '1d' web_log.tsv | awk -F '\t' '{a[$6]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | awk '{arr[$1]=$2;sums+=$2} END {for (k in arr) print k,arr[k]/sums*100,"%"}'
}
function certainurl
{
     sed -e '1d' web_log.tsv|awk -F '\t' '{if($5=="'$1'") a[$1]++} END {for(i in a){print i,a[i]}}'|sort -nr -k2|head -n 10
}
function four_xxxcode
{
     sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^403/) {a[$6":"$1]++}} END {for(i in a){print i,a[i] }}' | sort -nr -k2 | head -n 10
     sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^404/) {a[$6":"$1]++}} END {for(i in a){print i,a[i] }}' | sort -nr -k2 | head -n 10

}
function HELP
{
echo " -s)  统计访问来源主机TOP 100和分别对应出现的总次数"
echo " -i)  统计访问来源主机TOP 100 IP和分别对应出现的总次数"
echo " -c)  统计最频繁被访问的URL TOP 100"
echo " -r)  统计不同响应状态码的出现次数和对应百分比"
echo " -f)  分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
echo " -u)  给定URL输出TOP 100访问来源主机"

}
while [ "$1" != "" ]; do
    case $1 in
        -s )                    sourcehost
                                 exit
                                ;;
        -i )                    sourceip
                                 exit
                                ;;
        -c )                    commonurl
                                 exit
                                ;;
        -r )                    response
                                 exit
                                ;;
        -u )                    certainurl
                                 exit
                                ;;
        -f )                    four_xxxcode
                                 exit
                                ;;
        *  )                    HELP
                                 exit
                                ;;
    esac
done

