#!/bin/bash
function usage
{
    echo "usage: WebProcessing.sh [-sh][-si][-sc][-u][-uh][-fs][-h]"
    echo ""
    echo "optional arguments:"
    echo "  -sh             统计访问来源主机TOP 100和分别对应出现的总次数"
    echo "  -si             统计访问来源主机TOP 100 IP和分别对应出现的总次数"
    echo "  -sc             统计不同响应状态码的出现次数和对应百分比"
    echo "  -u              统计最频繁被访问的URL TOP 100"
    echo "  -uh <url>       给定URL输出TOP 100访问来源主机"
    echo "  -fs             分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    echo "  -h,  --help"
}
function check4xxstatuscode
{
    a=$(sed -e '1d' 'web_log.tsv'|awk -F '\t' '{if($6~/^4+/) a[$6]++} END {for(i in a) print i}')
    for i in $a
    do
        (sed -e '1d' web_log.tsv|awk -F '\t' '{if($6~/^'$i'/) a[$6][$5]++} END {for(i in a){for(j in a[i]){print i,j,a[i][j]}}}'|sort -nr -k3|head -n 10)
    done
}
function sourcehost
{
    (sed -e '1d' web_log.tsv|awk -F '\t' '{a[$1]++} END {for(i in a) {print i,a[i]}}'|sort -nr -k2|head -n 100)
}
function sourceip
{
    (sed  sed -e '1d' web_log.tsv|awk -F '\t' '{if($1~/^(([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+))$/) print $1}'|awk '{a[$1]++} END {for(i in a){print i,a[i]}}'|sort -nr -k2|head -n 100)
}
function usualurl
{
    (sed -e '1d' web_log.tsv|awk -F '\t' '{a[$6]++} END {for(i in a) {printf("%d 数量为：%d\n",i,a[i])}}' |sort -nr -k2|head -n 100)
}
function statuscode
{
    (sed -e '1d' web_log.tsv|awk -F '\t' '{a[$6]++;c[1]++} END {for(i in a) {printf("%d 数量为：%-10d 所占比例为：%.2f%\n",i,a[i],a[i]*100/c[1])}}'|sort -nr -k2|head -n 100)
}
function urltohost
{
    (sed -e '1d' web_log.tsv|awk -F '\t' '{if($5=="'$1'") a[$1]++} END {for(i in a){print i,a[i]}}'|sort -nr -k2|head -n 10)
}

if [ $# == 0 ];
then
    usage
fi
while [ "$1" != "" ]; do
    case $1 in
        -sh )                   ifsourcehost=1
                                ;;
        -si )                   ifsourceip=1
                                ;;
        -u )                    ifusualurl=1
                                ;;
        -sc )                   ifstatuscode=1
                                ;;
        -uh )                   ifurltohost=1
                                shift
                                if [[ $1 != -* && $1 ]]
                                then
                                    url=$1
                                else
                                    echo "Warnning: There need a argument after -uh"
                                    exit
                                fi
                                ;;
        -fs )                   iffourtostatuscode=1
                                ;;
        h | --help )            usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
if [[ $ifsourcehost ]]
then
    sourcehost
fi
if [[ $ifsourceip ]]
then
    sourceip
fi
if [[ $ifusualurl ]]
then
    usualurl
fi
if [[ $ifstatuscode ]]
then
    statuscode
fi
if [[ $ifurltohost && $url ]]
then
    urltohost $url
fi
if [[ $iffourtostatuscode ]]
then
     check4xxstatuscode
fi
