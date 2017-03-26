
# sort all
`sed -e '1d' web_log.tsv | awk -F '\t' '{a[$1]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | head -n 100`

# sort ip
`sed -e '1d' web_log.tsv | awk -F '\t' '{a[$1]++} END {for(i in a){print i,a[i] }}' | awk '{ if($1~/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]/){print} }' | sort -nr -k2 | head -n 100`


