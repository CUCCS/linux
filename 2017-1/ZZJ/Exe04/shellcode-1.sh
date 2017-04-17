#!bin/bash

#shellcode-1.sh参考自HJJ同学的作业

#任务一：用bash编写一个图片批处理脚本，实现以下功能：
#支持命令行参数方式使用不同功能
#支持对指定目录下所有支持格式的图片文件进行批处理
#支持以下常见图片批处理功能的单独使用或组合使用：
#支持对jpeg格式图片进行图片质量压缩
#支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
#支持对图片批量添加自定义文本水印
#支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
#支持将png/svg图片统一转换为jpg格式图片


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
