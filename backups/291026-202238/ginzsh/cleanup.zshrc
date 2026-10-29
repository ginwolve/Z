alias ducli='du -sh /opt/homebrew/Cellar/* 2>/dev/null | sort -hr | head -50'
alias ducask='du -sh /opt/homebrew/Caskroom/* 2>/dev/null | sort -hr | head -50'
alias duapp='du -sh /Applications/* 2>/dev/null | sort -hr | head -50'
alias cleantrash='[ -n "$(ls -A ~/.Trash 2>/dev/null)" ] && sudo rm -rf /Volumes/Macintosh\ HD/.Trashes/$(id -u)/* && echo "🧹 Cleaned" || echo "✅ No trash anymore"'