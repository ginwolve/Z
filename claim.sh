# chmod +x claim.sh

DIR="$HOME/Z/backups/$(date +%d%m%y-%H%M%S)"
mkdir -p "$DIR"
cp "$HOME/.zshrc" "$DIR/"
cp -R "$HOME/GINETSOPHIE/git-ginxvi/ginzsh" "$DIR/"
echo "Files copied to: $DIR"

