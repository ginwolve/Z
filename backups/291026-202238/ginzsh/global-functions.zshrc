timefo() {
  local name
  name=$(date +"%Y-%m-%d_%H-%M-%S")
  mkdir "$name"
  echo "folder $name"
}

timefi() {
  local name
  name=$(date +"%Y-%m-%d_%H-%M-%S")
  touch "$name"
  echo "file $name"
}

bu() {
    echo 'backup';
    cp $1 $1.bak
}