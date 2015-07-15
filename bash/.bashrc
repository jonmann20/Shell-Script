#---------- Prompt ----------#
LIGHT_GRAY="\[\033[0;37m\]"
DARK_GRAY="\[\033[1;30m\]"
CYAN="\[\033[0;36m\]"
RED="\033[0;31m"
#YELLOW="\[\033[1;33m\]"
#LIGHT_CYAN="\[\033[1;36m\]"

PS1="${CYAN}\w${DARK_GRAY}\$(__git_ps1)${CYAN}\n» ${LIGHT_GRAY}"

#---------- Aliases/Functions ----------#
#-- System
alias cls='clear'				# adds new lines
alias clr='printf "\ec"'		# actually clears screen
alias .='pwd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias sleep='sudo pm-suspend'
alias reboot='sudo reboot'
alias poweroff='sudo poweroff'
alias dog='pygmentize -g $@'	# sudo apt-get install python-pygments
alias bashrc='subl -n ~/.Shell-Script/bash/.bashrc'
alias trash='nautilus trash://'
alias listppa='grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/*'
alias list_ip='/sbin/ifconfig'

md() {
  test -e $1 || mkdir $1; cd $1;
}

rebash() {
	source ~/.bashrc
	cd -
	clr
}

vivify() {
	sudo apt-get update --yes
	sudo apt-get upgrade --yes
	sudo apt-get dist-upgrade --yes
	sudo update-manager
}

# Custom list command
lj() {
	LIGHT_GRAY='\e[1;37m'
	LIGHT_BLUE='\e[1;34m'
	RESET='\e[m' # No Color

	buff=''

	# sort by last modified (reversed)
	for file in $(ls -tr)
	do
		if [ -d $file ]			# directory
		then
			filename="${LIGHT_BLUE}$file${RESET}"
		else
			filename="${LIGHT_GRAY}$file${RESET}"
		fi

		# NOTE: was adding an newline when combined
		last_modified=$(date -d "$(stat -c '%z' $file)" +"%a")
		lm2=$(date -d "$(stat -c '%z' $file)" +"%e")
		lm3=$(date -d "$(stat -c '%z' $file)" +"%b")
		lm4=$(date -d "$(stat -c '%z' $file)" +"%l:%M")
		lm5=$(date -d "$(stat -c '%z' $file)" +"%P")

		size=$(du -sh $file | cut -f1)

		printf -v result "%-34b %-3s %2s %-6s %5s %-5s %6s\n" $filename $last_modified $lm2 $lm3 $lm4 $lm5 $size
		buff+=$result
	done
	totalSize=$(du -sh . | cut -f1)
	echo -e "total size: $totalSize\n$buff\c"
}

#-- HTML
initHTML() {
	if [ "$1" ]; then
		file=$1".html"
	else
		file="index.html"
	fi

	if [ -e $file ]; then
		echo "File $file already exists"
	else
		cat >> $file <<EOF
<!DOCTYPE html>
<html>
<head>
	<title></title>
</head>
<body>

</body>
</html>
EOF
	fi
}

#-- C/C++
c() {
	file=$1
	gcc -std=c11 -fdiagnostics-color -Wall -Wextra ${file}.c -lm -o $file
	./${file}
}
alias cc='g++ -std=c++14 -fdiagnostics-color -Wall -Wextra $@'

initC() {
	if [ "$1" ]; then
		file=$1".c"
	else
		file="main.c"
	fi

	if [ -e $file ]; then
		echo "File $file already exists"
	else
		cat >> $file <<EOF
#include <stdio.h>

int main() {
	printf("Hello World\n");
}
EOF
	fi
}

initCpp() {
	if [ "$1" ]; then
		file=$1".cpp"
	else
		file="main.cpp"
	fi

	if [ -e $file ]; then
		echo "File $file already exists"
	else
		cat >> $file <<EOF
#include <iostream>
using namespace std;

int main(int argc, char* argv[]) {
	cout << "Hello World" << endl;
	return 0;
}
EOF
	fi
}

#-- Ruby on Rails
# List Ruby on Rails commands
rr() {
	echo "All commands use bundle exec"
	echo "d: database - rake db:drop, create, migrate, seed"
	echo "s: server - rails server"
	echo "c: console - rails console"
	echo "t: test - rspec"
}

rr.d() {
	echo "Dropping db"
	bundle exec rake db:drop

	echo "Creating db"
	bundle exec rake db:create

	echo "Migrating db"
	bundle exec rake db:migrate

	echo "Seeding db"
	bundle exec rake db:seed
}

rr.s() {
	echo "Running web server"
	bundle exec rails server
}

rr.c() {
	echo "Running rails console"
	bundle exec rails console
}

rr.t() {
	echo "Running tests"
	bundle exec rspec
}

# Run hound on file
rbcop() {
	if [ $# -eq 1 ]; then
		rubocop -c .rubocop.yml $1
	elif [ $# -eq 2 ]; then
		num=$2
		rubocop -c .rubocop.yml $1 | grep -A2 ":${num}" | sed '/^--$/d' | sed 's/^.*C: //'
	else
		echo "usage: rbcop <filename> <linenumber (optional)>"
	fi
}

rs() {
	LOG_LVL_WARN=true rails s
}

rakedb() {
	case $1 in
	    1)
			rake db:drop
			;;
	    2)
	        rake db:drop
	        rake db:create
	        ;;
	    3)
	        rake db:drop
	        rake db:create
	        rake db:migrate
	        ;;
	    *)
	        rake db:drop
	        rake db:create
	        rake db:migrate
	        rake db:seed
	esac
}

#-- Git
alias st='git status -s'
alias ch='git checkout $1'
alias lg='git log --graph --pretty=format:"%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias mend='git commit --amend -m "$@"'
alias ac='git add -A; git commit -m "$@"'

acp() {
	git add -A
	git commit -m "$@"
	git push
}

acpp() {
	git add -A
	git commit -m "$@"
	git pull
	git push
}

gps() {
	grunt prd
	git push
}

gph() {
	grunt prd
	git push heroku
}

#-- Sublime
# List sublime projects
lsp() {
	echo "Available Sublime Projects:"

	for file in ~/Documents/Sublime/*.sublime-project; do
		filename=$(basename "$file")
		filename="${filename%.*}"
		echo -e "\t$filename (Documents)"
	done

	for file in ~/git/**/*.sublime-project; do
		filename=$(basename "$file")
		filename="${filename%.*}"
		echo -e "\t$filename (git)"
	done
}

# Open a sublime project
sp() {
	fname=$1

	if [ "${fname: -1}" == "/" ]; then
		fname="${fname::-1}"
	fi

	dfile=~/Documents/Sublime/${fname}.sublime-project
	gfile=$(find ~/git -name "$fname".sublime-project)

	if [ ! -f $dfile ]; then
		if [ ! -f $gfile ] || [ -z $gfile ]; then
			echo -e "${RED}This project does not exist\n${LIGHT_GRAY}"
			lsp
		else
			subl -n --project $gfile
		fi
	else
		subl -n --project $dfile
	fi
}

#-- EECS 370
alias lca='~/git/eecs370/lc2k/bin/assemble'
alias lcs='~/git/eecs370/lc2k/bin/simulate'
alias lcf='~/git/eecs370/lc2k/bin/fsm'
alias lcp='~/git/eecs370/lc2k/bin/pipeline'
alias lcc='~/git/eecs370/lc2k/bin/cachesim'

#---------- Startup commands ----------#
cd ~/git
clr
lj
