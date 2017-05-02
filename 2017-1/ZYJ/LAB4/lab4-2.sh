#!/bin/bash
count20=0
count2030=0
count30=0

TheLongestName=0
TheShortestName=100

people=0

oldest=0
youngest=150

goalie=0
defender=0
midfielder=0
forward=0

#----------------------------------------------------------------------
age=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)
for i in $age
 do
    if [ $i != 'Age' ];
    then
        people=$[$people+1]
	if [ $i -lt 20 ];
	then
		count20=$[$count20+1]
        fi

        if [ $i -ge 20 ]&&[ $i -le 30 ]
	then
		count2030=$[$count2030+1]
	fi

	if [ $i -gt 30 ]
	then
		count30=$[$count30+1]
	fi
    fi
 done
#people=$[$count20+$count2030+$count30]
echo 'Total number of people:'$people' ' 
echo 'The number of people under 20:'$count20'                 The proportion:'$(awk 'BEGIN{printf "%.2f",'$count20*100/$people'}')'%'
echo 'The number of people between 20 and 30:'$count2030'      The proportion:'$(awk 'BEGIN{printf "%.2f",'$count2030*100/$people'}')'%'
echo 'The number of people over 30:'$count30'                  The proportion:'$(awk 'BEGIN{printf "%.2f",'$count30*100/$people'}')'%'
#------------------------------------------------------------------------
name=$(awk -F '\t' '{print $9}' worldcupplayerinfo.tsv)
for j in $age
do
    if [ $j != 'Age' ];
    then
	if [ $j -gt $oldest ];
	then
		oldest=$j
		
 	fi

	if [ $j -lt $youngest ];
	then
		youngest=$j
	fi
fi
done
echo 'The oldest people is:'$(awk -F '\t' '{ if ($6~/'$oldest'/) {print $9}}' worldcupplayerinfo.tsv)''
echo 'The youngest people is:'$(awk -F '\t' '{if ($6~/'$youngest'/) {print $9}}' worldcupplayerinfo.tsv)''


#----------------------------------------------------------------------
length=$(awk -F '\t' '{print length($9)}' worldcupplayerinfo.tsv)
for k in $length
do
	if [ $k -gt $TheLongestName ]
 	then
		TheLongestName=$k
	fi
	if [ $k -lt $TheShortestName ]
	then
		TheShortestName=$k
	fi
done
echo 'The shortest name is:'$(awk -F '\t' '{if (length($9)=='$TheShortestName'){print $9}}' worldcupplayerinfo.tsv)''

echo 'The longest name is:'$(awk -F '\t' '{if (length($9)=='$TheLongestName'){print $9}}' worldcupplayerinfo.tsv)''

#-----------------------------------------------------------------------
position=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv)
for m in $position
do
	if [ $m == 'Goalie' ]
	then

		goalie=$[$goalie+1]
	fi
	if [ $m == 'Defender' ]
	then
		defender=$[$defender+1]
	fi
	if [ $m == 'Midfielder' ]
        then
                midfielder=$[$midfielder+1]
        fi
        if [ $m == 'Forward' ]
        then
                forward=$[$forward+1]
        fi

done
echo 'The number of Goalie is:'$golie'    The proportion:'$(awk 'BEGIN{printf "%.2f",'$goalie*100/$people'}')'%'
echo 'The number of Defender is:'$defender'    The proportion:'$(awk 'BEGIN{printf "%.2f",'$defender*100/$people'}')'%'
echo 'The number of midfielder is:'$midfielder'    The proportion:'$(awk 'BEGIN{printf "%.2f",'$midfielder*100/$people'}')'%'
echo 'The number of forward is:'$forward'    The proportion:'$(awk 'BEGIN{printf "%.2f",'$forward*100/$people'}')'%'

