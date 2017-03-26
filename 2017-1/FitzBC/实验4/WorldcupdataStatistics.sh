#!/bin/bash
YEARS=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv) 
all=0
vallt20=0
val20to30=0
valgt30=0
oldest=0
oldestname=''
youngest=200
youngestnamee=''
for line in $YEARS
do
    if [[ $line != 'Age' ]]
    then
		all=$[$all + 1]
		if [[ $line -lt 20 ]]
		then
			vallt20=$[$vallt20 + 1]		
		fi
		if [[ $line -ge 20 && $line -le 30 ]]
		then
			val20to30=$[$val20to30 + 1]
		fi	
		if [[ $line -gt 30 ]]
		then
			valgt30=$[$valgt30 + 1]
		fi
		if [[ $line -gt $oldest ]]
		then
			oldest=$line
			oldestname=$(awk -F '\t' 'NR=='$[$all +1]' {print $9}' worldcupplayerinfo.tsv)
		fi
		if [[ $line -lt $youngest ]]
		then
			youngest=$line
			youngestname=$(awk -F '\t' 'NR=='$[$all +1]' {print $9}' worldcupplayerinfo.tsv)
		fi
	fi	
done
echo '20岁以下的人数为：'$vallt20' 所占比例为：'$(awk 'BEGIN{printf "%.2f",'$vallt20*100/$all'}')'%'
echo '20岁到30岁的人数为：'$val20to30' 所占比例为：'$(awk 'BEGIN{printf "%.2f",'$val20to30*100/$all'}')'%'
echo '30岁以上的人数为：'$valgt30' 所占比例为：'$(awk 'BEGIN{printf "%.2f",'$valgt30*100/$all'}')'%'
echo ''
echo '年龄最大的球员是：'$oldestname' '$oldest'岁'
echo '年龄最小的球员是：'$youngestname' '$youngest'岁'
echo ''
POSITIONS=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv) 
declare -A dic
for line in $POSITIONS
do
	if [[ $line != 'Position' ]]
	then
		if [[ !${dic[$line]} ]]
		then	
			dic[$line]=$[${dic[$line]}+1]
		else
			dic[$line]=0
		fi
	fi	
done
for key in ${!dic[@]}
do
    echo "$key : ${dic[$key]}"" 所占比例为："$(awk 'BEGIN{printf "%.2f",'${dic[$key]}*100/$all'}')'%'
done
NAMELENGTHS=$( awk -F '\t' '{print length($9)}' worldcupplayerinfo.tsv)
maxlength=0
minlength=200
longestname=''
shortestname=''
COUNT=0
for length in $NAMELENGTHS
do
	COUNT=$[$COUNT + 1]	
	if [[  $length -gt $maxlength ]]
	then
		maxlength=$length
		longestname=$(sed -n $COUNT'p' 'worldcupplayerinfo.tsv'|awk -F '\t' '{print $9}')
	fi		
	if [[ $length -lt $minlength ]]
	then
		minlength=$length	
		shortestname=$(sed -n $COUNT'p' 'worldcupplayerinfo.tsv'|awk -F '\t' '{print $9}')
	fi
done 
echo ''
echo '名字最长的球员是：'$longestname
echo '名字最短的球员是：'$shortestname
