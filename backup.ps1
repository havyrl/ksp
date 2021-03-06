# Config
$remote = "origin"
$author = "Backup Script <automaticScript@doNotReply.invalid>"

# Script
#work in directory
$baseDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
Write-host "My directory is $baseDir"
Push-Location $baseDir

# config git
git config --global push.default current
git config --global pull.default current

# fetch changes
git fetch $remote --prune

# pull changes if KSP not run
if((get-process "KSP_x64" -ea SilentlyContinue) -eq $Null) { 
    echo "pull backup"
    git pull origin
}

$changes = (git status --short)
$changesMeasure = $changes  | Measure-Object 
$changesCount = $($changesMeasure.count)

if ($changesMeasure.count -gt 0) {
    echo "backup changes"
    git add -u
    git add -A
    git commit -m "automatic backup"--author="$($author)" 
    git push -q $remote 
}

#switch back
Pop-Location 