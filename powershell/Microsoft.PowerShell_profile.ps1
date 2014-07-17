Set-Location C:\git
#New-Alias acp git add -A && git commit -m "$1" && git push    #untested
Clear-Host

function prompt {
  #$curDir = Split-Path $(Get-Location)  -Leaf
  $fullPath = "$(Get-Location)".Replace("\","/")
  $host.ui.rawui.WindowTitle = $fullPath

  $curBranch = ""
  $doubleArrow = [char]0xBB;
  
  if(Test-Path .git) {
    $curBranch += " ("

    git branch | foreach {
      if ($_ -match "^\*(.*)"){
        $curBranch += $matches[1].trimstart(" ")
      }
    }

    $curBranch += ")"
  }

  Write-Host $fullPath -nonewline -foregroundcolor DarkCyan
  Write-Host $curBranch -nonewline -foregroundcolor Gray
  Write-Host ""
  Write-Host $doubleArrow -nonewline -foregroundcolor DarkCyan
  return " " 
}
