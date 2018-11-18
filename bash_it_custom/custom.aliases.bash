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

# Code
alias code="code --disable-gpu --new-window "

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
alias tanda-core="tmuxinator_start tanda-core "
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
alias dotfiles="code --disable-gpu --performance \"${HOME}/Code/Dombo/dotfiles\""

# Tanda
alias tanda-ssh="ssh deployer@local.tanda.co"

# Bash History
alias hgrep="history | grep --color"

# File nav
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'