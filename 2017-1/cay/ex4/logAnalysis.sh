# Top 100

echo "------ # Top 100 hosts and according frequencies # -------"
echo -e
top100Host=$(more web_log.tsv | awk -F '\t' '{print $1}'| sort | uniq -c | sort -k1 -nr | head -n 100)
echo "$top100Host"


echo "---- # Top 100 hosts' IP and according frequencies # -----"
echo -e
top100IP=$(more web_log.tsv | awk -F '\t' '{print $1}' | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sort | uniq -c | sort -k1 -nr | head -n 100)
echo "$top100IP"


echo "--- # Top 100 busiest URLs and according frequencies # ---"
echo -e
top100URL=$(more web_log.tsv |awk -F '\t' '{print $5}' | sort | uniq -c | sort -k1 -nr | head -n 100)
echo "$top100URL"

function RespStats
{

	respCode=$(sed -n '2,$ p' web_log.tsv |awk -F'\t' '{print $6}'| sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}')

	respCount=$(sed -n '2,$ p' web_log.tsv |awk -F'\t' '{print $6}'| sort | uniq -c |sort -nr | head -n 10 | awk '{print $1}')

	code=($respCode)
	count=($respCount)

	sum=0
	 for i in $respCount
	 do
		sum=$((${sum}+${i}))
	done

	p=0
	for k in ${count[@]}
	do	
		ratio[${p}]=$(echo "scale=4; 100*${k}/$sum"|bc)
		let p+=1
	done
	
	echo -e
	echo -e "----- # Response Code Statistics # -----"
	echo "----------------------------------------"
	echo -e
	for i in $(seq 0 $(echo "${#count[@]}-1"|bc))
	do
		echo "Response Code: ${code[${i}]}"
		echo "Response Count: ${count[${i}]}"
		echo "Proportion: ${ratio[${i}]}%"
	done
	echo -e


	# Top10 Url Over 4xx
	# Top1/our/lover/4xx

	temp=$(more web_log.tsv | awk -F'\t' '{if(substr($6,1,1)==4)print $5"\t"$6}' > target2.txt)
	codes_type=$(more target2.txt | awk -F'\t' '{print $2}'| sort | uniq -c | awk '{print $2}')
	codes_count=$(more target2.txt | awk -F'\t' '{print $2}'| sort | uniq -c | awk '{print $1}')

	# 404 403
	for t in $codes_type
	do	
		
		echo -e "-------# Top 10 urls for response code $t # -------"
		echo -e
		echo "| Frequency |"
		echo -e
		url=$(more target2.txt | awk -F'\t' '{if($2=='$t')print $1}' | sort | uniq -c | sort -nr | head)	
		echo "$url"
		echo -e
	done
	
	

	# Specify a url then find out top 100 hosts ( non-interactive )
	
	url="/images/NASA-logosmall.gif"
	
	echo -e
	echo "----- # Top 100 hosts which visited $url # ------"
	echo -e
	echo "| frequency |"
	echo -e 
	hosts=$(more web_log.tsv | awk -F'\t' '{if("'$url'"==$5)print $1}' | sort | uniq -c | sort -k1 -nr |head -n 100)
	echo "$hosts"

	
}

RespStats
