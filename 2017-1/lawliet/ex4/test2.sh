#!/bin/bash

TEMP=`getopt -o aplsyo --long agerange,position,Longgest_playername,Shortest_playername,Youngest_playername,Oldest_playername,help -n 'test2.sh' -- "$@"`


Age_Statistics() #年龄分段统计
{
a=$(more +2 worldcupplayerinfo.tsv|awk -F\\t '{print $6}'|sort -r|awk 'BEGIN{split("<20 20-30 >30",b)}{if($1<20)a[1]++;if($1>=20&&$1<=30)a[2]++;if($1>30)a[3]++}END{for(i in a)print a[i]}')

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

Position_Statistics() #位置统计
{
	a=$(more +2 worldcupplayerinfo.tsv|awk -F\\t '{print $5}'|sort -r|uniq -c|awk '{print $1}')
	b=$(more +2 worldcupplayerinfo.tsv|awk -F\\t '{print $5}'|sort -r|uniq -c|awk '{print $2}')
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

Longgest_Statistics()
{
long=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{max=0}{if(length($9)>max){max=length($9);}}END{print max}')

temp="more +2 worldcupplayerinfo.tsv | awk -F'\t' 'BEGIN{long="${long}";i=1}{if(length("'$9'")==long){name[i]="'$9'";i++}}END{for (a in name)print name[a]}'"
name=$(eval -- $temp)

echo -e "------Longest Name Statistics----------  \n"

echo -e "longgest name length: ${long} \n"
echo -e "name: "

IFS=$'\n' namearray=($name)
for key in "${!namearray[@]}"; do echo "${namearray[$key]}"; done

}
Shortest_Statistics()
{
short=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{short=100}{if(length($9)<short){short=length($9);}}END{print short}')

temp="more +2 worldcupplayerinfo.tsv | awk -F'\t' 'BEGIN{short="${short}";i=1}{if(length("'$9'")==short){name[i]="'$9'";i++}}END{for (a in name)print name[a]}'"
name=$(eval -- $temp)

echo -e " "
echo -e "------Shortest Name Statistics----------  \n"

echo -e "shortest name length: ${short} \n"
echo -e "name: "

IFS=$'\n' namearray=($name)
for key in "${!namearray[@]}"; do echo "${namearray[$key]}"; done

}

Young_Statistics()
{
young=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{young=100}{if($6<=young){young=$6}}END{print young}')

temp="more +2 worldcupplayerinfo.tsv | awk -F'\t' 'BEGIN{young="${young}";i=1}{if("'$6'"==young){name[i]="'$9'";i++}}END{for (a in name)print name[a]}'"

#echo $temp
name=$(eval -- $temp)

echo -e "------Youngest Statistics----------  \n"

echo -e "yougest age: ${young} \n"
echo -e "name: \n"

IFS=$'\n' namearray=($name)
for key in "${!namearray[@]}"; do echo "${namearray[$key]}"; done


}

Old_Statistics()
{
old=$(more +2 worldcupplayerinfo.tsv | awk -F\\t 'BEGIN{old=0}{if($6>=old){old=$6}}END{print old}')

temp="more +2 worldcupplayerinfo.tsv | awk -F'\t' 'BEGIN{old="${old}";i=1}{if("'$6'"==old){name[i]="'$9'";i++}}END{for (a in name)print name[a]}'"

#echo $temp
name=$(eval -- $temp)

echo -e "------Oldest Statistics----------  \n"

echo -e "oldest age: ${old} \n"
echo -e "name: \n"

IFS=$'\n' namearray=($name)
for key in "${!namearray[@]}"; do echo "${namearray[$key]}"; done


}


eval set -- "$TEMP"

while true ; do
    case "$1" in
        -a|--agerange) Age_Statistics ; shift ;;
        -p|--position) Position_Statistics ; shift ;;
        -l|--Longgest_playername)  Longgest_Statistics ; shift ;;
        -s|--Shortest_playername)  Shortest_Statistics ; shift ;;
        -y|--Youngest_playername)  Young_Statistics ; shift ;;
        -o|--Oldest_playername)    Old_Statistics ; shift ;;
        --help) echo -e "test2.sh supports the statistical task of 'The Athlete Data of 2014 World Cup'\n
Usage: bash test2.sh [OPTIONS] [PARAMETER] \n
-a, --agerange                   Statistics of the number of players in different age ranges (<20, [20-30], >30) and proportion\n
-p, --position                   Statistics of the number of players in different positions and proportion\n
-l, --Longgest_playername        Statistics of the longest name of players\n
-s, --Shortest_playername        Statistics of the Shortest name of players\n
-y, --Youngest_playername        Statistics of the Youngest name of players\n
-o, --Oldest_playername          Statistics of the Oldest name of players\n
--help                  Ask for help\n" ; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done