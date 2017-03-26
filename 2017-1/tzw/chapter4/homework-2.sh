#!/bin/bash
#Bash File For Image Processing

function Error()
{
  echo usage: 
  echo "      $0 r : Return the NUMBER and PERCENTAGE of players chosen by age"
  echo "      $0   ra     choice=-20 : Under 20-year-old"
  echo "      $0   rb     choice=-20-30 : Between 20 and 30 years old"  
  echo "      $0   rc     choice=+30 : Above 30-year-old"  
  echo "      $0 f : Return the NUMBER and PERCENTAGE of players chosen by position"  
  echo "      $0 -j [source(.png)] [destination(.jpg)] : switch .png/svg to .jpg"  
  exit 1
} 
if [ $# == 1 ];then

# Age<20
   if [ $1 == "ra"  ];then
    MatchNumber=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if($6<20) print $9}' | wc -l)
    AllPlayer=$( sed -e '1d' worldcupplayerinfo.tsv | wc -l )
    echo Number : $MatchNumber
    echo Percentage : $(awk "BEGIN { pc=100*${MatchNumber}/${AllPlayer}; i=int(pc); print (pc-i<0.5)?i:i+1 }")

# Age>=20 && Age<=30
  elif [ $1 == "rb" ];then
    MatchNumber=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if(($6>20 || $6==20) && ($6<30 || $6==30)) print $9}' | wc -l)
    AllPlayer=$( sed -e '1d' worldcupplayerinfo.tsv | wc -l )
    echo Number : $MatchNumber
    echo Percentage : $(awk "BEGIN { pc=100*${MatchNumber}/${AllPlayer}; i=int(pc); print (pc-i<0.5)?i:i+1 }")

# Age>30
  elif [ $1 == "rc" ];then
    MatchNumber=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if($6>30) print $9}' worldcupplayerinfo.tsv | wc -l)
    AllPlayer=$( sed -e '1d' worldcupplayerinfo.tsv | wc -l )
    echo Number : $MatchNumber
    echo Percentage : $(awk "BEGIN { pc=100*${MatchNumber}/${AllPlayer}; i=int(pc); print (pc-i<0.5)?i:i+1 }")

# Field
  elif [ $1 == "f" ];then
    
    #NUMBER 
   
    GoalieNumber=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if($5=="Goalie") print $9}' worldcupplayerinfo.tsv | wc -l )
    DefenderNumber=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if($5=="Defender" || $5=="Défenseur") print $9}' worldcupplayerinfo.tsv | wc -l)
    MiddleNumber=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if($5=="Midfielder") print $9}' worldcupplayerinfo.tsv | wc -l ) 
    ForwardNumber=$( sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{if($5=="Forward") print $9}' worldcupplayerinfo.tsv | wc -l )
    AllPlayer=$( sed -e '1d' worldcupplayerinfo.tsv | wc -l )
    
    #PERCENTAGE

    GoaliePercentage=$(awk "BEGIN { pc=100*${GoalieNumber}/${AllPlayer}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
    DefenderPercentage=$(awk "BEGIN { pc=100*${DefenderNumber}/${AllPlayer}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
    MiddlePercentage=$(awk "BEGIN { pc=100*${MiddleNumber}/${AllPlayer}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
    ForwardPercentage=$(awk "BEGIN { pc=100*${ForwardNumber}/${AllPlayer}; i=int(pc); print (pc-i<0.5)?i:i+1 }")

   #ECHO
   
   echo GoalieNumber/Percentage : $GoalieNumber / $GoaliePercentage
   echo DefenderNumber/Percentage : $DefenderNumber / $DefenderPercentage
   echo MiddleNumber/Percentage : $MiddleNumber / $MiddlePercentage
   echo ForwardNumber/Percentage : $ForwardNumber / $ForwardPercentage

# Name
  elif [ $1 == "n" ];then
    echo The Longest Name Is : $(sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{print $9}' | awk ' { if ( length > x ) { x = length; y = $0 } }END{ print y }')
    echo The Shortest Name Is : $(sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{print $9}' | sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' '{print $9}' | awk '(NR == 1 || length < length(shortest)) { shortest = $0 } END { print shortest }')


# Age
  elif [ $1 == "a" ];then
    min=$(sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' 'BEGIN {min = 60} {if ($6<min) min=$6 fi} END {print min}')
    max=$(sed -e '1d' worldcupplayerinfo.tsv | awk -F '\t' 'BEGIN {max = 0} {if ($6>max) max=$6 fi} END {print max}')
    echo The Oldest Player Is : 
    awk -F '\t' '{if ($6~/'$max'/) {print $0} }' worldcupplayerinfo.tsv
    echo $'\n'
    echo The Yongest Player Is :
    awk -F '\t' '{if ($6~/'$min'/) {print $0} }' worldcupplayerinfo.tsv
  else 
    Error
  fi
else
  Error
fi
