# =========================================================
# GIN SIGNATURE : gin.w.xvi.e.s
# =========================================================

# ---------------------------------------------------------
# POWERLEVEL10K INSTANT PROMPT
# MUST STAY AT TOP
# ---------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
source $ZSH/oh-my-zsh.sh
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true

# setopt append_history inc_append_history share_history
setopt autocd
setopt auto_param_slash

setopt no_case_glob no_case_match
setopt globdots
setopt extended_glob
setopt interactive_comments

bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^k" kill-line
bindkey "^j" backward-word

# =========================================================
# CORE ENV
# =========================================================

export OS_TYPE="$(uname -s)"
export ARCH_TYPE="$(uname -m)"
export RECENT_TIME="$(date +%Y-%m-%d-%H-%M-%S)"

export MAIN_PATH="$HOME/GINETSOPHIE"
export GITGINXVI_PATH="$MAIN_PATH/git-ginxvi"
export GINZSH_PATH="$GITGINXVI_PATH/ginzsh"

export CONFIG_PATH="$HOME/.config"
export ZSHRC_PATH="$HOME/.zshrc"

export GIN_SIGNATURE="gin-w-xvi-e-s"

export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LIBCLANG_PATH="/opt/homebrew/opt/llvm/lib"
export PKG_CONFIG_PATH="/opt/homebrew/opt/opencv/lib/pkgconfig"

# =========================================================
# ALIASES
# =========================================================

# local cd
alias main="cd $MAIN_PATH"
alias gingit="cd $GITGINXVI_PATH"
alias ginzsh="cd $GINZSH_PATH"
alias cf="cd $CONFIG_PATH"

# app aliases
alias m='mpv --no-video --loop-playlist=inf'

alias logx='python ~/Desktop/NF/LOGTOOL/main.py'
alias oplogx='code ~/Desktop/NF/LOGTOOL'

# global aliases
source "$GINZSH_PATH/global-aliases.zshrc"
source "$GINZSH_PATH/global-functions.zshrc"

# local aliases
source "$GINZSH_PATH/local-aliases.zshrc"

# =========================================================
# TOOLCHAINS / PACKAGE MANAGERS
# =========================================================

source "$GINZSH_PATH/brew.zshrc"
source "$GINZSH_PATH/bun.zshrc"
source "$GINZSH_PATH/cargo.zshrc"
source "$GINZSH_PATH/conda.zshrc"

# =========================================================
# DEV / UTILITIES
# =========================================================

source "$GINZSH_PATH/git.zshrc"
source "$GINZSH_PATH/web.zshrc"
source "$GINZSH_PATH/cleanup.zshrc"
source "$GINZSH_PATH/btop.zshrc"
source "$GINZSH_PATH/ollama.zshrc"
source "$GINZSH_PATH/bluetooth.zshrc"
source "$GINZSH_PATH/ghostty.zshrc"
source "$GINZSH_PATH/lich.zshrc"
source "$GINZSH_PATH/im-select.zshrc"
source "$GINZSH_PATH/temps.zshrc"
# =========================================================
# FZF
# =========================================================

# eval "$(/opt/homebrew/bin/fzf --zsh)"

# =========================================================
# EXTRA ZSH CONFIG
# =========================================================

source "$GINZSH_PATH/zshrc.zshrc"

export BINBOX="$HOME/GINETSOPHIE/opencode/rust/binbox"
export PATH="$HOME/GINETSOPHIE/opencode/rust/binbox:$PATH"
cdbb() {
  cd ~/GINETSOPHIE/opencode/rust/binbox
}
chbb() {
  mv "$BINBOX/$1" "$BINBOX/$2"
}
rmbb() {
    [[ -n "$1" ]] && rm -rf "$BINBOX/$1"
}
labb() {
  ls -la $BINBOX
}
mvbb() {
    cargo build --release &&
    cp "target/release/$(basename "$(pwd)")" "$HOME/GINETSOPHIE/opencode/rust/binbox/${1:-$(basename "$(pwd)")}"
}
# =========================================================
# POWERLEVEL10K
# =========================================================
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/Library/TeX/texbin:$PATH"
function topdf() {
    pandoc $1 -o o.pdf --pdf-engine=xelatex
}







[ -f "/Users/gc-thaitoan/.ghcup/env" ] && . "/Users/gc-thaitoan/.ghcup/env" # ghcup-env