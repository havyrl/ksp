# Config


# Script
#work in directory
$baseDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
Write-host "My directory is $baseDir"
Push-Location $baseDir

if((get-process "KSP_x64" -ea SilentlyContinue) -eq $Null) { 
    git pull origin
}

$changes = (git status --short)
$changesMeasure = $changes  | Measure-Object 
$changesCount = $($changesMeasure.count)

if ($changesMeasure.count -gt 0) {
    echo "backup changes"
    git add -A
    git commit -m "automatic backup"
    git push origin
}


#switch back
Pop-Location 