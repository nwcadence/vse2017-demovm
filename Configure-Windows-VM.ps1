param
(
    [string]$workloads
)

# Set PowerShell execution policy
#Set-ExecutionPolicy RemoteSigned -Force

#Download Visual Studio Enterprise (latest)
$vs_EnterpriseUrl = "https://aka.ms/vs/15/release/vs_enterprise.exe"

$temp = "C:\Windows\Temp"
$vs_Enterprise = "$($temp)\vs_Enterprise.exe"

Invoke-WebRequest $vs_EnterpriseUrl -OutFile $vs_Enterprise

#Parse workloads for install
$workloads.Split(",[ ]{0,1}") | ForEach-Object {
    
    $workloadArgs += "--add $($_) "
}

$workloadArgs += "--quiet --norestart --wait"
$workloadParams = $workloadArgs.Split(" ")
Start-Process $vs_Enterprise $workloadParams -Wait

#Download screenshots

$snapshotFolder = "C:\SnapshotDebugging"

New-Item $snapshotFolder -ItemType Directory

$appInsightsImage = "https://github.com/nwcadence/vse2017-demovm/raw/master/partsunlimited-snapshot/appinsights-exceptions.png"
$debugSnapshotImage = "https://github.com/nwcadence/vse2017-demovm/raw/master/partsunlimited-snapshot/debugsnapshot-portal.png"

Invoke-WebRequest $appInsightsImage -OutFile "$($snapshotFolder)\appinsights-exceptions.png"

Invoke-WebRequest $debugSnapshotImage -OutFile "$($snapshotFolder)\debugsnapshot-portal.png"

#Download PowerShell scripts

$connectGitScript = "https://raw.githubusercontent.com/nwcadence/vse2017-demovm/master/Connect-Git.ps1"
$prepDemoScript = "https://raw.githubusercontent.com/nwcadence/vse2017-demovm/master/Prep-Demo.ps1"
$scriptsFolder = "C:\scripts"

New-Item $scriptsFolder -ItemType Directory

Invoke-WebRequest $connectGitScript -OutFile "$($scriptsFolder)\Connect-Git.ps1"

Invoke-WebRequest $prepDemoScript -OutFile "$($scriptsFolder)\Prep-Demo.ps1"

# Install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

refreshenv

# Install Chocolatey packages
& choco install googlechrome -y
& choco install firefox -y
& choco install poshgit -y
& choco install nodejs -y
& choco install 7zip -y

refreshenv

#Download snapshot for offline use

for ($i = 1; $i -le 7; $i++) {

    $snapshot = "partsunlimited-snapshot.zip.00$($i)"
    $snapshotUrl = "https://github.com/nwcadence/vse2017-demovm/raw/master/partsunlimited-snapshot/partsunlimited-snapshot.zip.00$($i)"
    Write-Host "Downloading partsunlimited-snapshot.zip.00$($i)"
    Invoke-WebRequest $snapshotUrl -OutFile "$($snapshotFolder)\$($snapshot)"
}

$7zipPath = "C:\Program Files\7-Zip\7z.exe"

$7zipArgs = "e $($snapshotFolder)\partsunlimited-snapshot.zip.001 -o$($snapshotFolder)"

$7zipParams = $7zipArgs.Split(" ")

Start-Process $7zipPath $7zipParams -Wait

Get-ChildItem -Path $snapshotFolder | Where-Object { $_.Extension -like "*.00*" } | foreach ($_) { Remove-Item $_.FullName }

Start-Sleep -Seconds 60
Restart-Computer