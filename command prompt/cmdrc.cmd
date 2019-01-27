:: Install this file to C:\

@echo off

:: Aliases
DOSKEY ls = dir /B
DOSKEY subl = "C:\Program Files\Sublime Text 3\sublime_text.exe"
DOSKEY .. = cd ..
DOSKEY ... = cd ..\..

:: git
DOSKEY br = git branch
DOSKEY st = git status -s
DOSKEY ch = git checkout $1
DOSKEY lg = git log --graph
DOSKEY ac = git add -A $T git commit -m "$*"
DOSKEY acp = git add -A $T git commit -m "$*" $T git push

:: Startup
cd C:\workspace
dir

:: Prompt
set prompt=$E[7;32;47m$p$_$g$E[0m

::git rev-parse --abbrev-ref HEAD > C:\workspace\gitbranch.txt
::set /p branch=<C:\workspace\gitbranch.txt

::set prompt=$p $E[7;32;47m%branch%$E[0m $_$g
::DOSKEY cd = cd $* $T set prompt=$p
