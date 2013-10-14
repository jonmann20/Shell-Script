# set up profile
# 
# Test-Path $profile
# if return False
# 	New-Item -path $profile -type file –force
#
# C:\Users\<user>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# 

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
