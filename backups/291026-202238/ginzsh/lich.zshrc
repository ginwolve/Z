function showlich() {
    RED="\033[31m"; GREEN="\033[32m"; CYAN="\033[36m"; YELLOW="\033[33m"; RESET="\033[0m"
    TODAY=$(date +%d); MONTH=${1:-$(date +%m)}; YEAR=${2:-$(date +%Y)}
    echo -e "\n${CYAN}====== LỊCH THÁNG $MONTH / $YEAR ======${RESET}\n"
    RAW=$(cal $MONTH $YEAR)
    if [[ "$MONTH" == "$(date +%m)" && "$YEAR" == "$(date +%Y)" ]]; then
        RAW=$(echo "$RAW" | sed "s/ \( $TODAY \)\|^$TODAY / ${YELLOW}[${TODAY}]${RESET}/g")
    fi
    echo -e "$RAW\n\n${GREEN}====== FULL YEAR $YEAR ======${RESET}\n"; cal -y $YEAR; echo ""
}

function showfull() {
    showlich "$@"
    LUNAR=$(date +"%Y-%m-%d" | xargs -I{} python3 -c 'import sys; from lunardate import LunarDate; y,m,d=map(int,"{}".split("-")); l=LunarDate.fromSolarDate(y,m,d); print(f"{l.day}/{l.month}/{l.year}")' 2>/dev/null || echo "Require: pip install lunardate")
    echo -e "${GREEN}Ngày âm lịch hôm nay: \033[35m$LUNAR\033[0m\n"
    
    echo -e "\033[36m========== GIỜ THEO MÚI ==========\033[0m"
    echo -e "\033[33m🇻🇳 Việt Nam:      \033[0m$(TZ='Asia/Ho_Chi_Minh' date '+%H:%M')"
    echo -e "\033[33m🇺🇸 New York:      \033[0m$(TZ='America/New_York' date '+%H:%M')\n"

    WEATHER=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=10.82&longitude=106.63&current_weather=true")
    TEMP=$(echo $WEATHER | grep -o '"temperature":[0-9\.]*' | cut -d: -f2)
    WIND=$(echo $WEATHER | grep -o '"windspeed":[0-9\.]*' | cut -d: -f2)
    echo -e "\033[36m========== THỜI TIẾT SG / HCM ==========\033[0m"
    echo -e "Nhiệt độ: \033[33m${TEMP}°C\033[0m\nGió:       \033[33m${WIND} km/h\033[0m\n"

    QUOTES=("Cuộc đời này đắng, nhưng anh thì ngọt với tôi." "Giữa khói thuốc và lập trình, chỉ có tình nghĩa đàn ông ở lại." "Sống cho tử tế, code cho sạch, yêu thì đừng lật lọng." "Đời không nương anh, nhưng tôi nương anh.")
    echo -e "\033[32mTrích dẫn hôm nay: \033[0m\033[36m\"${QUOTES[$(( RANDOM % ${#QUOTES[@]} ))]}\"\033[0m\n"
}

function lich() {
    TODAY=$(date +%d); MONTH=$(date +%m); YEAR=$(date +%Y)
    RAW=$(cal $MONTH $YEAR | sed "s/ \( $TODAY \)\|^$TODAY / \033[33m[${TODAY}]\033[0m/g")
    echo -e "\033[36m====== LỊCH $MONTH / $YEAR ======\033[0m\n$RAW\n"
}