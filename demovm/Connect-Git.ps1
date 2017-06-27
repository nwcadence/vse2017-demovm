param
(
    [string]$sourcePath
)

Push-Location

try {

    # Test if the source folder has been initialized by Git.
    Set-Location $sourcePath
    $gitInitPath = ".git"
    $gitInitState = Test-Path $gitInitPath
    if (-not $gitInitState) {
        Write-Error "Error: Git not initialized. Please follow the instructions from the readme in GitHub to clone the repo with Visual Studio."
    }
    else {
        Write-Host "Git initialized"
    }

    git fetch
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