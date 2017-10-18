#!/bin/sh

# Setup:
# Put the following lines in .bashrc:
#
# PATH=/path/to/this/file:$PATH
# ./path/to/setup.sh | tee somefile
# . somefile
#

DOTFILEDIR=$(dirname "$0")

ECHOPATH_FILE="$DOTFILEDIR/echopath"
cat >"$ECHOPATH_FILE" <<'EOF'
#!/bin/sh
# This file is generated; don't edit by hand.

echo "$PATH" | gawk 'BEGIN {OFS="\n"; FS=":"}; {$1=$1; print}' | less
EOF
chmod +x "$ECHOPATH_FILE"

cat<<EOF
PS1='\[\033[01;33m\]\w\[\033[00m\]$ '
alias cdd='pushd $DOTFILEDIR'
alias cde='pushd ~/.emacs.d'
alias d='git diff'
alias dc='git diff --cached'
alias dirs='dirs -v'
alias em='(emacsclient -c 2>/dev/null || emacs) &'
alias gg='git grep'
alias l='ls -lAH'
alias ocaml='rlwrap ocaml'
alias s='git status || ls'
alias sbcl='rlwrap sbcl'
alias startx='startx 2>/tmp/x_stderr >/tmp/x_stdout &'
alias vv='git branch -vv'
ff () {
        if test \$# -ne 1
        then
                echo "usage: ff <pattern>"
        else
                git ls-files "*\$1*" || find . -name "*\$1*"
        fi
}
mkcdir () {
        if test \$# -ne 1
        then
                echo "usage: mkcdir <filename>"
        else
                mkdir -p -- "\$1" && cd -P -- "\$1"
        fi
}
EOF

if test -n "$CARGO_HOME"
then
        RG="$CARGO_HOME/rg --path-separator / --no-heading --line-number --pretty"
        RG1_FILE="$DOTFILEDIR/gr"
        RG2_FILE="$DOTFILEDIR/grc"
        cat >"$RG1_FILE" <<EOF
#!/bin/sh
# This file is generated; don't edit by hand.

$RG "\$@" | less -R
EOF
        chmod +x "$RG1_FILE"

        cat >"$RG2_FILE" <<EOF
#!/bin/sh
# This file is generated; don't edit by hand.

$RG "\$@"
EOF
        chmod +x "$RG2_FILE"
fi

cat >~/.inputrc <<'EOF'
#!/bin/sh
# This file is generated; don't edit by hand.

set convert-meta on

"\M-p": previous-history
"\M-n": next-history
EOF

cat >~/.sbclrc <<'EOF'
#| This file is generated; don't edit by hand. |#

(setf *read-default-float-format* 'double-float)
EOF

cat >~/.gitconfig <<'EOF'
# This file is generated; don't edit by hand.

[core]
    editor = emacs -Q\
               --eval '(defun do-commit () (interactive) (save-buffer) (kill-emacs))'\
               --eval '(defun no-commit () (interactive) (erase-buffer) (do-commit))'\
               --eval '(global-set-key (kbd \"C-c C-c\") (quote do-commit))'\
               --eval '(global-set-key (kbd \"C-c C-k\") (quote no-commit))'
    logallrefupdates = true
[gc]
    auto = 256
[user]
    name = nathan moreau
    email = nathan.moreau@m4x.org
[alias]
    ame = commit -av --amend
    ap = add -p
    bgrep = "!f() { git branch --all | grep $@; }; f"
    ch = cherry-pick
    cam = commit -av
    cm = commit -v
    co = checkout
    d = diff
    db = !git diff $(git merge-base origin/master HEAD) HEAD
    dc = diff --cached
    du = diff @{u} HEAD
    f = fetch --all --prune
    l = log --decorate --oneline --graph --color -5
    la = log --all --decorate --oneline --graph --color -5
    laa = log --all --decorate --oneline --graph --color
    ll = log --decorate --oneline --graph --color
    r1 = reset HEAD^
    remove-gone = "!f() { git branch -vv | cut -c 3- | awk '/gone/ {print $1}' | xargs -r git branch -D; }; f"
    rh= reset --hard
    root = "!f() { cd $(git rev-parse --show-toplevel); }; f"
    rw = "!f() { git checkout -b $1 origin/$1; }; f"
    sn = "!f() { git show -1 --skip=$1; }; f"
    s = status
    sup = log --decorate --oneline --graph --color HEAD..@{u}
    wc = whatchanged --oneline -5
    wcc = whatchanged --oneline
    wip = commit -am wip
    wl = worktree list --porcelain
[merge]
    tool = ediff
[mergetool "ediff"]
    cmd = emacs --eval \"(ediff-merge-files-with-ancestor \\\"$LOCAL\\\" \\\"$REMOTE\\\" \\\"$BASE\\\" nil \\\"$MERGED\\\")\"
[color "branch"]
    upstream = bold cyan
[diff]
    mnemonicprefix = true
    algorithm = patience
[pull]
    rebase = true
[push]
    default = nothing
[clean]
    requireForce = false
[color "grep"]
    linenumber = bold green
    filename = magenta
EOF
