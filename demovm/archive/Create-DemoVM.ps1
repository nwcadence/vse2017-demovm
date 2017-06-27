param(
    [parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [parameter(Mandatory=$true)]
    [ValidateSet('East US','East US 2','West US','Central US','North Central US','South Central US','North Europe','West Europe','East Asia','Southeast Asia','Japan East','Japan West','Australia East','Australia Southeast','Brazil South','Canada Central','Canada East','West US 2','West Central US','UK South','UK West')]
    [string]$Location,

    [parameter(Mandatory=$true)]
    [string]$GloballyUniqueVMName,

    [parameter(Mandatory=$true)]
    [string]$GloballyUniqueStorageAccName,

    [parameter(Mandatory=$true)]
    [string]$VMSize,

    [parameter(Mandatory=$false)]
    [string]$UrlToExistingVhd = "https://cdvse2017disks504.blob.core.windows.net/backup/vse2017.vhd"
)

function Login-AzureRMIfNotLoggedIn() {
    $Error.Clear()
    Get-AzureRmContext -ErrorAction SilentlyContinue
    foreach ($e in $Error) {
        if ($e.Exception -like "*Run Login-AzureRmAccount*") {
            Login-AzureRmAccount
        }
    }
}
Login-AzureRMIfNotLoggedIn

$ErrorActionPreference = "Stop"
Import-Module Azure.Storage

Write-Host "Create Resource Group" -ForegroundColor Yellow
$exists = (Get-AzureRmResourceGroup | ? { $_.ResourceGroupName -eq $ResourceGroupName }).Count
if ($exists -eq 0) {
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location
}

Write-Host "Create storage account and container" -ForegroundColor Yellow
$exists = ($storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName | ? { $_.StorageAccountName -eq $GloballyUniqueStorageAccName }).Count
if ($exists -eq 0) {
    $storageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $GloballyUniqueStorageAccName -SkuName Standard_LRS -Location $Location
}
$storageAccKeys = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $GloballyUniqueStorageAccName
$storageAccContext = New-AzureStorageContext -StorageAccountName $GloballyUniqueStorageAccName -StorageAccountKey $storageAccKeys[0].Value

$exists = ($vhdContainer = Get-AzureStorageContainer -Context $storageAccContext | ? { $_.Name -eq "vhds" }).Count
if (-not ($exists)) {
    $vhdContainer = New-AzureStorageContainer -Name "vhds" -Context $storageAccContext
}

Write-Host "Copy vhd to storage account" -ForegroundColor Yellow
$destBlobName = "$GloballyUniqueVMName-os.vhd"

$demoVhdUri = "https://$GloballyUniqueStorageAccName.blob.core.windows.net/vhds/$destBlobName"
$exists = (Get-AzureStorageBlob -Container $vhdContainer.Name -Context $storageAccContext | ? { $_.Name -eq $destBlobName}).Count
if ($exists -eq 0) {
    $copyJob = Start-AzureStorageBlobCopy -SrcUri $UrlToExistingVhd -DestContainer $vhdContainer.Name -DestContext $vhdContainer.Context -DestBlob $destBlobName -Force

    # wait for the copy to complete
    Write-Host "Waiting for copy job to complete" -ForegroundColor Yellow
    $copyJob | Get-AzureStorageBlobCopyState -WaitForComplete
}

Write-Host "Creating VM" -ForegroundColor Yellow
New-AzureRmResourceGroupDeployment -Name "create-demo-vm" -ResourceGroupName $ResourceGroupName -TemplateFile "./demovm.json" -TemplateParameterFile "./demovm.parameters.json" -virtualMachineName $GloballyUniqueVMName -storageAccountName $GloballyUniqueStorageAccName -demoVhdUri $demoVhdUri

$loc = $Location.Replace(" ", "").ToLower();
$vmDnsName = "$GloballyUniqueVMName.$loc.cloudapp.azure.com"
Write-Host "Done!" -ForegroundColor Green

""
Write-Host "To login, RDP to $vmDnsName and use the following credentials:" -ForegroundColor Cyan
Write-Host "   username: vsts" -ForegroundColor Yellow
Write-Host "   password: P@ssw0rdDemo" -ForegroundColor Yellow
""
Write-Host "Make sure to run the once-off setup steps to hook up the agent and the source repo to your VSTS account!" -ForegroundColor Magenta
""