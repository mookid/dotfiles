#!/bin/sh

# Setup:
# Execute with the option --init.

case $1 in
        --init)
                BASHRC="$HOME/.bashrc"
                DOTFILE=$(readlink -f "$0")
                DOTFILEDIR=$(readlink -f $(dirname "$0"))
                cat >>"$BASHRC" <<EOF
## {{{ This part of .bashrc has been generated.
if  test -z \$DOTFILES_DIR_IN_PATH
then
        export DOTFILEDIR=$DOTFILEDIR
        export PATH=\$DOTFILEDIR:\$PATH
        export DOTFILES_DIR_IN_PATH=1
fi

. $DOTFILE
## }}}
EOF
                exit 0
                ;;

        --reset)
                BASHRC="$HOME/.bashrc"
                BASHRC_TMP=$(mktemp)
                awk '/## {{{/ {FILTER=1}
                    {if(!FILTER) print}
                    /## }}}/ {FILTER=0} ' "$BASHRC" >"$BASHRC_TMP"
                mv "$BASHRC_TMP" "$BASHRC"
                exit 0
                ;;
esac

PS1='\[\033[01;33m\]\w\[\033[01;32m\][$?]\[\033[01m\]\[\033[01;37m\]$\[\033[00m\] '
alias cdd='pushd $DOTFILEDIR'
alias cde='pushd $EMACSD'
alias cdp='pushd $PROJECTS'
alias d='git diff'
alias dc='git diff --cached'
alias dirs='dirs -v'
alias em='(emacsclient -c 2>/dev/null || emacs) &'
alias gg='git grep'
alias l='ls -lAH'
alias ocaml='rlwrap ocaml'
alias p='echo $?'
alias s='git status || ls'
alias sbcl='rlwrap sbcl'
alias startx='startx 2>/tmp/x_stderr >/tmp/x_stdout &'
alias vv='git branch -vv'
mkcdir () {
        if test $# -ne 1
        then
                echo "usage: mkcdir <filename>"
        else
                mkdir -p -- "$1" && cd -P -- "$1"
        fi
}

if command -v openbox >/dev/null
then
        OPENBOX_CONFIG="$HOME/.config/openbox"
        mkdir -p "$OPENBOX_CONFIG"
        find "$OPENBOX_CONFIG" -maxdepth 1 -type f -name "*.xml" |\
                while read -r file
                do
                        cp -f "$DOTFILEDIR/openbox.xml" "$file"
                done
        openbox --reconfigure
fi

find "$DOTFILEDIR/dotfiles" -type f -exec cp '{}' "$HOME" \;
