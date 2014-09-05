#---------- Prompt ----------#
# Load in the git branch prompt script.
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# May 19, 2014
source ~/.git-prompt.sh

LIGHT_GRAY="\[\033[0;37m\]"
LIGHT_CYAN="\[\033[1;36m\]"

PS1="${LIGHT_GRAY}\W${LIGHT_CYAN}\$(__git_ps1)${LIGHT_GRAY}\n» "

#---------- Aliases ----------#
# not working
alias acp=git add -A && git commit -m "$@" && git push

#---------- Startup commands ----------#
cd ~/git
clear
