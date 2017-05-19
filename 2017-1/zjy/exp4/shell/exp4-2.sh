#!/bin/bash
function age_analy
{
	age=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)
	sum=0
	down_20=0
	bw_20_30=0
	up_30=0
	oldest=0
	oldestname=''
	youngest=200
	youngestname=''
	for n in $age
	do
	    if [ "$n" != 'Age' ] ; then
      		sum=$[$sum+1]

		if [ "$n" -lt 20 ] ; then 
                down_20=$[$down_20+1]		
		fi

      		if [ "$n" -ge 20 ] && [ "$n" -le 30 ] ; then 
		bw_20_30=$[$bw_20_30+1]  
		fi

      		if [ "$n" -gt 30 ] ; then 
		up_30=$[$up_30+1]  
		fi
		if [[ $n -gt $oldest ]]
		then
			oldest=$n
			oldestname=$(awk -F '\t' 'NR=='$[$sum +1]' {print $9}' worldcupplayerinfo.tsv)
		fi
		if [[ $n -lt $youngest ]]
		then
			youngest=$n
			youngestname=$(awk -F '\t' 'NR=='$[$sum +1]' {print $9}' worldcupplayerinfo.tsv)
		fi	
            fi
	done

	r1=$(awk 'BEGIN{printf "%.3f",'"$down_20"*100/"$sum"'}')
	r2=$(awk 'BEGIN{printf "%.3f",'"$bw_20_30"*100/"$sum"'}')
	r3=$(awk 'BEGIN{printf "%.3f",'"$up_30"*100/"$sum"'}')

	echo "--                   Age Analysis                     --"
	echo "--------------------------------------------------------"
	echo "|    Age     |    < 20    |    20 ~ 30    |    > 30    |"
	echo "|Total Number|     "$down_20"    |      "$bw_20_30"      |    "$up_30"     |"
	echo "|   ratio    |   "$r1" "%"  |  "$r2" "%"   |  "$r3" "%"  |"
	echo "|   oldest   |         "$oldestname"                    |"
	echo "|  youngest  |        "$youngestname"                  |"
}


function position_analy
{	
	num=$(sed -n '2, $ p' worldcupplayerinfo.tsv|awk -F '\t' '{print $5}'|sort -r|uniq -c|awk '{print $1}')
	position=$(sed -n '2, $ p' worldcupplayerinfo.tsv|awk -F '\t' '{print $5}'|sort -r|uniq -c|awk '{print $2}')
	n=($num)
	p=($position)
	sum=0
	
	for i in $num
	do
	sum=$[$sum+1]
	done

	i=0

	for n in ${num[@]}
	do
	    b["$i"]=$(echo "scale=3; *$n / $sum "|bc)

 	    i=$((i+1))
	done
	



	i=0
	p=($position)
	n=($num)
	
	for k in $(seq 0 $(echo "${#n[@]}-1"|bc))
	do
	    echo "Position: ${p[$i]}"
	    echo "Number: ${n[$i]} "
	    echo "Proportion: ${b[$i]} %"
	    let i+=1
	done
}

function name_analy
{

	longest=0
	shortest=100
	namelength=$( awk -F '\t' '{print length($9)}' worldcupplayerinfo.tsv)
 	for L in $namelength
 	do 
       		if [ $L -gt $longest ];
     		 then
        	longest=$L
      		fi
      		if [ $L -lt $shortest ];
     		 then
        	shortest=$L
     		 fi
 	done
	echo "The shortest player'name is $(awk -F '\t' '{if (length($9)=='$shortest') {print $9} }' worldcupplayerinfo.tsv
) and the length of the name is $shortest"
	echo "The longest player'name is $(awk -F '\t' '{if (length($9)=='$longest') {print $9} }' worldcupplayerinfo.tsv
) and the length of the name is $longest" 


}

while [ "$1" != "" ]; do
    case $1 in
        -age )                  age_analy
                                 exit
                                ;;
        -pos )                    position_analy
                                 exit
                                ;;
        -name )                  name_analy
                                 exit
                                ;;
esac
done

