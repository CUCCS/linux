#!/bin/bash
input=""
output=""
quality_pct="75"
resolution_pct="25"
text=""
prefix=""
suffix=""
isCompressQuality="0"
isCompressResolution="0"
isTextWatermark="0"
isPrefix="0"
isSuffix="0"
isTransJPG="0"


function Usage

{
    echo "Usage:"
    echo "  -i  --input <filename>              Input image for processing"
    echo "  -o  --output <filename>             Output image for saving"
    echo "  -q, --quality <percent>             Image quality compression, default 75%, input and output are needed"
    echo "  -r, --resolution <percent>          Image resolution compression, default 25%, input and output are needed"
    echo "  -w, --watermark <text>              Add text watermark, input and output are needed"
    echo "  -p, --prefix <prefix>               Add prefix"
    echo "  -s, --suffix <suffix>               Add suffix"
    echo "  -t, --transfer                      Transfer image format, input and output are needed"
    echo "  -h,  --help"
}

function compressQuality
{
    if [ -f "$1" ]; then  
        $(convert "$1" -quality "$2"% "$3")
        echo " Compress "$1" into "$3"."   
    else  
        echo "No such a file "$1" exist."  
    fi
}

function compressResolution
{
    if [ -f "$1" ]; then 
        $(convert "$1" -resize "$2"% "$3")
        echo " Compress "$1" into "$3"."  
    else
        echo "No such a file "$1" exist."
    fi
}

function addTextWatermark
{
    if [ -f "$1" ]; then
        $(convert "$1" -draw "gravity east fill black  text 0,12 "$2" " "$3") 
        echo ""$3" contains the text:"$2""
    else 
        echo "No such a file "$1" exist."
    fi
}

function transFormat
{
    if [ -f "$1" ]; then 
        $(convert "$1" "$2")
        echo "Transfer "$1" into "$2""
    else
        echo "No such a file "$1" exist."
    fi
}

function addPrefix
{
    for name in `ls *`
    do
        cp "$name" "$1"."$name"
    done
}

function addSuffix
{
    for name in `ls *`
        do
        cp "$name" "$name"."$1"
        done
}


####################### Main ############################

# Option analysis and parameters

while [ $# -gt 0 ]; do
    case "$1" in
        -i|--input)   echo "Option i, argument \`$2'" ;
		      case "$2" in
		          "") echo "parameter is needed" ; break ;;
			  *)  input=$2; shift 2 ;;
		      esac ;;
                     
        -o|--output)  echo "Option o, argument \`$2'" ;
                      case "$2" in
		  	  "") echo "parameter is needed" ; break ;;
			  *)  output=$2; shift 2 ;;
		      esac ;;

        -q|--quality)         echo "Option q, argument \`$2'" ;
			      quality_pct=$2 ; isCompressQuality="1" ; shift 2 ;;
                      

        -r|--resolution)      echo "Option r, argument \`$2'" ;
			      resolution_pct=$2 ; isCompressResolution="1" ; shift 2 ;;
                              

        -w|--watermark)   echo "Option w, argument \`$2'" ;
			      text=$2 ; isTextWatermark="1"	 ; shift 2 ;;		  
			     
   		  	       
	-p|--prefix)	      echo "Option p " ;
			      case "$2" in
                                  "") echo "parameter is needed" ; break ;;
			          *)  isPrefix="1" ; prefix=$2 ; shift 2 ;;	  
			      esac ;;	
		
			
	-s|--suffix)	      echo "Option s " ;
			      case "$2" in
				  "") echo "parameter is needed" ; break ;;
				  *)  isSuffix="1" ; suffix=$2 ; shift 2 ;;  
			      esac ;;
			      
	-t|--transfer) 	      echo "Option f" ;
                              isTransFormat="1"
                              shift ;;

        -h|--help)	      Usage
                       	      exit
                       	      ;;

	\?)                   Usage
                              exit 1 ;;

    esac
   
done


# Execution of options

if [ "$isCompressQuality" == "1" ] ; then
	compressQuality $input $quality_pct $output
fi

if [ "$isCompressResolution" == "1" ] ; then
        compressResolution $input $resolution_pct $output
fi

if [ "$isTransJPG" == "1" ] ; then
        transFormat $input $output
fi

if [ "$isTextWatermark" == "1" ] ; then
        addTextWatermark $input $text $output
fi

if [ "$isPrefix" == "1"  ] ; then
        addPrefix $prefix
fi

if [ "$isSuffix" == "1" ] ; then
        addSuffix $suffix
fi


