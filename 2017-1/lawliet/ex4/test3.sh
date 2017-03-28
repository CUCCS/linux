#!/bin/bash

URL="/"

# set arguement
TEMP=`getopt -o abcdef: --long sourcehost,sourceip,frenquencyurl,responcecode,errorcode,specifiedurl:,help -n 'test3.sh' -- "$@"`
eval set -- "$TEMP"

Source_Host()
{
  more +2 web_log.tsv | awk -F\\t '{print $1}' |  sort | uniq -c | sort -nr | head -n 100
  exit 0
}

Source_HostIP()
{
  more +2 web_log.tsv | awk -F\\t '{print $1}' | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sort | uniq -c | sort -nr | head -n 100
  exit 0
}

Frequency_Url()
{
  more +2 web_log.tsv |awk -F\\t '{print $5}'|sort | uniq -c |sort -nr | head -n 100
  exit 0
}


Responce_Code()
{
  argu_4_code=$(more +2 web_log.tsv |awk -F\\t '{print $6}'| sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}')
  argu_4_times=$(more +2 web_log.tsv |awk -F\\t '{print $6}'| sort | uniq -c |sort -nr | head -n 10 | awk '{print $1}')
  codeArray=($argu_4_code)
  timesArray=($argu_4_times)
  for i in $argu_4_times ; do
    total=$(($total+$i))
  done
  echo -e "Responce code:\n"
  i=0
  while [ $i -lt ${#codeArray[@]} ]; do
    por=$(echo "scale=2; 100 * ${timesArray[${i}]} / $total" | bc)
    echo -e "code:"${codeArray[${i}]}"   times: "${timesArray[${i}]}"    proportion "$por"%"
    i=$(($i+1))
  done
  exit 0
}

Responce_CodeErr()
{

  echo -e "404 responce code:"
  more +2 web_log.tsv |awk -F\\t '{print $6,$5}' | grep '404 ' | sort | uniq -c |sort -nr|head -n 10

  echo -e "403 responce code:"
  more +2 web_log.tsv |awk -F\\t '{print $6,$5}' | grep '403 ' | sort | uniq -c |sort -nr|head -n 10
  exit 0
}

Specified_Url()
{
  url=""$URL""
  temp="more +2 web_log.tsv |grep \""'${url}'"\"|awk -F'\t' '{print "'$1'"}'|sort|uniq -c|sort -nr|head -n 100"
  eval -- $temp
  exit 0
}



while true ; do
    case "$1" in
        -a|--sourcehost) Source_Host ; shift ;;
        -b|--sourceip) Source_HostIP ; shift ;;
        -c|--frenquencyurl) Frequency_Url ; shift ;;
        -d|--responcecode) Responce_Code ; shift ;;
        -e|--errorcode) Responce_CodeErr ; shift ;;
        -f|--specifiedurl) URL=$2 ; Specified_Url ; shift 2;;
        --help) echo -e "test3.sh supports the statistical task of 'The  Data of web_log'\n
Usage: bash test3.sh [OPTIONS] [PARAMETER] \n
-a, --sourcehost           Statistics of the access to the source host TOP 100 and the corresponding total number of occurrences\n
-b, --sourceip             Statistics of the access to the source host TOP 100 IP and the corresponding total number of occurrences\n
-c, --frenquencyurl        Statistics of the TOP 100 Url which is frequently accessed\n
-d, --responcecode         Statistics of the number of occurrences of the response codes and the corresponding percentages\n
-e, --errorcode            Statistics of the number of occurrences of the response codes liked 4xx and the corresponding percentages\n
-f, --specifiedurl[=URL]   Statistics of the TOP 100 source host with specified URL\n
--help                     Ask for help\n"; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

