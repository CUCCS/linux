#实验四：shell脚本编程基础

----------
##一、实验内容  
###任务二：  
用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务： ◾2014世界杯运动员数据  
◦统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比  
◦统计不同场上位置的球员数量、百分比  
◦名字最长的球员是谁？名字最短的球员是谁？  
◦年龄最大的球员是谁？年龄最小的球员是谁？ 

##二、实验步骤

#####1.统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比  
使用awkawk把Age逐行读入  
`age=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)`  
> 参数：  
> -F指定分隔符  
> \t指制表符  
> $6 第六个参数

利用for循环比较年龄大小并计数 

    for i in $age
     do
    	if [ $i != 'Age' ];
    	then
   			people=$[$people+1]
   		
		if [ $i -lt 20 ];
    	then
    		count20=$[$count20+1]
    	fi
    
    	if [ $i -ge 20 ]&&[ $i -le 30 ]
    	then
    		count2030=$[$count2030+1]
    	fi
    
    	if [ $i -gt 30 ]
    	then
    		count30=$[$count30+1]
    	fi
    fi
    done
输出百分比：  
    `The proportion:'$(awk 'BEGIN{printf "%.2f",'$count20*100/$people'}')'%'`
#####2.统计不同场上位置的球员数量、百分比
总共有四个位置：'Goalie'  'Defender' 'Midfielder' 'Forward'   
安行读取第五个参数并判断是否是其中之一，如果是就计数   
    
    position=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv)  
    

利用for循环  

    for m in $position
    do
    	if [ $m == 'Goalie' ]
    	then
    		goalie=$[$goalie+1]
    	fi
    	if [ $m == 'Defender' ]
    	then
    		defender=$[$defender+1]
    	fi
    	if [ $m == 'Midfielder' ]
    	then
    		midfielder=$[$midfielder+1]
    	fi
    	if [ $m == 'Forward' ]
    	then
    		forward=$[$forward+1]
    	fi
	fi
    done


#####3.名字最长的球员是谁？名字最短的球员是谁？
求出第九个参数的长度  

    length=$(awk -F '\t' '{print length($9)}' worldcupplayerinfo.tsv)
  
利用for循环  
    
    for k in $length
    do
    	if [ $k -gt $TheLongestName ]
    	then
    		TheLongestName=$k
    	fi
    	if [ $k -lt $TheShortestName ]
    	then
    		TheShortestName=$k
    	fi
    fi
    done

#####4.年龄最大的球员是谁？年龄最小的球员是谁？  

用for循环找年龄最大和最小的
  
    for j in $age
    do
    if [ $j != 'Age' ];
    then
    	if [ $j -gt $oldest ];
    	then
    		oldest=$j
    	fi
    	if [ $j -lt $youngest ];
   		then
    		youngest=$j
   	 	fi
    fi
	fi
    done

判断第六个参数是否与年龄最老的数字相等，如是则输出相应名字：     
利用awk逻辑运算

    The oldest people is:'$(awk -F '\t' '{ if ($6~/'$oldest'/) {print $9}}' worldcupplayerinfo.tsv)'



awk **命令**详解参考自：[http://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858470.html](http://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858470.html)  
awk **参数**详解参考自：[http://blog.csdn.net/weinierzui/article/details/53078622](http://blog.csdn.net/weinierzui/article/details/53078622)  
参考同学：程乙轩、谭嘉仪、衡俊吉  

##三、实验结果

![](/2.png)

