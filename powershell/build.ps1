#--- globals
$path = "C:\git\jonmann20.github.com\";
$yuiJar = "${path}bin\yuicompressor-2.4.8.jar";
$closureJar = "${path}bin\closure.jar";

function compressCSS() {
	echo "----- Compressing CSS -----";
	
	Write-Host "`t master.css";
		$absMasterCssFiles = @();  #empty array
		
		$masterCssFiles = "normalize.css", "overrideUtils.css", "layout.css";
		
		foreach($f in $masterCssFiles){
			Write-Host "`t`t combining $f" -foregroundcolor "cyan";
			$absMasterCssFiles += "${path}css/$f";
		}
		
		Get-Content $absMasterCssFiles | Out-File -Encoding UTF8 "${path}css\combined.css";    # concatenate
		
		Write-Host "`n`t`t minifying combined.css --> /min/master.css" -foregroundcolor "green";
		iex 'java -jar $yuijar "${path}css\combined.css" > "${path}css\min\master.css"'; # minify
		
		Write-Host "`t`t removing combined.css" -foregroundcolor "gray";
		rm "${path}css/combined.css";
		
		echo "";
		
	Write-Host "`t pageJonsQuest.css";
		$absJqCssFiles = @();  #empty array
		
		$jqCssFiles = "css\normalize.css", "css\overrideUtils.css", "css\layout.css", "games\jonsQuest\css\jonsQuest.css";
		
		foreach($f in $jqCssFiles){
			Write-host "`t`t combining $f" -foregroundcolor "cyan";
			$absJqCssFiles += "${path}$f";
		}
		
		Get-Content $absJqCssFiles | Out-File -Encoding UTF8 "${path}css\combined.css";    # concatenate
		
		Write-Host "`n`t`t minifying combined.css --> /min/pageJonsQuest.css" -foregroundcolor "green";
		iex 'java -jar $yuijar "${path}css\combined.css" > "${path}css\min\pageJonsQuest.css"'; # minify
		
		Write-Host "`t`t removing combined.css" -foregroundcolor "gray";
		rm "${path}css/combined.css";
		
		echo "";
}

function compressJS() {
	echo "----- Compressing JS -----";
	
	Write-Host "`t master.js";
		$absMasterJsFiles = @();  # empty array
		
		$masterJsFiles = "analytics.js", "/plugins/sammy.js","utils.js", "/models/home.js", "/models/about.js", "/models/contact.js", "/models/favorites.js", "/models/blog.js", "/models/games.js", "/models/music.js", "/models/playground.js", "/models/portfolio.js", "routing.js", "main.js";
		
		foreach($f in $masterJsFiles){
			Write-Host "`t`t combining $f" -foregroundcolor "cyan";
			$absMasterJsFiles += "${path}js/$f";
		}
		
		Get-Content $absMasterJsFiles | Out-File -Encoding UTF8 "${path}js\combined.js";    # concatenate
		
		Write-Host "`n`t`t minifying combined.js --> /min/master.js" -foregroundcolor "green";
		#iex 'java -jar $closureJar --charset UTF-8 "${path}js\combined.js" > "${path}js\min\master.js"';  # minify (charset not working)
		
		$inFile = $path + "js\combined.js";
		$outFile = $path + "js\min\master.js";
		
		$job = start-job -scriptblock {
			& java -jar $args[0] $args[1] > $args[2]
		} -argumentlist @($closureJar, $inFile, $outFile)
		wait-job $job
		
		write-host "`t`t converting /min/master.js to utf8" -foregroundcolor "gray";
		$outContent = gc $outFile
		$outContent | Set-Content -Encoding UTF8 $outFile
		
		Write-Host "`t`t removing combined.js" -foregroundcolor "gray";
		rm "${path}js/combined.js";
		
		echo "";
		
	Write-Host "`t pageJonsQuest.js";
		$absJqJsFiles = @();  # empty array
		
		$pth = "games/jonsQuest/js/";
		
		$jqJsFiles = "js/analytics.js", 
					 "${pth}utils.js",
					 "${pth}audio/audio.js",
					 "${pth}graphics/graphics.js",
					 "${pth}physics/physics.js",
					 "${pth}engine/gameObject.js",
					 "${pth}engine/gameItem.js",
					 "${pth}enemy/enemy.js",
					 "${pth}level/startScreen.js",
					 "${pth}level/level.js",
					 "${pth}level/level0.js",
					 "${pth}engine/game.js",
					 "${pth}hero/hero.js",
					 "${pth}hero/heroGraphics.js",
					 "${pth}hero/heroPhysics.js",
					 "${pth}hero/heroInput.js",
					 "${pth}main.js"
		 ;
		
		foreach($f in $jqJsFiles){
			Write-Host "`t`t combining $f" -foregroundcolor "cyan";
			$absJqJsFiles += "${path}$f";
		}
		
		Get-Content $absJqJsFiles | Out-File -Encoding UTF8 "${path}js\combined.js";    # concatenate
		
		Write-Host "`n`t`t minifying combined.js --> /min/pageJonsQuest.js" -foregroundcolor "green";
		
		$outFile = $path + "js\min\pageJonsQuest.js";
		
		$job = start-job -scriptblock {
			& java -jar $args[0] $args[1] > $args[2]
		} -argumentlist @($closureJar, $inFile, $outFile)
		wait-job $job
		
		write-host "`t`t converting /min/pageJonsQuest.js to utf8" -foregroundcolor "gray";
		$outContent = gc $outFile
		$outContent | Set-Content -Encoding UTF8 $outFile
		
		Write-Host "`t`t removing combined.js" -foregroundcolor "gray";
		rm "${path}js/combined.js";
		
		echo "";
}

function pushOrMerge($msg, $dst) {
	echo "----- Pushing -----";
	
	if($dst -eq "prd") {
		Write-Host "`tPushing master branch";
		
		git checkout master
		git merge dev
		
		compressCSS
		compressJS
	}
	else {
		Write-Host "`tPushing dev branch";
	}
		
	Write-Host "`tTracking files";
	git add -A
		
	Write-Host "`tCommiting files";
	git commit -m $msg
		
		
	if($dst -eq "prd"){	
		git push
		git checkout dev
	}
	else {
		git push -u origin dev
	}
}


#--- Check Command Line Arguments

if($args[0] -eq "prd") {
    if($args[1]){
        pushOrMerge $args[1] "prd"
    }
	else {
		Write-Host "Must append commit message" -foregroundcolor "red";
	}
}
elseif($args[0] -eq "css") {
    compressCSS
}
elseif($args[0] -eq "js") {
    compressJS
}
elseif($args[0] -eq "dev") {
	if($args[1]){
		pushOrMerge $args[1] ""
	}
	else {
		Write-Host "Must append commit message" -foregroundcolor "red";
	}
}
else {
    compressCSS
	compressJS
}
