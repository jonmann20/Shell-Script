#---------- Prompt ----------#
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
# %~ is the current working directory with $HOME replaced by '~' 
NEWLINE=$'\n'

# git branch
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats "(%b)"
precmd() {
	vcs_info
}
setopt prompt_subst


# prompt colors
autoload -U colors && colors

# NOTE: prompt must use single quotes for vcs_info to work!
prompt='%~ %{$fg[green]%}% ${vcs_info_msg_0_} %{$reset_color%}% ${NEWLINE}» '


#---- Mac OS specific aliases ----#
alias ls='ls -G'
alias ll='ls -alG'
alias subl='open -a "Sublime Text"'


#
# TODO: just auto load .bashrc and override with above commands??
# Below is copied from bash/.bashrc
# Keep in sync.
#

#---------- Aliases/Functions ----------#
#-- System
alias cls='clear'					# adds new lines
alias clr='printf "\ec"'	# actually clears screen
alias .='pwd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias sleep='sudo pm-suspend'
alias reboot='sudo reboot'
alias poweroff='sudo poweroff'
alias bashrc='subl -n ~/.Shell-Script/bash/.bashrc'
alias trash='nautilus trash://'
alias listppa='grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/*'
alias list_ip='/sbin/ifconfig'
alias dusage='sudo du -a / | sort -n -r | head -n 20'
alias workspace='cd ~/workspace'

# Docker/Docker Compose/Kubernetes
alias d=docker
alias dc='docker compose'
alias k=kubectl
#\t{{.ID}} \t{{.Ports}}
alias dps='d ps --format "table {{.Names}}\t{{.Status}}"'
alias dpsi='d ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"'

update_dc() {
	dc version
	DESTINATION=~/.docker/cli-plugins/docker-compose
	VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
	echo "Downloading $VERSION"
	sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-linux-x86_64 -o $DESTINATION
	sudo chmod 755 $DESTINATION
	dc version
}

dshl() {
	d ps -l --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"
	d exec -it $(d ps -lq) /bin/bash
}

dsh() {
  if [ "$1" == "api" ]; then
      d exec -it gepetto_platform_external_web_api_1 /bin/bash
  elif [ "$1" == "ui" ]; then
  	d exec -it gepetto_platform_external_web_ui_1 /bin/bash
  elif [ "$1" == "gql" ]; then
  	d exec -it gepetto_platform_external_graphql_1 /bin/bash
	elif [ "$1" == "bootstrap" ]; then
		d exec -it gepetto_bootstrap_1 /bin/bash
  else
      d exec -it $1 /bin/bash
  fi
}

dshg() {
	# e.g. dbash platform_external_web_api
	# --> gepetto_platform_external_web_api_1
	d exec -it "gepetto_$1_1" /bin/bash
}

dog() {
	# sudo apt install python-pygments
	pygmentize $1 | perl -e 'print ++$i." $_" for <>'
}

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

	#TODO: allow filenames with spaces
	#TODO: show percentage of folder (use `calc`)
	# last modified [-t], reverse [-r]

	if [ "$1" == "size" ]; then
		sort_by=$(du -sh * | sort -h | cut -f2)
	else
		sort_by=$(ls -tr)
	fi

	for file in $sort_by
	do
		if [ -d $file ]			# directory
		then
			filename="${LIGHT_BLUE}$file${RESET}"
		else
			filename="${LIGHT_GRAY}$file${RESET}"
		fi

		# last modified
		# NOTE: was adding an newline when combined
		weekday=$(date -d "$(stat -c '%z' $file)" +"%a")
		day=$(date -d "$(stat -c '%z' $file)" +"%e")
		month=$(date -d "$(stat -c '%z' $file)" +"%b")
		time1=$(date -d "$(stat -c '%z' $file)" +"%l:%M")
		period=$(date -d "$(stat -c '%z' $file)" +"%P")

		size=$(du -sh $file | cut -f1)
		lastChar="${size: -1}"
		size="${size::-1}"

		if [ "$lastChar" == "K" ]; then
			ucolor="${GREEN}"
		elif [ "$lastChar" == "M" ]; then
			ucolor="${YELLOW}"
		elif [ "$lastChar" == "G" ]; then
			ucolor="${RED}"
		else
			ucolor="${LIGHT_GRAY}"
		fi

		units="${lastChar}B"

		printf -v result "%-35b %-3s %2s %-6s %5s %-5s %3s %2s\n" $filename $weekday $day $month $time1 $period $size $ucolor$units${RESET}
		buff+=$result
	done
	totalSize=$(du -sh . | cut -f1)
	totalSizeLastChar="${totalSize: -1}"
	totalSize="${totalSize::-1}"
	units="${totalSizeLastChar}B"
	echo -e "total size: $totalSize $units\n$buff\c"
}

ljs() {
	lj "size"
}

ljt() {
	lj "time"
}

#-- Ruby on Rails
# List Ruby on Rails commands
rr() {
	echo "All commands use bundle exec bin/"
	echo "d: database - rake db:drop, create, migrate, seed"
	echo "s: server - rails server"
	echo "c: console - rails console"
	echo "t: test - rspec"
}

rr.d() {
	echo "Dropping db"
	bundle exec bin/rake db:drop

	echo "Creating db"
	bundle exec bin/rake db:create

	echo "Migrating db"
	bundle exec bin/rake db:migrate

	echo "Seeding db"
	bundle exec bin/rake db:seed
}

rr.s() {
	echo "Running web server"
	bundle exec bin/rails server
}

rr.c() {
	echo "Running rails console"
	bundle exec bin/rails console
}

rr.t() {
	echo "Running tests"
	bundle exec bin/rspec
}

alias bspec='bin/rspec'

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

#-- Node.js
kns() {
	killall -9 node
	echo 'finished'
}

# npm i -g check-outdated
outdated() {
	check-outdated --columns name,current,wanted,latest
}
outdatedc() {
	check-outdated --columns name,current,latest,changes
}

#-- Git
alias br='git branch'
alias st='git status -s'
alias sw='git switch $1'
alias ch='sw'
alias lg='git log --graph --pretty=format:"%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias mend='git commit --amend -m "$@"'
alias prb='git pull --rebase'
alias prs='git pull --recurse-submodules'
alias gitk='gitk --all &'
alias ac='git add -A; git commit -m "$@"'

acp() {
	git add -A
	git commit -m "$@"
	git push
}

# Vars
export HISTTIMEFORMAT="%a %h %d, %r » "

#---------- Startup commands ----------#
cd ~/workspace
cls
ls -1tr
