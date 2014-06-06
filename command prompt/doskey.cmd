@ECHO off

::git config --global credential.helper "cache --timeout=3600"

DOSKEY ls=dir

:: ^& allows multiple commands in a macro
:: $1 - $9 are paramaters
:: acp "my commit msg <9 words or truncated"
DOSKEY acp=git add -A ^& git commit -m $1 $2 $3 $4 $5 $6 $7 $8 $9 ^& git push
DOSKEY confl=git diff --name-only --diff-filter=U
DOSKEY ryam=git reset HEAD pubspec.yaml