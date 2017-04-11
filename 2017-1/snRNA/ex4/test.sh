#!/bin/bash
quality="70"
RESOLUTION="50%x50%"
watermark=""
Q_FLAG="0"
R_FLAG="0"
W_FLAG="0"
C_FLAG="0"
H_FLAG="0"
PREFIX=""
POSTFIX=""
DIR=`pwd`
# read the options

useage()
{
  echo "Useage:bash test.sh  -d [directory] [option|option]"
  echo "options:"
  echo "  -d [directory]                assign the directory including the images you want to process,the script will create an output directory under"
  echo "  -c                            change the png/svg to jpg image"
  echo "  -r|--resize [width*height]    resize the image with resolution such as 700x700 or 50%x50%"
  echo "  -q|--quality [number]         compress the quality of jpg images "
  echo "  -w|watermark [watermark]      put the watermark on the images"
  echo "  --prefix[prefix]              assign the prefix of the name of output images"
  echo "  --postfix[postfix]            assign the postfix of the name of output images"
}

main()
{

if [[ "$H_FLAG" == "1" ]]; then
    useage
fi

if [ ! -d "$DIR" ] ; then
  echo "No such directory"
  exit 0
fi

output=${DIR}/output
mkdir -p $output

command="convert"
IM_FLAG="2"
if [[ "$Q_FLAG" == "1" ]]; then
  
  IM_FLAG="1"
  command=${command}" -quality "${quality}
fi

if [[ "$R_FLAG" == "1" ]]; then

  command=${command}" -resize "${RESOLUTION}
fi

if [[ "$W_FLAG" == "1" ]]; then
  echo ${watermark}
  command=${command}" -fill white -pointsize 40 -draw 'text 10,50 \"${watermark}\"' "
fi

if [[ "$C_FLAG" == "1" ]]; then
  IM_FLAG="2"
fi


case "$IM_FLAG" in
       1) images=`find $DIR -maxdepth 1 -regex '.*\(jpg\|jpeg\)'` ;;
       2) images=`find $DIR -maxdepth 1 -regex '.*\(jpg\|jpeg\|png\|svg\)'` ;;

esac 

for CURRENT_IMAGE in $images; do
     filename=$(basename "$CURRENT_IMAGE")
     name=${filename%.*}
     suffix=${filename#*.}
     if [[ "$suffix" == "png" && "$C_FLAG" == "1" ]]; then 
       suffix="jpg"
     fi
     if [[ "$suffix" == "svg" && "$C_FLAG" == "1" ]]; then
       suffix="jpg"
     fi
     savefile=${output}/${PREFIX}${name}${POSTFIX}.${suffix}
     temp=${command}" "${CURRENT_IMAGE}" "${savefile}
     eval $temp
     #echo $temp
done

exit 0

}


TEMP=`getopt -o cr:d:q:w: --long quality:arga,directory:,watermark:,prefix:,postfix:,help,resize: -n 'test.sh' -- "$@"`
eval set -- "$TEMP"
# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -c) C_FLAG="1" ; shift ;;
        -r|--resize) R_FLAG="1";
            case "$2" in
                "") shift 2 ;;
                *)RESOLUTION=$2 ; shift 2 ;;
            esac ;;
        --help) H_FLAG="1"; shift ;;
        -d|--directory)
            case "$2" in 
                "") shift 2 ;;
                 *) DIR=$2 ; shift 2 ;;
            esac ;; 
        -q|--quality) Q_FLAG="1";
            case "$2" in
                "") shift 2 ;;
        #todo  detect if the arg is integer
                 *) quality=$2; shift 2 ;;
            esac ;;
        -w|--watermark)W_FLAG="1"; watermark=$2; shift 2 ;;
        --prefix) PREFIX=$2; shift 2;;
        --postfix) POSTFIX=$2; shift 2 ;;
                
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


main

