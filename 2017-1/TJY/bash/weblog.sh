#!/bin/bash

URL="/ksc.html"

# set arguement
TEMP=`getopt -o hiuces: --long sourcehost,sourceip,frenquencyurl,responcecode,errorcode,specifiedurl:,help -n 'weblog.sh' -- "$@"`
eval set -- "$TEMP"

funSourceHost()
{
  more +2 web_log.tsv | awk -F\\t '{print $1}' |  sort | uniq -c | sort -nr | head -n 100
  exit 0
}

funSourceHostIP()
{
  more +2 web_log.tsv | awk -F\\t '{print $1}' | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sort | uniq -c | sort -nr | head -n 100
  exit 0
}

funFrequencyUrl()
{
  more +2 web_log.tsv |awk -F\\t '{print $5}'|sort | uniq -c |sort -nr | head -n 100
  exit 0
}


funResponceCode()
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

funResponceCodeErr()
{
#  errorCode=$(more +2 web_log.tsv |awk -F\\t '{print $6}' | grep '4[0-9][0-9]' | sort | uniq)
#  for i in $errorCode ; do  
#    $(more +2 web_log.tsv |awk -F\\t 'BEGIN{i=0}{if($6==eCode){url[i]=$5;i+=1}}END{for (a in url) print $6,url[a]}' eCode=$i | sort -nr | uniq)
#  done
  echo -e "404 responce code:"
  more +2 web_log.tsv |awk -F\\t '{print $6,$5}' | grep '404 ' | sort | uniq -c |sort -nr|head -n 10

  echo -e "403 responce code:"
  more +2 web_log.tsv |awk -F\\t '{print $6,$5}' | grep '403 ' | sort | uniq -c |sort -nr|head -n 10
  exit 0
}

funSpecifiedUrl()
{
  url=""$URL""
  temp="more +2 web_log.tsv |grep \""'${url}'"\"|awk -F'\t' '{print "'$1'"}'|sort|uniq -c|sort -nr|head -n 100"
  eval -- $temp
  exit 0
}



while true ; do
    case "$1" in
        -h|--sourcehost) funSourceHost ; shift ;;
        -i|--sourceip) funSourceHostIP ; shift ;;
        -u|--frenquencyurl) funFrequencyUrl ; shift ;;
        -c|--responcecode) funResponceCode ; shift ;;
        -e|--errorcode) funResponceCodeErr ; shift ;;
        -s|--specifiedurl) URL=$2 ; funSpecifiedUrl ; shift 2;;
        --help) echo -e "weblog.sh supports the statistical task of 'The Athlete Data of 2014 World Cup'\n
Usage: bash weblog.sh [OPTIONS] [PARAMETER] \n
-h, --sourcehost           Statistics of the access to the source host TOP 100 and the corresponding total number of occurrences\n
-i, --sourceip             Statistics of the access to the source host TOP 100 IP and the corresponding total number of occurrences\n
-u, --frenquencyurl        Statistics of the TOP 100 Url which is frequently accessed\n
-c, --responcecode         Statistics of the number of occurrences of the response codes and the corresponding percentages\n
-e, --errorcode            Statistics of the number of occurrences of the response codes liked 4xx and the corresponding percentages\n
-s, --specifiedurl[=URL]   Statistics of the TOP 100 source host with specified URL\n
--help                     Ask for help\n"; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

