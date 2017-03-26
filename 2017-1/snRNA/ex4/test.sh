#!/bin/bash
quality="70"
RESOLUTION="50%x50%"
watermark=""
ARG_B="0"
Q_FLAG="0"
R_FLAG="0"
W_FLAG="0"
C_FLAG="0"
PREFIX=""
POSTFIX=""
DIR=`pwd`
# read the options
TEMP=`getopt -o acr:d:q:w: --long quality:arga,directory:,watermark:,prefix:,postfix:,help,resize: -n 'test.sh' -- "$@"`
eval set -- "$TEMP"

main()
{
output=${DIR}/output
mkdir -p $output
#ttt="find $DIR -regex '.*\(jpg\|jpeg\)'"
command="convert"
IM_FLAG="2"
if [[ "$Q_FLAG" == "1" ]]; then
  
  IM_FLAG="1"
  command=${command}" -quality "${quality}
fi

if [[ "$R_FLAG" == "1" ]]; then
  #img="find $DIR -regex '.*\(jpg\|jpeg\|png\|svg\)'"
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
       1) images=`find $DIR -regex '.*\(jpg\|jpeg\)'` ;;
       2) images=`find $DIR -regex '.*\(jpg\|jpeg\|png\|svg\)'` ;;

esac 

for CURRENT_IMAGE in $images; do
     filename=$(basename "$CURRENT_IMAGE")
     name=${filename%.*}
     suffix=${filename#*.}
     if [[ "$suffix" == "png" ]]; then 
       suffix="jpg"
     fi
     if [[ "$suffix" == "svg" ]]; then
       suffix="svg"
     fi
     savefile=${output}/${PREFIX}${name}${POSTFIX}.${suffix}
     temp=${command}" "${CURRENT_IMAGE}" "${savefile}
     eval $temp
     echo $temp
done

exit 0

}


# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -a|--arga) echo "options a"; shift ;;
        -c) C_FLAG="1" ; shift ;;
        -r|--resize) R_FLAG="1";
            case "$2" in
                "") shift 2 ;;
                *)RESOLUTION=$2 ; shift 2 ;;
            esac ;;
	--help) echo "test"; shift ;;
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
