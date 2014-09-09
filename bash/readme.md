bash
====

Install .my_bashrc
------------------
1. curl -o ~/.git-prompt.sh "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
2. curl -o ~/.my_bashrc "https://raw.githubusercontent.com/jonmann20/Shell-Script/master/bash/.my_bashrc"
3. sed -i '$ a\source ~/.my_bashrc' ~/.bashrc
