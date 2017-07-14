param
(
    [string]$workloads,
    [string]$version
)

# Set PowerShell execution policy
#Set-ExecutionPolicy RemoteSigned -Force

if($version -eq "Preview")
{
    $vs_EnterpriseUrl = "https://aka.ms/vs/15/pre/vs_enterprise.exe"
}
else
{
    $vs_EnterpriseUrl = "https://aka.ms/vs/15/release/vs_enterprise.exe"
	$version = "RTM"
}
    
#Download Visual Studio Enterprise (latest)


$temp = "C:\Windows\Temp"
$vs_Enterprise = "$($temp)\vs_Enterprise-$($version).exe"

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

$appInsightsImage1 = "https://github.com/nwcadence/vse2017-demovm/raw/ready2017/bikesharing360-snapshot/appinsights-failedrequests.png"
$appInsightsImage2 = "https://github.com/nwcadence/vse2017-demovm/raw/ready2017/bikesharing360-snapshot/appinsights-opendebugsnapshot.png"
$downloadSnapshotImage = "https://github.com/nwcadence/vse2017-demovm/raw/ready2017/bikesharing360-snapshot/appinsights-downloadsnapshot.png"

Invoke-WebRequest $appInsightsImage1 -OutFile "$($snapshotFolder)\appinsights-failedrequests.png"

Invoke-WebRequest $appInsightsImage2 -OutFile "$($snapshotFolder)\appinsights-opendebugsnapshot.png"

Invoke-WebRequest $downloadSnapshotImage -OutFile "$($snapshotFolder)\appinsights-downloadsnapshot.png"

# Install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

refreshenv

# Install Chocolatey packages
& choco install firefox -y
& choco install poshgit -y
& choco install nodejs -y
& choco install 7zip -y

refreshenv

#Download snapshot for offline use

for ($i = 1; $i -le 6; $i++) {

    $snapshot = "bikesharing360-snapshot.zip.00$($i)"
    $snapshotUrl = "https://github.com/nwcadence/vse2017-demovm/raw/ready2017/bikesharing360-snapshot/bikesharing360-snapshot.zip.00$($i)"
    Write-Host "Downloading bikesharing360-snapshot.zip.00$($i)"
    Invoke-WebRequest $snapshotUrl -OutFile "$($snapshotFolder)\$($snapshot)"
}

$7zipPath = "C:\Program Files\7-Zip\7z.exe"

$7zipArgs = "e $($snapshotFolder)\bikesharing360-snapshot.zip.001 -o$($snapshotFolder)"

$7zipParams = $7zipArgs.Split(" ")

Start-Process $7zipPath $7zipParams -Wait

Get-ChildItem -Path $snapshotFolder | Where-Object { $_.Extension -like "*.00*" } | foreach ($_) { Remove-Item $_.FullName }

#Download Google Chrome

$chromeUrl = "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi"

$chrome = "$($temp)\chrome_installer.msi"

Invoke-WebRequest -Uri $chromeUrl -OutFile $chrome

$installer = "msiexec.exe"

$chromeArgs = "/q /I $($chrome)"

$chromeParams = $chromeArgs.Split(" ")

Start-Process $installer $chromeParams -Wait

$defaultBrowserArgs = "--make-default-browser"

& "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" $defaultBrowserArgs

Start-Sleep -Seconds 60
Restart-Computer -Force