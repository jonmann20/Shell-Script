bash
====

Install .my_bashrc
------------------
1. cd ~
2. curl -o my_bashrc "https://raw.githubusercontent.com/jonmann20/Shell-Script/master/bash/.my_bashrc"
3. Add to .bashrc // TODO: figure out export
```
if [ -f ~/.my_bashrc ]; then
  . ~/.my_bashrc
fi
```
