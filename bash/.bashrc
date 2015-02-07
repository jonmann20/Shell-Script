#---------- Prompt ----------#
LIGHT_GRAY="\[\033[0;37m\]"
DARK_GRAY="\[\033[1;30m\]"
CYAN="\[\033[0;36m\]"
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
alias ebashrc='subl ~/.Shell-Script/bash/.bashrc'

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
		lm2=$(date -d "$(stat -c '%z' $file)" +"%d")
		lm3=$(date -d "$(stat -c '%z' $file)" +"%b")
		lm4=$(date -d "$(stat -c '%z' $file)" +"%I:%M")
		lm5=$(date -d "$(stat -c '%z' $file)" +"%p")

		size=$(du -sh $file | cut -f1)

		printf -v result "%-34b %-3s %-2s %-6s %-4s %-8s %s\n" $filename $last_modified $lm2 $lm3 $lm4 $lm5 $size
		buff+=$result
	done

	echo -e "$buff\c"
}

#-- C/C++
# gnu89 for EECS 370
# std=c11 for normal

# Compile and run a single c file
c() {
	#if [ "$2" = "err" ]; then
	#	flags="-Wall -Wextra"
	#fi

	file=$1
	rm $file
	gcc -std=gnu89 -fdiagnostics-color -Wall -Wextra ${file}.c -o $file
	./${file}
}
alias cc='g++ -std=c++14 -fdiagnostics-color -Wall -Wextra $@'

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

#-- Sublime
# List sublime projects
lsp() {
	for file in ~/Documents/Sublime/*.sublime-project; do
		filename=$(basename "$file")
		filename="${filename%.*}"
		echo "$filename"
	done
}

# Open/create a sublime project
sp() {
	file=$1
	subl --project ~/Documents/Sublime/${file}.sublime-project
}

#---------- Startup commands ----------#
cd ~/git
clr
lj
