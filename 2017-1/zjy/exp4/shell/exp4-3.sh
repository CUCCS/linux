#!/bin/bash

function usage
{

echo " 用法: bash exp4-3.sh [-sh][-si][-fr][-rc][-fc][-gu][-h]"
echo " -sh  统计访问来源主机TOP 100和分别对应出现的总次数"
echo " -si  统计访问来源主机TOP 100 IP和分别对应出现的总次数"
echo " -fr  统计最频繁被访问的URL TOP 100"
echo " -rc  统计不同响应状态码的出现次数和对应百分比"
echo " -fc  分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
echo " -gu  给定URL输出TOP 100访问来源主机"
echo " -h   使用帮助"

}

function source_host
{
    sed -e '1d' web_log.tsv|awk -F '\t' '{a[$1]++} END {for(i in a) {print i,a[i]}}'|sort -nr -k2|head -n 100
}
function source_ip
{
    sed -e '1d' web_log.tsv|awk -F '\t' '{if($1~/^(([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+))$/) print $1}'|awk '{a[$1]++} END {for(i in a){print i,a[i]}}'|sort -nr -k2|head -n 100
}
function freq_url
{
    sed -e '1d' web_log.tsv | awk -F '\t' '{a[$5]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | head -n 100
}
function res_code
{
    sed -e '1d' web_log.tsv | awk -F '\t' '{a[$6]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | head -n 100
    sed -e '1d' web_log.tsv | awk -F '\t' '{a[$6]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | awk '{arr[$1]=$2;sums+=$2} END {for (k in arr) print k,arr[k]/sums*100,"%"}'
}
function given_url
{
     sed -e '1d' web_log.tsv|awk -F '\t' '{if($5=="'$1'") a[$1]++} END {for(i in a){print i,a[i]}}'|sort -nr -k2|head -n 10
}
function four_code
{
     sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^403/) {a[$6":"$1]++}} END {for(i in a){print i,a[i] }}' | sort -nr -k2 | head -n 10
     sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^404/) {a[$6":"$1]++}} END {for(i in a){print i,a[i] }}' | sort -nr -k2 | head -n 10

}

while [ "$1" != "" ]; do
    case $1 in
        -sh )                    source_host
                                 exit
                                ;;
        -si )                    source_ip
                                 exit
                                ;;
        -fr )                    freq_url
                                 exit
                                ;;
        -rc  )                    res_code
                                 exit
                                ;;
        -fc )                    four_code
                                 exit
                                ;;
	-gu )                    given_url
                                 exit
                                ;;
        -h )                     usage
                                 exit
                                ;;
    esac
done
