#!/bin/sh

usage() {
cat <<EOF
usage:
      --setup                   run the setup script
      --install                 add setup code to .bashrc
      --uninstall               remove setup code from .bashrc
      --help                    print this help message
EOF
}

# locations
BASHRC="$HOME/.bashrc"
OPENBOX_CONFIG="$HOME/.config/openbox"
GIT_CONFIG="$HOME/.config/git"
DOTFILES_DIRECTORY="$SCRIPTS_REPOSITORY/dotfiles"
export GITHUBPROJECTS="$HOME/src"

case $1 in
        --help)
                usage
                exit 0
                ;;

        --install)

                cat >>"$BASHRC" <<EOF
## {{{ This part of .bashrc has been generated.
if  test -z \$SCRIPTS_REPOSITORY_IN_PATH
then
        export SCRIPTS_REPOSITORY=\
\${HOME}/$(realpath --relative-to=${HOME} $(readlink -f $(dirname $0)))
        export PATH=\$SCRIPTS_REPOSITORY:\$PATH
        export SCRIPTS_REPOSITORY_IN_PATH=1
fi

. \${SCRIPTS_REPOSITORY}/setup.sh --setup
## }}}
EOF
                exit 0
                ;;

        --uninstall)
                BASHRC_TMP=$(mktemp)
                awk '/## {{{/ {FILTER=1}
                    {if(!FILTER) print}
                    /## }}}/ {FILTER=0} ' "$BASHRC" >"$BASHRC_TMP"
                mv "$BASHRC_TMP" "$BASHRC"
                exit 0
                ;;

        --setup)
                ;;

        *)
                usage
                exit 2
                ;;
esac

PROMPT_COMMAND=__update_error_code
__update_error_code() {
        LAST_ERROR_CODE=$?
        PS1_PREFIX='\[\033[01;33m\]\w'
        PS1_ERROR=
        PS1_SUFFIX='\[\033[01;37m\]\$ \[\033[0m\]'
        if test $LAST_ERROR_CODE -ne 0
        then
                PS1_ERROR="\\[\\033[01;31m\\][$LAST_ERROR_CODE]"
        fi
        PS1="$PS1_PREFIX$PS1_ERROR$PS1_SUFFIX"
}

export HISTCONTROL=ignoreboth:erasedups
CDPATH="$HOME"
CDPATH="$GITHUBPROJECTS:$CDPATH"
alias ..='cd ..'
alias ...='cd ../..'
alias cdd='pushd $SCRIPTS_REPOSITORY'
alias cde='pushd $HOME/.emacs.d'
alias d='git d'
alias dc='git dc'
alias dirs='dirs -v'
alias e='emacs . &'
alias gg='git grep'
alias grep='grep --color'
alias l='ls --color -lAh'
alias ls='ls --color'
alias ocaml='rlwrap ocaml'
alias p='popd'
alias s='git status || ls'
alias sbcl='rlwrap sbcl'
alias startx='startx 2>/tmp/x_stderr >/tmp/x_stdout &'
mkcdir () {
        if test $# -ne 1
        then
                echo "usage: mkcdir <filename>"
        else
                mkdir -p -- "$1" && cd -P -- "$1"
        fi
}

man() {
        env \
                LESS_TERMCAP_mb="$(printf "\\e[1;31m")" \
                LESS_TERMCAP_md="$(printf "\\e[1;31m")" \
                LESS_TERMCAP_me="$(printf "\\e[0m")" \
                LESS_TERMCAP_se="$(printf "\\e[0m")" \
                LESS_TERMCAP_so="$(printf "\\e[1;44;33m")" \
                LESS_TERMCAP_ue="$(printf "\\e[0m")" \
                LESS_TERMCAP_us="$(printf "\\e[1;32m")" \
                man "${@}"
}

github() {
        if $(which github) "$@"
        then
                pushd "$GITHUBPROJECTS/$(basename "$1" .git)"
        fi
}

mkdir -p "$GIT_CONFIG"
mkdir -p "$OPENBOX_CONFIG"

find "$OPENBOX_CONFIG" -maxdepth 1 -type f -name "*.xml" |\
while read -r file
do
        cp --force "$DOTFILES_DIRECTORY/openbox.xml" "$file"
done

cp --force "$DOTFILES_DIRECTORY/.emacs.git" "$HOME/.emacs.git"
cp --force "$DOTFILES_DIRECTORY/.gitconfig" "$HOME/.gitconfig"
cp --force "$DOTFILES_DIRECTORY/.inputrc" "$HOME/.inputrc"
cp --force "$DOTFILES_DIRECTORY/.minttyrc" "$HOME/.minttyrc"
cp --force "$DOTFILES_DIRECTORY/.sbclrc" "$HOME/.sbclrc"
cp --force "$DOTFILES_DIRECTORY/openbox.xml" "$OPENBOX_CONFIG/openbox.xml"

if command -v openbox >/dev/null
then
        openbox --reconfigure
fi
