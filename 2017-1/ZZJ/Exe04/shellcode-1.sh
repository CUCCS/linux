#!/bin/bash

#shellcode-1.sh参考自TJY同学的imagemagick.sh，经TJY同学讲解后理解内容


TYPE=0
DFLAG=0
DIR=`pwd`
QFLAG=0
QUALITY="0"
SFLAG=0
RESIZE="0"
WFLAG=0
WATERMARK="0"
PRFLAG=0
PREFIX="0"
POFLAG=0
POSTFIX="0"
TFLAG=0


# set arguement
TEMP=`getopt -o a:i:q:s:w:e:o:t --long arga:,input:,qualify:,resize:,watermark:,prefix:,postfix:,changetype,help -n 'test.sh' -- "$@"`

# the function main
main(){

# build a new directory to save the output image
if [ ! -d "$DIR" ] ; then
  echo "No such file or directory"
  exit 0
fi
OUTPUT=${DIR}/output
mkdir -p $OUTPUT

# limit the image format
if [[ $TFLAG == 1 && $QFLAG == 1 || $TFLAG == 1 && $SFLAG == 1 ]] ; then
  TYPE=0
elif [[ $QFLAG == 1 && $SFLAG == 1 ]] ; then
  TYPE=1
fi

imageType=""
case "$TYPE" in
  0) imageType=".*\(jpg\|JPG\|jpeg\|png\|PNG\|svg\|SVG\)" ;;
  1) imageType=".*\(jpg\|JPG\|jpeg\)" ;;
  2) imageType=".*\(png\|PNG\|svg\|SVG\)" ;;
esac

# get images under the directory , put into the array
imageFind="find $DIR -maxdepth 1 -regex $imageType"
iArray=$($imageFind)

# make the command of imagemagick
imageExec="convert "

if [ $QFLAG == 1 ] ; then
  imageExec="$imageExec -quality $QUALITY"
fi
if [ $SFLAG == 1 ] ; then
  imageExec="$imageExec -resize $RESIZE"
fi

if [ $WFLAG == 1 ] ; then
  imageExec=$imageExec" -font AvantGarde-Book -pointsize 30 -draw 'text 10,50 \"$WATERMARK\"'"
fi
 
# execute the command one by one
for img in $iArray ; do
  iName=$(basename "$img")
  if [ $PRFLAG == 1 ] ; then
    iName="${PREFIX}${iName}"
  fi
  if [ $POFLAG == 1 ] ; then
    iName=${iName%%.*}${POSTFIX}"."${iName#*.}
  fi
  if [ $TFLAG == 1 ] ; then
    iName="${iName%%.*}.jpg"
  fi
  iExec="$imageExec $img $OUTPUT/$iName"
  eval $iExec
done
exit 0
}

eval set -- "$TEMP"

while true ; do
    case "$1" in
	-a|--arga) echo "Option a" ; shift ;;
	-i|--input) DIR=$2 ; DFLAG=1 ; shift 2;;
	-q|--quality) QUALITY=$2 ; QFLAG=1 ; TYPE=1 ; shift 2;;
	-s|--resize) RESIZE=$2 ; SFLAG=1 ; TYPE=0 ; shift 2;;
	-w|--watermark) WATERMARK=$2 ; WFLAG=1; TYPE=0 ; shift 2;;
	-e|--prefix) PREFIX=$2 ; PRFLAG=1 ; TYPE=0 ; shift 2;;
	-o|--postfix) POSTFIX=$2 ; POFLAG=1 ; TYPE=0 ; shift 2;;
	-t|--changetype) TFLAG=1; TYPE=2 ; shift ;;
	--help) echo -e "imagemagick.sh supports batching all supported image files in the specified directory\n
Usage: bash imagemagick.sh [OPTIONS] [PARAMETER] \n
-i, --input[=DIRECTORY]          choose the specified DIRECTORY\n
-q, --quality[=QUALITY]          for jpeg format images to image quality compression\n
-s, --resize[=SIZE]              for jpeg/png/svg images to maintain the original aspect ratio under the premise of compression resolution\n
-w, --watermark[=TEXT]           add custom TEXT watermarks to images\n
-e, --prefix[=PREFIX]           add the PREFIX to rename the images\n
-o, --postfix[=POSTFIX]         add the POSTFIX to rename the images\n
-t, --changetype                 change the png/svg format images to jpeg format images\n
--help                           ask for help\n"; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done
# echo "Remaining arguments:"
# for arg do
#    echo '--> '"\`$arg'" ;
# done

main
