#!bin/bash
#实现了实验一的全部功能，直接运行脚本会出现帮助信息，提供对应参数，和示例输入

function HELP()
{
  echo HELP: 
  echo "      -c [quality] : Compress all images in this dir according to quality (like: '-c 40')"
  echo "      -r [percent%] : Compress all images in this dir while by keeping the giving percent  (like: '-r 50%')"
  echo "      -n [name] : Rename all images in this dir by adding a certain name after the original name (like: '-n hahaha' will change the file '***.jpg' to '***_hahaha.jpg' as well as other file in that dir" )
  echo "      -w [text] : Add watermark accoring to 'text' to all images in this dir (like: '-w hahaha')"  
  echo "      -t [newname] : Switch .png to .jpg and give a newname to the .jpg file according to 'newname' you input （like '-t abc' will create new .jpg files named with '***_abc.jpg'）"  
  exit 0


}

function Image_edit()
{
 case $1 in
  1) if [ $# == 3 ];
     then
       if [ $(file --mime-type -b $3) == "image/jpeg" ];
       then
        $(convert -quality $2 $3 "Compress_"$3)
        if [ $? == 0 ];
        then
         echo "the compress of" $3 "is successful!"
        fi
       else
        echo $3 "is a wrong file type!"
       fi 
     fi
     ;;

  2) if [ $# == 3 ];
     then
       if [ $(file --mime-type -b $3) == "image/jpeg" ];
       then
        $(convert $3 -resize $2 "Resize_"$3)
        if [ $? == 0 ];
        then
         echo "the compress of" $3 "is successful!"
        fi
       else
        echo $3 "is a wrong file type!"
       fi 
     fi
     ;;

  3) if [ $# == 3 ];
     then
       if [ $(file --mime-type -b $3) == "image/jpeg" -o $(file --mime-type -b $3) == "image/png" ];
       then
        mv "$3" "${3%.jpg}_$2.jpg"
        if [ $? == 0 ];
        then
         echo "Rename" $3 "successfully!"
        fi
       else
        echo $3 "is a wrong file type!"
       fi 
     fi
     ;;

  4) if [ $# == 3 ];
     then
       if [ $(file --mime-type -b $3) == "image/jpeg" -o $(file --mime-type -b $3) == "image/png" ];
       then
        $(mogrify -gravity SouthEast -fill black -draw 'text 0,0 '$2'' $3)
        if [ $? == 0 ];
        then
         echo "the watermarking of" $3 "is successful!"
        fi
       else
        echo $3 "is a wrong file type!"
       fi 
     fi
     ;;

  5) if [ $# == 3 ];
     then
       if [ $(file --mime-type -b $3) == "image/png" ];
       then
        $(convert $3 ${3%.png}_$2.jpg)
        if [ $? == 0 ];
        then
         echo "the format changing of" $3 "is successful!"
        fi
       else
        echo $3 "is a wrong file type!"
       fi 
     fi
     ;;


 esac
}



function main()
{
  input=("-c" "-r" "-n" "-w" "-t")
 if [ $# == 2 ];
  then
  num=1
    for A in ${input[@]};
     do
      if [ $A = "$1" ];
      then
        for file in $(ls)
        do          
         Image_edit $num $2 $file 
        done
      fi
      num=$(($num + 1))
       if [ $num == 6 ];
       then
       HELP
       exit 1
       fi
     done
 else
  HELP
 fi
}

main $1 $2 
