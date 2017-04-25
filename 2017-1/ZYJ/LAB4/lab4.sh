

function age()
{

age=$(awk -F '\t' '{print $}' worldcupplayerinfo.tsv)
for i in $age;
do
    if [$i != 'Age'];
    then
        if [$i -lt 20];
        then
                count20=$[$count20+1]
        fi

        if [[$i le 30] && [$i -ge 20]];
        then
                count2030=$[$count2030+1]
        fi

        if [$i -gt 30];
        then
                count30=$[$count30+1]
        fi
     fi
done
people=$[$count20+$count2030+$count30]

echo 'Total number of people:'$people' '
echo 'The number of people under 20:'$count20'     The proportion:'$(awk 'BEGIN{print "%.2f",'$count20*100/$people'}')'%'
echo 'The number of people between 20 and 30 :'$count2030'     The proportion:'$(awk 'BEGIN{print "%.2f",'$count2030*100/$people'}')'%'
echo 'The number of people over 30:'$count20'     The proportion:'$(awk 'BEGIN{print "%.2f",'$count30*100/$people'}')'%'
}


