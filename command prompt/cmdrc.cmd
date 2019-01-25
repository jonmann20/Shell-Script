:: Install this to C:\

@echo off

:: Prompt
::git.exe %*
::set GITBRANCH=for /f "tokens=2" %%I in ('git.exe branch 2^> NUL ^| findstr /b "* "') do set GITBRANCH=%%I
::echo %GITBRANCH%

set prompt=$p$_$g

:: Aliases
DOSKEY ls=dir /B
DOSKEY subl="C:\Program Files\Sublime Text 3\sublime_text.exe"
DOSKEY ..=cd ..
DOSKEY ...=cd ..\..

:: git
DOSKEY br=git branch
DOSKEY st=git status -s
DOSKEY ch=git checkout $1
DOSKEY lg=git log --graph
DOSKEY ac=git add -A $T git commit -m "$*"
DOSKEY acp=git add -A $T git commit -m "$*" $T git push

:: Startup
cd C:\workspace
dir
