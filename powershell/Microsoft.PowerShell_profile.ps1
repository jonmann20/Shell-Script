Set-Location C:\git
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
  Write-Host $curBranch -nonewline -foregroundcolor DarkYellow
  Write-Host ""
  Write-Host $doubleArrow -nonewline -foregroundcolor DarkCyan
  return " " 
}

function acp {
  cmd /c git add -A; git commit -m "$args"; git push
}

function pgb {
  phonegap build android
}

function pgr {
  phonegap run android
}
