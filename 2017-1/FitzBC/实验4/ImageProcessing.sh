#!/bin/bash
function usage
{
    echo "usage: ImageProcessing.sh [-f filename][-cq percent][-cr percent][-cf][-tw text][-sr suffixrename][-pr prefixrename][-bp directory][-h]"
    echo ""
    echo "optional arguments:"
    echo "  -f,  --file <filename>               The filename"
    echo "  -cq, --compqua <percent>             Image compression"
    echo "  -cr, --compreso <percent>            Compresse image resolution"
    echo "  -cf, --changeformat                  Change image format to jpg(Keep Original Image)"
    echo "  -tw, --textwatermark <text>          Add text watermark"
    echo "  -sr, --suffixrename <suffixrename>   Add suffixname(jpeg,jpg,png,svg)"
    echo "  -pr, --prefixrename  <prefixrename>  Add prefixname(jpeg,jpg,png,svg)"
    echo "  -bp, --batchprocessing <directory>   Batch processing of image"
    echo "  -h,  --help"
}
function compressquality
{
    $(convert -quality $1% $2 "aftercompress_"$2)
    echo $2" compress finished!"       
}
function compressresolution
{
    $(convert -resize $1% $2 "aftercompress_"$2)
    echo $2" compress finished!"        
}
function addtextwatermark
{ 
    $(convert $1 -gravity southeast -fill white -font 1.ttf -pointsize 32 -draw 'text 5,5 '\'$2\' $1)
    echo $1" add finished!"
}
function changeformat
{
    STRING=$1
    newname=${STRING/%.*}
    format=${STRING:$(expr index $STRING .)}
    $(convert $1 $newname'.jpg')
    echo $1" change finished!"
}
function Prefixrename
{
    STRING=$1
    oldname=${STRING/%.*}
    format=${STRING:$(expr index $STRING .)}
    Su=${STRING:0:$(expr index $STRING /)}
    purename=${STRING:$(expr index $oldname /)}
    newname=$Su$2$purename
    $(mv $1 $newname)
    echo $1" Prefix rename finished!"
}
function Suffixrename
{
    STRING=$1
    oldname=${STRING:0:$[$(expr index $STRING .)-1]}
    format=${STRING:$[$(expr index $STRING .)-1]}  
    Su=${STRING:0:$(expr index $STRING /)}
    purename=${oldname:$(expr index $oldname /)}
    newname=$Su$purename$2$format 
    $(mv $1 $newname)
    echo $1" Suffix rename finished!"
}
function batchprocess
{
    dic=('jpeg' 'jpg' 'png' 'svg')
    dicname=$1 
    if [[ ${STRING:$[$(expr length $STRING)-1]}!='/' ]]
    then
        dicname=$dicname'/'
    fi
    for file in $(ls $dicname)
    do
        if [[ -f $file ]]
        then       
            STRING=$file
            format=${STRING:$(expr index $STRING .)}
            for form in ${dic[@]}
            do
                if [[ $form == $format ]]
                then
                    if [[ $ifcompqua ]]
                    then
                        compressquality $quality $dicname$file
                    fi
                    if [[ $ifcompreso ]]
                    then
                        compressresolution $compressratio $dicname$file
                    fi
                    if [[ $iftextwatermark ]]
                    then
                        addtextwatermark $dicname$file $textcontent
                    fi
                    if [[ $ifchangeformat ]]
                    then
                        changeformat $dicname$file
                    fi
                    if [[ $ifSuffixrename ]]
                    then
                        Suffixrename $dicname$file $Suffix
                    fi
                    if [[ $ifPrefixrename ]]
                    then
                        Prefixrename $dicname$file $Prefix
                    fi
                    break
                fi
            done
        fi
    done
}
if [ $# == 0 ];
then
    usage
fi
while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
                                if [[ $1 != -* && $1 ]]
                                then
                                    filename=$1
                                else
                                    echo "Warnning: There need a argument after -f"
                                    exit
                                fi
                                ;;
        -cq | --compqua )       ifcompqua=1
                                shift
                                if [[ $1 != -* && $1 ]]
                                then
                                    quality=$1
                                else
                                    echo "Warnning: There need a argument after -cq"
                                    exit
                                fi
                                ;;
        -cr | --compreso )      ifcompreso=1
                                shift
                                if [[ $1 != -* && $1 ]]
                                then
                                    compressratio=$1
                                else
                                    echo "Warnning: There need a argument after -cr"
                                    exit
                                fi
                                ;;
        -cf | --changeformat )  ifchangeformat=1
                                ;;
        -tw | --textwatermark ) iftextwatermark=1
                                shift
                                if [[ $1 != -* && $1 ]]
                                then
                                    textcontent=$1
                                else
                                    echo "Warnning: There need a argument after -tw"
                                    exit
                                fi
                                ;;
        -sr | --suffixrename )  ifSuffixrename=1
                                shift
                                if [[ $1 != -* && $1 ]]
                                then
                                    Suffix=$1
                                else
                                    echo "Warnning: There need a argument after -sr"
                                    exit
                                fi
                                ;;
        -pr | --prefixrename )  ifPrefixrename=1
                                shift
                                if [[ $1 != -* && $1 ]]
                                then
                                    Prefix=$1
                                else
                                    echo "Warnning: There need a argument after -pr"
                                    exit
                                fi
                                ;;
        -bp | --batchprocessing )
                                ifBatchprocessing=1
                                shift
                                if [[ $1 != -* && $1 ]]
                                then
                                    Batchprocessing=$1
                                else
                                    echo "Warnning: There need a argument after -bp"
                                    exit
                                fi
                                ;;
        h | --help )            usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
if [[ $ifBatchprocessing ]]
then
    batchprocess $Batchprocessing
fi
if [[ $ifcompqua && $quality && $filename ]]
then
    compressquality $quality $filename
fi
if [[ $ifcompreso &&  $compressratio && $filename ]]
then
    compressresolution $compressratio $filename
fi
if [[ $iftextwatermark && $filename && $textcontent ]]
then
    addtextwatermark $filename $textcontent
fi
if [[ $ifchangeformat && $filename ]]
then
    changeformat $filename
fi
if [[ $ifSuffixrename && $filename && $Suffix ]]
then
    Suffixrename $filename $Suffix
fi
if [[ $ifPrefixrename && $filename && $Prefix ]]
then
    Prefixrename $filename $Prefix
fi
