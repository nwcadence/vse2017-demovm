# Ready 2017 - Virtual Machine Setup

This is the repository for the Ready 2017 demo.

There are two components for the demo:
- Windows VM workstation (Windows Server 2016 Datacenter) that contains Visual Studio 2017 (15.3), Chrome, Firefox, Git, and other dependencies
- Visual Studio Team Services project and Azure components for the deployment of the BikeSharing360 app

This walkthrough will help you set up the workstation (Azure Virtual Machine) that will use an Azure Resource Management (ARM) template and install/configure dependencies.

**Tasks**

1. Create the Virtual Machine
2. Install the Snapshot Debugger Extension for Visual Studio
3. Create the Visual Studio Team Services project
4. Clone the BikeSharing360 repository from VSTS

## Task 1: Create the Virtual Machine
    
1. Create the Virtual Machine
    
    Simply click the Deploy to Azure button below and follow the wizard to create a VM. You will need to log in to the Azure Portal.

	<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnwcadence%2Fvse2017-demovm%2Fready2017%2Fdemovm-template.json" target="_blank">
		<img src="http://azuredeploy.net/deploybutton.png"/>
	</a>
	<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fnwcadence%2Fvse2017-demovm%2Fready2017%2Fdemovm-template.json" target="_blank">
		<img src="http://armviz.io/visualizebutton.png"/>
	</a>

2. Specify settings for the deployment

	Specify settings in the ARM template:
	- Azure subscription
	- Resource group
	- Location
	- VM DNS name for Public IP
	- Visual Studio Version (Default is Preview)
	- Virtual Machine size
	- Visual Studio Workloads ([workloads and component IDs](https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-enterprise))
	- Admin username
	- Admin password
                                                                     
3. Deploy the ARM template and configure dependencies

	After filling in the appropriate settings, click on the checkbox to agree to terms and conditions, then click on the "Purchase" button to deploy the ARM template. 

	The deployment process may take around 30 minutes to complete. Once the deployment finishes, you may connect to the machine in an RDP session from the Azure Portal. 

## Task 2: Install the Snapshot Debugger Extension for Visual Studio

1. Download the Snapshot Debugger extension from the Visual Studio Marketplace

	Log into the demo VM through an RDP session and open up a browser through the RDP session on the demo VM. Then, navigate
 	to the [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=SnapshotDebuggerTeam.MicrosoftSnapshotDebugger) and click the "Download" button to download the Snapshot Debugger extension onto the demo VM.

**Note**: By going to the Visual Studio Marketplace, this will download the latest version of the extension.

<img src = "images/download-snapshotdebugger.png" />

2. Install the Snapshot Debugger extension

	Once the extension (.vsix) file has been downloaded, double-click on the file and click the "Install" button to install it. 

<img src = "images/install-snapshotdebugger.png" />

3. And that's it! The Snapshot Debugger extension should be installed for use in Visual Studio Enterprise. 

<img src = "images/install-snapshotdebugger-success.png" />

## Task 3: Create the Visual Studio Team Services project

1. Create the VSTS project

For VSTS, you can either

- Use the devopsconferences account but you will have only read-only access to the project.
- Choose to provision the project to your own VSTS account with [VSTS Demo Data Generator](http://vstsdemogenerator.azurewebsites.net/Account/Verify?template=BikeSharing360).

2. Keep track of the name of the VSTS account as well as the project.

## Task 4: Clone the BikeSharing360 repository from VSTS

1. Connect to a project

Log back into the demo VM and open up Visual Studio 2017. Connect to a VSTS project by clicking on the plug icon in the Team Explorer panel, clicking on the "Manage Connections" hyperlink, then clicking on the "Connect to Project" button that pops up. 

<img src = "images/connect-to-project.png" />

2. Log into the VSTS account 

The "Connect to a Project" panel should appear, so click ont the dropdown next to "Add an account..." and click on the "Add an account..." button to add a new VSTS account. You may have to add the corresponding browser pages to trusted sites when you are prompted to log in (or turn off enhanced security configuration in Internet Explorer). Log into the appropriate VSTS account using your Microsoft account or organizational account. 

<img src = "images/add-an-account.png" />

**Note**: If you run into issues with Javascript being blocked or getting to the log in page, you may want to either set a different browser as the default (search for "default browser" in the start menu) or turn off Internet Explorer Enhanced Security Configuration (just for this demo) from Server Explorer.

3. Clone the repository

Once you are logged in using your Microsoft or organizational account, select the VSTS account, then the project, then expand the arrow to the left of the project name and select the "BikeSharing360" repository. Specify the path that you want to clone the repository onto the demo VM such as `C:\source\VS2017Demo` (default is `C:\Users\vmadmin\Source\Repos\BikeSharing360`) then press the "Clone" button. Keep track of the source path that you have chosen as you will need it in Task 5. 

<img src = "images/clone-repo.png" />

4. After you have cloned the repository, Team Explorer should show a successful banner that the repository was cloned successfully. 

<img src = "images/clone-repo-success.png" />

5. Double-click on the 01_Public_Web_Site.sln to open the solution. At the top of Visual Studio, click the button with the green arrow to run the web application in Google Chrome (or another browser). Once you ensure that the solution builds and runs successfully, you can stop the debugging session (but keep the solution open).

<img src = "images/run-mybikes.web.png" />


