# Quick up one dir
alias ..="cd .. && ls -l"

# Git
alias g="git"
alias gr="git rm -rf"
alias gs="git status -su"
alias ga="git add --all"
alias gc="git commit -m"
alias gp="git push"

# GitHub
alias pr="hub pull-request | xargs firefox --new-tab"

# Clipboard
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

# SSH key helper
alias sshkey="xclip -selection clipboard < ~/.ssh/id_rsa.pub"

# Dotfiles
alias dotfiles="code \"${HOME}/Code/Dombo/dotfiles\""

# Tanda
alias tanda-ssh="ssh deployer@local.tanda.co"