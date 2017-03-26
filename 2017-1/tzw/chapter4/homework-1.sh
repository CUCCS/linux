#!/bin/bash
#Bash File For Image Processing

function Error()
{
  echo usage: 
  echo "      $0 -q [quality] [source.jpg] [destination.jpg] : compress image according to quality"
  echo "      $0 -r [%|(size)x(size)] [source.jpg|png] [destination.jpg|png] : compress image while keeping the same height and width (Please add / when using %)"
  echo "      $0 -w [filename.jpg] [watermark] : embed watermark according to input (Please add / when using *.jpg to batch)"  
  echo "      $0 -n [pattern] [replacement] : batch rename file according to input"  
  echo "      $0 -j [source(.png)] [destination(.jpg)] : switch .png/svg to .jpg"  
  exit 1

}


function Process()
{
  case $1 in
    100) if [ $# == 4 ];then
	   if [ ! -f "$3" ];then
	     echo No such source file. Dont fool me please..
           else
	     if [ `file --mime-type -b $3` == "image/jpeg" ];then
               $(convert -quality $2 $3 $4)
	       if [ $? == 1 ];then
	         echo Quality Compress Failed!
		 exit 1
	       else
	         echo Quality Compress Success!
		 exit 0
	       fi
	     else
	       echo Wrong Type. Jpeg Needed!
	       exit 1
	     fi
	   fi
  	 else
	   Error
	 fi
         ;;
    101) if [ $# == 4 ];then
           if [ ! -f "$3" ];then
             echo No such source file. Dont fool me please..
           else
             if [ `file --mime-type -b $3` == "image/jpeg" -o `file --mime-type -b $3` == "image/png" ];then
               $(convert $3 -resize $2 $4)
               if [ $? == 1 ];then
                 echo Resize Image Failed!
                 exit 1
               else
                 echo Resize Image Success!
                 exit 0
               fi
             else
               echo Wrong Type. Jpeg/Png Needed!
               exit 1
             fi
           fi
         else
           Error
         fi
         ;;
    102) if [ $# == 3 ];then
           $(mogrify -gravity SouthEast -fill black -draw 'text 0,0 '$3'' $2)
             if [ $? == 1 ];then
               echo Embed Watermark Image Failed!
               exit 1
             else
               echo Embed Watermark Image Success!
               exit
             fi
         else
           Error
         fi
         ;;

    103) if [ $# == 3 ];then
           $(rename  s'/'$2'/'$3'/' *)  
	     if [ $? == 1 ];then
               echo Rename File Failed!
               exit 1
             else
               echo Rename File Success!
               exit
             fi
         else
           Error
         fi
         ;;
    104) if [ $# == 3 ];then
	   if [ ! -f $2.png ];then
	     echo No Such File. Dont fool me plz..
	     exit 1
	   else
	     if [ `file --mime-type -b $2.png` == "image/png" ];then
               $(convert $2.png $3.jpg)
               if [ $? == 1 ];then
                 echo Convert png/svg to jpg Failed!
                 exit 1
               else
                 echo Convert png/svg to jpg Success!
	   	 echo Old png/svg File : $(file $2.png)
		 echo New jpg File : $(file $3.jpg)
                 exit
               fi
 
	     else
	       echo Wrong Type! Png/Svg Needed!
	       exit 1
	     fi
	   fi
         else
           Error
         fi
         ;;

  esac

}



function CheckInput()
{
  CHOICE=("-q" "-r" "-w" "-n" "-j")
  COUNT=100
  if [ $# -gt 0 ];then
    for N in ${CHOICE[@]};do
      if [ $N = "$1" ];then
        Process $COUNT $2 $3 $4
        exit 0
      fi
      COUNT=$(($COUNT + 1))
    done
  fi
  Error
}

CheckInput $1 $2 $3 $4
