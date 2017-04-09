#!bin//bash

#hjj@hjj-VirtualBox:~/shellcode$ sudo bash shellcode2.sh
#脚本输出结果 已实现所有功能
#Mission 1:
#There are 9 players under 20 years old, which take 1.223%
#There are 600 players between 20 years and 30 years old, which take 81.522%
#There are 127 players over 30 years old, which take 17.255%
#Mission 2:
#The oldest player is Faryd Mondragon and he is 42 years old
#The youngest player is Fabrice Olinga Luke Shaw and he is 18 years old
#Mission 3:
#There are 96 Goalies, which take 13.043%
#There are 237 Defender, which take 32.201%
#There are 268 Midfielder, which take 36.413%
#There are 135 Forward, which take 18.342%
#Mission 4:
#The shortest player'name is Jô and the length of the name is 3
#The longest player'name is Francisco Javier Rodriguez
#Lazaros Christodoulopoulos
#Liassine Cadamuro-Bentaeba and the length of the name is 26（此项输出包含三个结果）


function Statistics_age()
{
age=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)
sum=0
down20=0
bt20_30=0
up30=0
 for N in $age
 do
    if [ $N != 'Age' ];
    then
      sum=$[$sum+1]
      if [ $N -lt 20 ];
      then
        down20=$[$down20+1]
      fi
      if [ $N -ge 20 ] && [ $N -le 30 ];
      then
        bt20_30=$[$bt20_30+1]
      fi
      if [ $N -gt 30 ];
      then
        up30=$[$up30+1]
      fi
    fi
 done
aver1=$(awk 'BEGIN{printf "%.3f",'$down20*100/$sum'}')
aver2=$(awk 'BEGIN{printf "%.3f",'$bt20_30*100/$sum'}')
aver3=$(awk 'BEGIN{printf "%.3f",'$up30*100/$sum'}')

echo "There are "$down20 "players under 20 years old, which take $aver1%"
echo "There are "$bt20_30 "players between 20 years and 30 years old, which take $aver2%"
echo "There are "$up30 "players over 30 years old, which take $aver3%"     


}

function Findest()
{
age=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)
name=$(awk -F '\t' '{print $9}' worldcupplayerinfo.tsv)

oldest=0
youngest=1000
for N in $age
do
    if [ $N != 'Age' ];
    then
      if [ $N -gt $oldest ];
      then
        oldest=$N
      fi
      if [ $N -lt $youngest ];
      then
        youngest=$N
      fi

    fi

done

echo "The oldest player is "$(awk -F '\t' '{if ($6~/'$oldest'/) {print $9} }' worldcupplayerinfo.tsv) "and he is "$oldest "years old"
echo "The youngest player is "$(awk -F '\t' '{if ($6~/'$youngest'/) {print $9} }' worldcupplayerinfo.tsv) "and he is "$youngest "years old"

}

function Position_Sta()
{
position=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv)
Goalie=0
Defender=0
Midfielder=0
Forward=0
for M in $position
 do 
   if [ $M == 'Goalie' ];
   then
      Goalie=$[$Goalie+1]
   fi
   if [ $M == 'Defender' -o $M == 'Défenseur' ] ;
   then
      Defender=$[$Defender+1]
   fi
   if [ $M == 'Midfielder' ];
   then
      Midfielder=$[$Midfielder+1]
   fi
   if [ $M == 'Forward' ];
   then
      Forward=$[$Forward+1]
   fi
 
 
 done 
aver1=$(awk 'BEGIN{printf "%.3f",'$Goalie*100/$sum'}')
aver2=$(awk 'BEGIN{printf "%.3f",'$Defender*100/$sum'}')
aver3=$(awk 'BEGIN{printf "%.3f",'$Midfielder*100/$sum'}')
aver4=$(awk 'BEGIN{printf "%.3f",'$Forward*100/$sum'}')


echo "There are "$Goalie" Goalies, which take $aver1%"
echo "There are "$Defender" Defender, which take $aver2%"
echo "There are "$Midfielder" Midfielder, which take $aver3%"
echo "There are "$Forward" Forward, which take $aver4%"


}

function Findname()
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
echo 'Mission 1:'
Statistics_age
echo 'Mission 2:'
Findest
echo 'Mission 3:'
Position_Sta
echo 'Mission 4:'
Findname
