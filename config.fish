set -gx EXTENTS_PATH /home/thewisenerd/works/dotfiles

set -gx USE_CCACHE 1
set -gx CCACHE_DIR /home/thewisenerd/.ccache
set -gx EDITOR nano

set __fish_git_prompt_showdirtystate 'yes'

alias ls "ls --color=auto"
alias dir "dir --color=auto"
alias grep "grep --color=auto"
alias fgrep "fgrep --color=auto"
alias egrep "egrep --color=auto"

alias pls "sudo"
alias .. "cd .."

alias gpik 'git cherry-pick'
alias gpikab 'git cherry-pick --abort'
alias gaddall 'git add --all'
alias gadd 'git add'
alias gbranch 'git branch -v'
alias gstat 'git status'
alias gcmt 'git commit'
alias gcommit 'git commit'
alias gpush 'git push'
alias glog 'git log'
alias gshow 'git show'
alias grvt 'git revert'
alias uncommit 'git reset --soft HEAD^'
alias gdiff 'git diff'

alias abd 'adb'

set -gx PATH {$EXTENTS_PATH}/bin {$PATH}

source {$EXTENTS_PATH}/fish_functions/extents_android.fish
