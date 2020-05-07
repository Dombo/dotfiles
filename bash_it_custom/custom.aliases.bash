# Quick up one dir
alias ..="cd .. && ls -l"

# Git
alias g="git"
alias gr="git rm -rf"
alias gs="git status -su"
alias ga="git add --all"
alias gc="git commit -m"
alias gp="git push"
alias gb="git checkout -b"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# GitHub
# pr bug,enhancement,cost-saving,ready-for-review
pr() {
    hub pull-request -a dombo -l $1 | xargs firefox --new-tab
}

# tmux
# tmuxinator_start tanda-core <- for default session
# tmuxinator_start tanda-core migration-library <- for named session
tmuxinator_start() {
    if [ -z "$2" ]; then SESSION_NAME=""; else SESSION_NAME="-n $2"; fi 
    tmuxinator start $1 $SESSION_NAME
}
alias txl='tmux ls'
alias txa='tmux a -t'
alias txk='tmux kill-session -t'
alias txka='tmux kill-server'

# Clipboard
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

# SSH key helper
alias sshkey="xclip -selection clipboard < ~/.ssh/id_rsa.pub"

# Dotfiles
alias dotfiles="codium --disable-gpu \"${HOME}/Code/Dombo/dotfiles\""

# Bash History
alias hgrep="history | grep --color"

# File nav
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Kubernetes
kube_token() {
    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') | grep token: | awk '{print $2}'
}
alias ktoken="kube_token | pbcopy"

# Archives
function extract {
  if [ -z "$1" ]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
  else
    if [ -f $1 ]; then
      case $1 in
        *.tar.bz2)   tar xvjf $1    ;;
        *.tar.gz)    tar xvzf $1    ;;
        *.tar.xz)    tar xvJf $1    ;;
        *.lzma)      unlzma $1      ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar x -ad $1 ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xvf $1     ;;
        *.tbz2)      tar xvjf $1    ;;
        *.tgz)       tar xvzf $1    ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *.xz)        unxz $1        ;;
        *.exe)       cabextract $1  ;;
        *)           echo "extract: '$1' - unknown archive method" ;;
      esac
    else
      echo "$1 - file does not exist"
    fi
  fi
}
alias extr='extract '
function extract_and_remove {
  extract $1
  rm -f $1
}
alias extrr='extract_and_remove '