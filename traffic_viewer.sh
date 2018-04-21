INPUT=$(sudo vnstat -u && vnstat|grep rx:|awk '{print $2,$3}')
OUTPUT=$(sudo vnstat -u && vnstat|grep rx:|awk '{print $5,$6}')
TOTAL=$(sudo vnstat -u && vnstat|grep rx:|awk '{print $8,$9}')

case $1 in
    -i) echo -e "INPUT: $INPUT\n" ;;
    -o) echo -e "OUTPUT: $OUTPUT\n" ;;
    -t) echo -e "TOTAL: $TOTAL\n" ;;
    -a) echo -e "ALL: INPUT $INPUT\nOUTPUT: $OUTPUT\nTOTAL: $TOTAL\n" ;;
	--json) echo -e "{\"input\":\"$INPUT\", \"output\":\"$OUTPUT\", \"total\":\"$TOTAL\"}" ;;
    "") exit 0 ;;
esac