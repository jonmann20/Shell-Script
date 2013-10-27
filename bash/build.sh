#!/bin/bash

#---color aliases
RED=${txtbld}$(tput setaf 1)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

#---globals
phpExe="/opt/lampp/bin/php"
yuiJar="/usr/share/yui-compressor/yui-compressor.jar"

path="/home/jon/git/jonmann20.github.com/"

htmlFiles=$(find ${path} -name '*.html')
phpFiles=$(find ${path} -name '*.php')
cssFiles="normalize.css the.css" 


function deleteHTML {
	echo "----- deleting HTML -----"
	for f in $htmlFiles
	do
		ff=${f#/home/jon/git/jonmann20.github.com/} #TODO: change to path???
		fname=${ff%.*}
	
		if [[ ("$fname" == "js/computerGraphics/web/computergraphics") || "$fname" == "games/dungeon/web/dungeon" ]]
		then
			echo -e "\t $RED  -skipped $fname $RESET"	
		else
			echo -e "\t $GREEN deleting $fname $RESET"
			rm $f
		fi
		
	done
	echo ""
}

function compilePHP {
	echo "----- compiling PHP to HTML -----"

	for f in $phpFiles
	do
		ff=${f#/home/jon/git/jonmann20.github.com/} #TODO: change to path???
		fname=${ff%.*}
		
		if [[ ("$fname" == "master") || ("$fname" == "games/gamesMaster") || ("$fname" == "games/gamesNav") || ("$fname" == "music/musicNav") || ("$fname" == "playground/playgroundNav") ]]
		then
			echo -e "\t $RED -skipped $fname $RESET"
		else
			echo -e "\t $GREEN compiling $fname $RESET"
			$phpExe $f > ${path}${fname}.html
		fi
		
	done
	echo ""
}

function compressCSS {
	echo -e "----- Compressing CSS -----"
	absCssFiles=""
	
	for f in $cssFiles
	do
		echo -e "\tcombining $f"
		absCssFiles+="${path}css/$f "
	done
	
	cat $absCssFiles > ${path}css/combined.css
	
	
	echo -e "\n\tminifying combined.css --> /min/master.css";
	java -jar $yuiJar ${path}css/combined.css -o ${path}css/min/master.css
	
	echo -e "\tremoving combined.css";
	rm ${path}css/combined.css
}


function compressJsSet {	# $1= out file; $2= in files path; $3= in files
		
	echo -e "\n\t--- $1 ---"
	absJsFiles=""
	
	for f in $3
	do
		echo -e "\t\t $CYAN combining $f $RESET"
		absJsFiles+="${path}${2}js/$f "
	done
		
	echo -e "\t\t $GREEN minifying combined.js --> /min/$1 $RESET";
	cat $absJsFiles > ${path}js/combined.js
	java -jar $yuiJar ${path}js/combined.js -o ${path}js/min/$1
	
	echo -e "\t\t $RED removing  combined.js $RESET";
	rm ${path}js/combined.js
}


function compressJS {
	echo -e "\n----- Compressing JS -----"
	
	masterJsFiles="the.js analytics.js"
	bPitJsFiles="ballPit.js"
	jQuestJsFiles="utils.js gameObject.js gameItem.js enemy/enemy.js startScreen.js input.js level/level.js level/level0.js game.js hero.js main.js"

	compressJsSet "master.js" "" "$masterJsFiles"
	compressJsSet "ballPit.js" "" "$bPitJsFiles"
	compressJsSet "jonsQuest.js" "games/jonsQuest/" "$jQuestJsFiles"
}

function pushToGithub { # $1= commit msg
	echo "----- Pushing to GitHub -----"
	
	if [[ "$1" != "" ]]
	then
		git add -A
		git commit -m "$1"
	else
		git add -A
		git commit -m 'default push'
	fi
	
	git push
}
 

#----- Run Program -----

if [[ "$1" == "dev" ]]
then
	deleteHTML
elif [[ "$1" == "prd" ]]
then
	deleteHTML
	compilePHP
	compressCSS
	compressJS
	
	if [[ "$2" != "" ]]
	then
		pushToGithub "$2"
	fi
	
elif [[ "$1" == "css" ]]
then
	compressJS
elif [[ "$1" == "js" ]]
then
	compressJS
elif [[ "$1" == "push" ]]
then
	pushToGithub "$2"
else
	echo -e "\t $RED must append 'dev | prd | css | js | push' $RESET"
fi


