
#!/bin/bash
#File For Web Data Processing

function Error()
{
  echo usage: 
  echo "      $0 h : Return the top 100 hosts which sent the most requests as well as the times of requests"
  echo "      $0 p : Return the top 100 IP which sent the most requests as well as the times of requests"
  echo "      $0 u : Return the top 100 urls which require the most requests"  
  echo "      $0 c : Return the times of Response Code appears and the percentage it has"  
  echo "      $0 f : Return the top 10 urls which receive Response Code of 4** and the times of it"  
  echo "      $0 H [url] : Return the top 100 hosts which send the most requests to the given [url]"  
  exit 1
}
if [ $# > 2 ];then
  if [ $# == 1 ];then
    # Sort Hosts
    if [ $1 == "h" ];then
      sed -e '1d' web_log.tsv | awk -F '\t' '{a[$1]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | head -n 100
      
    # Sort IP
    elif [ $1 == "p" ];then
      sed -e '1d' web_log.tsv | awk -F '\t' '{a[$1]++} END {for(i in a){print i,a[i] }}' | awk '{ if($1~/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]/){print} }' | sort -nr -k2 | head -n 100

    # Sort URL
    elif [ $1 == "u" ];then
      sed -e '1d' web_log.tsv | awk -F '\t' '{a[$5]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | head -n 100

    # Sort Response
    elif [ $1 == "c" ];then
      sed -e '1d' web_log.tsv | awk -F '\t' '{a[$6]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | head -n 100
      sed -e '1d' web_log.tsv | awk -F '\t' '{a[$6]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | awk '{arr[$1]=$2;sums+=$2} END {for (k in arr) print k,arr[k]/sums*100}'

    # Sort Code 4** 
    elif [ $1 == "f" ];then
      sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^403/) {a[$6":"$1]++}} END {for(i in a){print i,a[i] }}' | sort -nr -k2 | head -n 10
      sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^404/) {a[$6":"$1]++}} END {for(i in a){print i,a[i] }}' | sort -nr -k2 | head -n 10

    else
      Error
    fi
   
  # Sort Source Hosts
  elif [ $# == 2 -a $1 == "H" ];then
    sed -e '1d' web_log.tsv | awk -F '\t' '{if($5=="'${2}'") {a[$1]++}} END {for(i in a) {print i,a[i]} }' | sort -nr -k2 | head -n 100

  else
    Error     
  fi

else
  Error
fi




#URL
# ``

