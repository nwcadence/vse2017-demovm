param(
    [string]$VSTSAccountName,
    [string]$VSTSProjectName
)

Push-Location

try {
    # Test if the source directory exists. If not, create it
    $sourcePath = "c:\source\vs2017demo"
    $sourceState = Test-Path $sourcePath
    if(-not $sourceState){
        New-Item $sourcePath -ItemType Directory
        Write-Host "$sourcePath was created."
    }
    else {
        Write-Host "$sourcePath already exists"
    }

    # Test if the source folder has been initialized by Git and do so if has not been.
    Set-Location c:\source\vs2017demo
    $gitInitPath = ".git"
    $gitInitState = Test-Path $gitInitPath
    if (-not $gitInitState) {
        git init
    }
    else {
        Write-Host "Git already initialized"
    }


    git remote rm origin
    git remote add origin "https://$VSTSAccountName.visualstudio.com/DefaultCollection/$VSTSProjectName/_git/$VSTSProjectName"

    git fetch --all
    git checkout --track -b CodedUITest origin/CodedUITest
    git checkout --track -b DependencyValidation origin/DependencyValidation
    git checkout --track -b e2e-complete origin/e2e-complete
    git checkout --track -b IntelliTest origin/IntelliTest
    git checkout --track -b LiveUnitTesting origin/LiveUnitTesting
    git checkout --track -b PerfAndLoadTesting origin/PerfAndLoadTesting

    git pull --all
    git branch -a
    git checkout master
    git branch master --set-upstream-to origin/master
}
finally {
    Pop-Location
}