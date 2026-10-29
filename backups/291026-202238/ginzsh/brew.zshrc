alias buuc='brew update && brew upgrade && brew cleanup'

brewls() {
    brew leaves | while read f; do
  size=$(du -sh "$(brew --cellar)/$f" 2>/dev/null | cut -f1)
  printf "%-10s %s\n" "$size" "$f"
done | sort -h
}

brewlsall() {
    brew list --cask | while read c; do
  path="/Applications/${c}.app"
  if [ -d "$path" ]; then
    size=$(du -sh "$path" 2>/dev/null | cut -f1)
    printf "%-10s %s\n" "$size" "$c"
  fi
done | sort -h
}