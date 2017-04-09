#!/bin/bash

age_stat()
{
a=$(more +2 log/worldcupplayerinfo.tsv|awk -F\\t '{print $6}'|sort -r|awk 'BEGIN{split("<20 20-30 >30",b)}{if($1<20)a[1]++;if($1>=20&&$1<=30)a[2]++;if($1>30)a[3]++}END{for(i in a)print a[i]}')

sum=0
age=($a)

for i in $a ;do
   sum=$(($sum+$i)) 
done

a=("<20" "20-30" ">30")
for i in `seq 0 2`;do
b[$i]=$(echo "scale=2; 100*${age[$i]} / $sum"|bc)

done

echo -e "------Age Statistics----------  \n"
for i in `seq 0 2`;do
echo -e "${a[$i]}  count: ${age[$i]} porprotion: ${b[$i]} \n "
done
}

position_stat()
{
	a=$(more +2 log/worldcupplayerinfo.tsv|awk -F\\t '{print $5}'|sort -r|uniq -c|awk '{print $1}')
	b=$(more +2 log/worldcupplayerinfo.tsv|awk -F\\t '{print $5}'|sort -r|uniq -c|awk '{print $2}')
	sum=0
	count=($a)
	position=($b)

	for i in $a ;do
		sum=$(($sum+$i)) 
	done

i=0
for n in ${count[@]};do
b[$i]=$(echo "scale=2; 100*${n} / $sum"|bc)
  i=$((i+1))
done

echo -e "------Position Statistics----------  \n"
i=0
for n in ${count[@]};do
echo -e "position: ${position[$i]}  count: $n   porprotion: ${b[$i]} \n " 
i=$((i+1))
done
}

young_stat()
{
young=$(more +2 log/worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{young=100}{if($6<=young){young=$6}}END{print young}')

temp="more +2 log/worldcupplayerinfo.tsv | awk -F'\t' 'BEGIN{young="${young}";i=1}{if("'$6'"==young){name[i]="'$9'";i++}}END{for (a in name)print name[a]}'"

#$($temp)
#echo $temp
name=$(eval -- $temp)

echo -e "------Youngest Statistics----------  \n"

echo -e "yougest age : ${young} "
echo -e "name : \n"

IFS=$'\n' namearray=($name)
for key in "${!namearray[@]}"; do echo "${namearray[$key]}"; done


}

old_stat()
{
old=$(more +2 log/worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{old=0}{if($6>=old){old=$6}}END{print old}')

temp="more +2 log/worldcupplayerinfo.tsv | awk -F'\t' 'BEGIN{old="${old}";i=1}{if("'$6'"==old){name[i]="'$9'";i++}}END{for (a in name)print name[a]}'"

#echo $temp
name=$(eval -- $temp)

echo -e "------Oldest Statistics----------  \n"

echo -e "oldest age : ${old} "
echo -e "name : \n"

IFS=$'\n' namearray=($name)
for key in "${!namearray[@]}"; do echo "${namearray[$key]}"; done


}

longgest_stat()
{

name=$(more +2 log/worldcupplayerinfo.tsv | awk -F\\t '{print $9}') 
long=0
IFS=$'\n' namearray=($name)

for i in ${namearray[*]} ; do
  count=$(echo -n $i | wc -m )
  if [ $count -gt $long ] ; then
    long=$count
  fi
done

num=0
longarray=()
for i in ${namearray[*]} ; do
  count=$(echo -n $i | wc -m)
  if [ $count -eq $long ] ; then
    longarray[${num}]=$i
    num=$((num+1))
  fi
done

echo -e "------Longest Name Statistics----------  \n"

echo -e "longgest name length : ${long} "
echo -e "name : \n"

for key in "${!longarray[@]}"; do echo "${longarray[$key]}"; done

}
shortest_stat()
{

name=$(more +2 log/worldcupplayerinfo.tsv | awk -F\\t '{print $9}') 
short=100
IFS=$'\n' namearray=($name)

for i in ${namearray[*]} ; do
  count=$(echo -n $i | wc -m )
  if [ $count -lt $short ] ; then
    short=$count
  fi
done

num=0
shortarray=()
for i in ${namearray[*]} ; do
  count=$(echo -n $i | wc -m)
  if [ $count -eq $short ] ; then
    shortarray[${num}]=$i
    num=$((num+1))
  fi
done

echo -e "------Shortest Name Statistics----------  \n"

echo -e "shortest name length : ${short} "
echo -e "name : \n"

for key in "${!shortarray[@]}"; do echo "${shortarray[$key]}"; done

}

age_stat
position_stat
longgest_stat
shortest_stat
young_stat
old_stat
