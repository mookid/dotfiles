#!/bin/sh

cat > ~/.bashaliases <<EOF
PS1="\w$ "
alias s='git status'
alias d='git diff'
alias dc='git diff --cached'
alias vv='git branch -vv'
EOF

cat > ~/.gitconfig <<EOF
[core]
editor = emacs -Q --eval '(progn (push (cons (quote font) \"Consolas 16\") default-frame-alist) (global-set-key (kbd \"<escape>\") (quote kill-emacs)))'
[gc]
    auto = 256
[user]
    name = nathan moreau
    email = nathan.moreau@m4x.org
[alias]
    cam = commit -am
    ch = cherry-pick
    cm = "!f() { git diff --cached && git commit; }; f"
    co = checkout
    d = diff
    db = !git diff \$(git merge-base origin/master HEAD) HEAD
    dc = diff --cached
    f = fetch --all --prune
    l = log --decorate --oneline --color -5
    la = log --all --decorate --oneline --graph --color -5
    laa = log --all --decorate --oneline --graph --color
    ll = log --decorate --oneline --color
    r1 = reset HEAD^
    rw = "!f() { git checkout -b review_\$1 origin/\$1; }; f"
    rh= reset --hard
    sn = show --name-only
    s = status
    wc = whatchanged --oneline -5
    wcc = whatchanged --oneline
    wip = commit -am wip
    wl = worktree list
[merge]
    tool = ediff
[mergetool "ediff"]
    cmd = emacs --eval \"(ediff-merge-files-with-ancestor \\\\\"\$LOCAL\\\\\" \\\\\"\$REMOTE\\\\\" \\\\\"\$BASE\\\\\" nil \\\\\"\$MERGED\\\\\")\"
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
EOF
