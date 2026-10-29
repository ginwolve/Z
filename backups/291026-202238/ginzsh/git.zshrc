# alias gacp='git add . && git commit -m "$GIN_SIGNATURE" && git push'
alias gs='git status'

gacp() {
  git add . &&
  git commit -m "${1:-$GIN_SIGNATURE}" &&
  git push
}

mkrepo() {
  local name="$1"
  local vis="--private"
  [[ -z "$name" ]] && { echo "Thiếu tên repo"; return 1; }
  [[ "$2" == "-p" ]] && vis="--public"
  [[ -d "$name" ]] && { echo "Thư mục đã tồn tại"; return 1; }
  mkdir "$name" && cd "$name" || return 1
  git init
  echo "# $name" > README.md
  git add .
  git commit -m "init"
  gh repo create "$name" $vis --source=. --remote=origin --push
  echo "$name ($vis) done"
}
