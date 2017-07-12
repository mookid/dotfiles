#!/bin/sh

cat > ~/.bashaliases <<'EOF'
PS1="\w$ "
PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
alias s='git status'
alias d='git diff'
alias dc='git diff --cached'
alias vv='git branch -vv'
alias sbcl='rlwrap sbcl'
alias ocaml='rlwrap ocaml'
mkcdir() { if [ $# -ne 1 ]; then echo "usage: ${FUNCNAME[0]} <filename>"; else mkdir -p -- "$1" && cd -P -- "$1"; fi }
rg() { $(which rg) --path-separator / -p "$@" | less -R; }
EOF

cat > ~/.sbclrc <<'EOF'
(setf *read-default-float-format* 'double-float)
EOF

cat > ~/.gitconfig <<'EOF'
[core]
    editor = emacs -Q --eval '(global-set-key (kbd \"<escape>\") (quote kill-emacs))'
[gc]
    auto = 256
[user]
    name = nathan moreau
    email = nathan.moreau@m4x.org
[alias]
    cam = commit -avm
    ch = cherry-pick
    cm = "!f() { git diff --cached && git commit -v; }; f"
    co = checkout
    d = diff
    db = !git diff $(git merge-base origin/master HEAD) HEAD
    dc = diff --cached
    du = diff @{u} HEAD
    f = fetch --all --prune
    l = log --decorate --oneline --color -5
    la = log --all --decorate --oneline --graph --color -5
    laa = log --all --decorate --oneline --graph --color
    ll = log --decorate --oneline --color
    r1 = reset HEAD^
    rw = "!f() { git checkout -b review_$1 origin/$1; }; f"
    remove-gone = "!f() { git branch -vv | awk '/gone/ {print $1}' | xargs -r git branch -D; }; f"
    rh= reset --hard
    sn = "!f() { git show -1 --skip=$1; }; f"
    s = status
    wc = whatchanged --oneline -5
    wcc = whatchanged --oneline
    wip = commit -am wip
    wl = worktree list --porcelain
    worktree-reset = "!f() { \
        PWD_ORIG=$(pwd); \
        for wt in $(git worktree list | awk '{print $1}'); \
        do \
            cd $wt && \
            git checkout $(basename $wt) > /dev/null 2>&1 && \
            git reset --hard  > /dev/null 2>&1; \
        done; \
        cd $PWD_ORIG; \
    }; f"
[merge]
    tool = ediff
[mergetool "ediff"]
    cmd = emacs --eval \"(ediff-merge-files-with-ancestor \\\"$LOCAL\\\" \\\"$REMOTE\\\" \\\"$BASE\\\" nil \\\"$MERGED\\\")\"
[color "diff"]
    frag = magenta bold
    meta = yellow bold
    new = green bold
    old = red bold
[color "status"]
    added = yellow
[color "branch"]
    upstream = bold cyan
[diff]
    algorithm = patience
[pull]
    rebase = true
EOF
