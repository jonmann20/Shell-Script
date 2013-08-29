Set-Location C:\git\jonmann20.github.com

New-Alias bild .\build.ps1

function prompt {
	$count = -1;
	$tokens = @();  #empty array

	"$pwd".Split('\') | ForEach {
		++$count;
		$tokens += "$_";
	}

	$curDir = $tokens[$count];
	$arr = [char]0xBB;
	
	"$curDir $arr "
}

Clear-Host
