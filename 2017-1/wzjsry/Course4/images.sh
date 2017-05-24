#!/bin/bash




function help()
{

  echo "  -q <source filepath> <out filepath>                     : images quality compression"
  echo "  -r <source filepath> <out filepath>                     : images compressed resolution"
  echo "  -w <source filepath> <watermark> <out filepath>         : embed watermark you entry"  
  echo "  -n <source filepath> <addname>   <out filepath>         : images rename"  
  echo "  -c <source filepath>             <out filepath>         : change .png/svg to .jpg"  
  echo "  -h show help list"
}

function qcom()
{
   #echo "$num"
   #echo "$path"
   #echo "hello"
   for f in `ls $path2` 
   do 
   #convert "$path/$f" -crop WidthxHeight+X0+Y0  "$2/$f"
   convert "$path2/$f" -quality 70 "$path3/$f"
   #echo hehe
   echo "image $f convert ok!"
   done
   echo "ok!"
}


function rcom()
{
	for f in `ls $path2` 
    do 
    convert "$path2/$f" -resize %25x%25 "$path3/$f"
    #echo hehe
    echo "image $f resize ok!"
    done
    echo "ok!"
		
}

function watermark()
{
	echo $path3
    for f in `ls $path2` 
    do 
    convert "$path2/$f" -draw 'text 5,5 "$path3" ' "$path4/$f"
    echo "image $f add watermark ok!"
    done
    echo "ok!"
	
}

function rename()
{
	#echo $path3
	
    for f in `ls $path2` 
    do 
    #$name=${path3}${f}
    #echo $name
    
    convert "$path2/$f"  "$path4/$path3$f"
   
    echo "image $f rename ok!"
    done
    echo "ok!"
    
}

function cformat()
{
    for f in `ls $path2` 
    do 
    convert "$path2/$f"  "$path3/$f.jpg"
    echo "image $f convert ok!"
    done
    echo "ok!"
   
}

num=$1
path2=$2
path3=$3
path4=$4
#echo "$#"
#echo "$1"
help
#echo "$2"
	while [ $# -gt 0 ] 
	do
		case "$1" in 
			-h)
                help 
                exit 
	            ;;

	        -q)
	            echo "images quality compression from "$2""
	           
                qcom 
                break
               
                ;;

            -r)
	            echo "images quality compressed resolution from "$2""
	            rcom 
                break
	            ;;

	        -w)
	            echo "embed watermark:"$2" to images which from "$2""
	            watermark 
	            break
	            ;;


	        -n)
	            echo "rename images by adding "$path3""
	            rename 
	            break
	            ;;

	        -c)
	            echo "change images format from .png/svg to .jpg"
	            cformat 
	            break
	            ;;
	        -*) echo "input false"
                exit 1
                ;;
        esac
    done

exit