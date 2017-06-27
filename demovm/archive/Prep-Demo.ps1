cd c:\source\vs2017demo

git stash

git checkout master
git reset 816d9487 --hard
git push -f

git checkout CodedUITest
git reset 96135fd6 --hard
git push -f

git checkout DependencyValidation
git reset 1ca13fb2 --hard
git push -f

git checkout e2e-complete
git reset a24bb398 --hard
git push -f

git checkout IntelliTest
git reset 816d9487 --hard
git push -f

git checkout LiveUnitTesting
git reset d3bb00f4 --hard
git push -f

git checkout PerfAndLoadTesting
git reset 96135fd6 --hard
git push -f

git checkout master

Write-Host "The reset of master should have triggered a build - please verify that a build has queued and don't forget to reset your Bug!" -ForegroundColor Magenta