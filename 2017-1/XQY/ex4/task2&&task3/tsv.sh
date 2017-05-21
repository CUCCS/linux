#版权声明：以下代码转自https://github.com/CUCCS/linux/blob/master/2017-1/TJY/bash/tsv.sh

#!/bin/bash

# set arguement
TEMP=`getopt -o apng --long agerange,position,playername,playerage,help -n 'tsv.sh' -- "$@"`


funAgeRange()
{
# task 1:统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比

age=$(more +2 worldcupplayerinfo.tsv | awk -F\\t '{if($6<20)a+=1;else if($6>=20&&$6<=30)b+=1;else if($6>30)c+=1}END{print a,b,c}')

ageArray=($age)
for i in $age ; do
  # echo $i
  total=$(($total+$i))
done
ageGroup=("<20" "20-30" ">30")
ageProportion=()
echo -e "                 The Age Range                \n"
echo -e "range            amount             proportion"
i=0
while [ $i -le 2 ]; do  
  por=$(echo "scale=2; 100 * ${ageArray[${i}]} / $total" | bc)
  echo -e ${ageGroup[${i}]}"              "${ageArray[${i}]}"                 "$por"%"
  i=$(($i+1))
done
}

funPosition()
{
# task 2:统计不同场上位置的球员数量、百分比
position=$(more +2 worldcupplayerinfo.tsv | awk -F\\t '{print $5}' | sort | uniq -c | sort -nr | awk '{print $2}')
positionArray=($position)

amount=$(more +2 worldcupplayerinfo.tsv | awk -F\\t '{print $5}' | sort | uniq -c | sort -nr | awk '{print $1}' )
amountArray=($amount)
total=0
for i in $amount ; do
#  echo $i
  total=$(($total+$i))
done
echo -e "          The Position of Players             \n"
echo -e "positiion          amount           proportion\n"
i=0
while [ $i -lt ${#positionArray[@]} ]; do
  por=$(echo "scale=2; 100 * ${amountArray[${i}]} / $total" | bc)
  echo -e ${positionArray[${i}]}"               "${amountArray[${i}]}"                "$por"%"
  i=$(($i+1))
done
}


funPlayerName()
{
# task 3:名字最长的球员是谁？名字最短的球员是谁？

nameArgu_1=$(more +2 worldcupplayerinfo.tsv | awk -F\\t '{print $9}')
IFS=$'\n' nameArgu_1=($nameArgu_1)
maxLen=0
for i in ${nameArgu_1[*]} ; do
  count=$(echo -n $i | wc -m )
  if [ $count -gt $maxLen ] ; then
    maxLen=$count
  fi
done

num=0
maxName=()
for i in ${nameArgu_1[*]} ; do
  count=$(echo -n $i | wc -m)
  if [ $count -eq $maxLen ] ; then
    maxName[${num}]=$i
    num=$((num+1))
  fi
done



echo -e "\n             The Longest Name                \n"
echo -e "1. The length of the longest name is $maxLen\n"
echo -e "2. The longest name :\n"
for i in ${maxName[*]} ; do
  echo $i
done


nameArgu_3=$(more +2 worldcupplayerinfo.tsv | awk -F\\t '{print $9}')
IFS=$'\n' nameArgu_3=($nameArgu_3)
minLen=100
for i in ${nameArgu_3[*]} ; do
  count=$(echo -n $i | wc -m )
  if [ $count -lt $minLen ] ; then
    minLen=$count
  fi
done
num=0
minName=()
for i in ${nameArgu_3[*]} ; do
  count=$(echo -n $i | wc -m)
  if [ $count -eq $minLen ] ; then
    minName[${num}]=$i
    num=$((num+1))
  fi
done

echo -e "\n              The Shortest Name                \n"
echo -e "1. The length of the shortest name is $minLen\n"
echo -e "2. The shortest name :\n"

for i in ${minName[*]} ; do
  echo $i
done
}

funPlayerAge()
{
# task 4:年龄最大的球员是谁？年龄最小的球员是谁？
ageArgu_1=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{old=0}{if($6>old)old=$6}END{print old}')
maxAge=$ageArgu_1

ageArgu_2=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{i=0}{if($6==mAge){n[i]=$9;i+=1}}END{for(a in n)print n[a]}' mAge=$maxAge)

echo -e "\n              The Oldest Player                \n"
echo -e "1. The age of the oldest player is $maxAge\n"
echo -e "2. The oldest player:\n"

IFS=$'\n' ageArray=($ageArgu_2)
for i in ${ageArray[*]} ; do
  echo $i
done

ageArgu_3=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{young=100}{if($6<young)young=$6}END{print young}')
minAge=$ageArgu_3

ageArgu_4=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{i=0}{if($6==mAge){n[i]=$9;i+=1}}END{for(a in n)print n[a]}' mAge=$minAge)

echo -e "\n              The Youngest Player                \n"
echo -e "1. The age of the youngest player is $minAge\n"
echo -e "2. The youngest player:\n"
IFS=$'\n' ageArray=($ageArgu_4)
for i in ${ageArray[*]} ; do
  echo $i
done
}


eval set -- "$TEMP"

while true ; do
    case "$1" in
        -a|--agerange) funAgeRange ; shift ;;
        -p|--position) funPosition ; shift ;;
        -n|--playername) funPlayerName ; shift ;;
        -g|--playerage) funPlayerAge ; shift ;;
        --help) echo -e "tsv.sh supports the statistical task of 'The Athlete Data of 2014 World Cup'\n
Usage: bash tsv.sh [OPTIONS] [PARAMETER] \n
-a, --agerange          Statistics of the number of players in different age ranges (<20, [20-30], >30) and proportion\n
-p, --position          Statistics of the number of players in different positions and proportion\n
-n, --playername        Statistics of the longest and the shortest name of players\n
-g, --playerage         Statistics of the yongest and the oldest players\n
--help                  Ask for help\n"; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


