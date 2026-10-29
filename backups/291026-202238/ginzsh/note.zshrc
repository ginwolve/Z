function note() {
  logfile="$HOME/.notes.log"
  chflags nouchg "$logfile" 2>/dev/null || true
  block_id=$(grep -c "^┌" "$logfile" 2>/dev/null || echo 0)
  block_id=$((block_id + 1))
  now=$(date "+%Y-%m-%d %H:%M:%S")
  weekday=$(LC_TIME=vi_VN.UTF-8 date +%A)
  weeknum=$(date +%U)
  day=$(date +%-d)
  monthweek=$(( (day - 1) / 7 + 1 ))
  hour=$(date +%H)

  if   [ $hour -ge 0  ] && [ $hour -lt 5 ];  then buoi="Khuya"
  elif [ $hour -ge 5  ] && [ $hour -lt 11 ]; then buoi="Sáng"
  elif [ $hour -ge 11 ] && [ $hour -lt 13 ]; then buoi="Trưa"
  elif [ $hour -ge 13 ] && [ $hour -lt 18 ]; then buoi="Chiều"
  else buoi="Tối"; fi

  case $(date +%m) in
    12|01|02) season="Đông" ;;
    03|04|05) season="Xuân" ;;
    06|07|08) season="Hạ" ;;
    09|10|11) season="Thu" ;;
  esac

  {
    echo "┌───────────────────────────────"
    echo "│ ID: $block_id"
    echo "│ Time: $now"
    echo "│ Thứ: $weekday | Tuần $monthweek của tháng | Tuần $weeknum của năm"
    echo "│ Buổi: $buoi | Mùa: $season"
    echo "├───────────────────────────────"
    echo "$*"
    echo "└───────────────────────────────\n"
  } >> "$logfile"
  chflags uchg "$logfile"
}

function n() {
  local file="$HOME/note.note"
  local msg=$(printf "%b" "$*")
  touch "$file"
  printf "\n\n[%s]\n%s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$msg" >> "$file"
}

alias vnote='open $HOME/.notes.log'
alias nnote='nano $HOME/.notes.log'
alias cnote='chflags nouchg $HOME/.notes.log 2>/dev/null && rm -f $HOME/.notes.log && echo "Notes cleared."'
alias opn='cat $HOME/note.note'

function dnote() {
  logfile="$HOME/.notes.log"
  id="$1"
  chflags nouchg "$logfile" 2>/dev/null || true
  awk -v id="$id" '
    BEGIN {inblock=0; target=0; skip=0}
    /^┌/ {inblock=1; target=0; skip=0}
    /^│ ID: / { if ($3 == id) target=1 }
    /^├/ { if (inblock && target) { print; print "[ĐÃ XOÁ]"; skip=1; next } }
    /^└/ { skip=0; inblock=0; target=0; print; next }
    { if (!skip) print }
  ' "$logfile" > "${logfile}.tmp" && mv "${logfile}.tmp" "$logfile"
  chflags uchg "$logfile"
}