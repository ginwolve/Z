alias s="echo 'source' && source"
alias c="echo 'clear' && clear"
alias e="echo 'exit' && exit"
alias r="echo 'rm -rf' && rm -rf"
alias p="echo 'pwd' && pwd"
alias b='bat --color=always --style=plain --line-range=:500 -p'
alias l="echo 'ls -ac' && ls -ac"

alias sr="echo 'sudo rm -rf' && sudo rm -rf"
alias la="echo 'ls -alh' && ls -alh"
alias ea="echo 'eza -alh' && eza -alh"
alias nn='nano note'
alias cn='cat note'
alias bn='bat note'
alias en='echo "$1" >> note'

alias cp.='pwd | pbcopy'

alias own="echo 'sudo chown $(whoami):$(id -gn)' && sudo chown $(whoami):$(id -gn)"
alias ownall="echo 'sudo chown -R $(whoami):$(id -gn)' && sudo chown -R $(whoami):$(id -gn)" 