#!/bin/bash

set -e

INSTRUCTIONS="You can probably run this with no options, on OSX. Options:

 -n  Set the machine nickname. Defaults to 'local'.
 -d  Set the users' directory location. Defaults to '/Users' for OSX.
     DO NOT include your actual user directory at the end. See '-u'.
 -s  Set the source directory (that is, where this file is stored).
     Defaults to your current working directory.
 -u  Set the user. Defaults to your username, '`whoami`'.
 -q  Quiet mode (no output on success)."

SRC=$PWD
USER_DIR="/Users"
USER=`whoami`
NICK="local"

# options with a colon after them expect an
# argument, which is stored in $OPTARG
while getopts ":s:d:u:n:q" opt; do
  case $opt in
    s)
      # assign a's value to a variable
      SRC="$OPTARG"
      ;;
    d)
      USER_DIR="$OPTARG"
      ;;
    u)
      USER="$OPTARG"
      ;;
    n)
      NICK="$OPTARG"
      ;;
    q)
      QUIET=true
      ;;
    ?)
      echo "$INSTRUCTIONS"
      exit
      ;;
  esac
done

n=1
while [ $# -gt 0 ]; do
  if [ $n -lt $OPTIND ]; then
    # remove (shift) option arguments
    # until they are all gone
    let n=$n+1
    shift
  else
    break;
  fi
done

if [ $# -gt 0 ]; then
  echo "$INSTRUCTIONS"
  exit
fi

## WHERE IT ALL GOES DOWN
echo "$NICK" > $USER_DIR/$USER/.machine_nickname

ln -fns $SRC/bash/bashrc $USER_DIR/$USER/.bashrc
ln -fns $SRC/bash/bash_profile $USER_DIR/$USER/.bash_profile
ln -fns $SRC/bash/functions $USER_DIR/$USER/.functions
ln -fns $SRC/inputrc $USER_DIR/$USER/.inputrc

cp -f   $SRC/git/gitconfig $USER_DIR/$USER/.gitconfig
ln -fns $SRC/git/gitignore $USER_DIR/$USER/.gitignore

mkdir -p $USER_DIR/$USER/.vim-tmp/undo
ln -fns $SRC/vim/vimrc $USER_DIR/$USER/.vimrc
ln -fns $SRC/vim/UltiSnips $USER_DIR/$USER/.vim/UltiSnips

ln -fns $SRC/ack/ackrc $USER_DIR/$USER/.ackrc

ln -fns $SRC/ag/agignore $USER_DIR/$USER/.agignore

ln -fns $SRC/tmux/tmux.conf $USER_DIR/$USER/.tmux.conf

ln -fns $SRC/tmate/tmate.conf $USER_DIR/$USER/.tmate.conf

ln -fns $SRC/ruby/gemrc $USER_DIR/$USER/.gemrc

if [ ! -d "$USER_DIR/$USER/bin" ]; then
  mkdir $USER_DIR/$USER/bin
fi
ln -fns $SRC/bin/ts $USER_DIR/$USER/bin/ts
ln -fns $SRC/bin/t  $USER_DIR/$USER/bin/t
ln -fns $SRC/bin/kt $USER_DIR/$USER/bin/kt

tic $SRC/xterm-256color-italic.terminfo
tic $SRC/tmux.terminfo
# AND THAT'S IT, REALLY

if [ -z $QUIET ]; then
  echo "Success! Check it out:"
  ls -ld $USER_DIR/$USER/.machine_nickname $USER_DIR/$USER/.bashrc $USER_DIR/$USER/.bash_profile $USER_DIR/$USER/.functions $USER_DIR/$USER/.inputrc $USER_DIR/$USER/.gitconfig $USER_DIR/$USER/.gitignore $USER_DIR/$USER/.vim-tmp $USER_DIR/$USER/.vimrc $USER_DIR/$USER/.vim/UltiSnips $USER_DIR/$USER/.ackrc $USER_DIR/$USER/.agignore $USER_DIR/$USER/.tmux.conf $USER_DIR/$USER/.tmate.conf $USER_DIR/$USER/.gemrc $USER_DIR/$USER/bin/ts $USER_DIR/$USER/bin/t $USER_DIR/$USER/bin/kt
  echo "
  Notice that .gitconfig is not symlinked, since your git username is set in .extra (see readme)"
fi
