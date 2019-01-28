:: Install this file to C:\

:: Usefull Links
::   https://www.robvanderwoude.com/ansi.php#AnsiColor

@echo off
::setlocal enableextensions

:: Aliases
DOSKEY ls = dir /B
DOSKEY which = where $*
DOSKEY .. = cd ..
DOSKEY ... = cd ..\..
DOSKEY subl = "C:\Program Files\Sublime Text 3\sublime_text.exe"

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
::set prompt=$p$_$g
set prompt=$E[1;32m$p$_$g$E[0m 

::git rev-parse --abbrev-ref HEAD > C:\workspace\gitbranch.txt
::set /p branch=<C:\workspace\gitbranch.txt
::set prompt=$p $E[1;32m%branch%$E[0m $_$g

::for /f "tokens=*" %%x in ('ver') do set branc=%%x
::echo %branc%
