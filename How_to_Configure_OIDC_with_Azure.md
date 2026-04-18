

### Prerequisit.

1. Install the [Azure CLI (v 2.30.0+)](https://docs.microsoft.com/cli/azure/install-azure-cli)
```sh
# Verify Azure Cli Version
az --version
```
3. Login to Azure CLI `az login`
4. Make sure correct sub is set with `az account show`, `az account set`
5. Install [GitHub CLI](https://github.com/cli/cli) or [Direct GitHub CLI install](https://medium.com/@rabeehco/how-to-install-and-setup-github-cli-on-windows-cdf16115dc04)- To create the secrets
```bash
# Verify Verson
gh --version

# Login
gh auth login
```
6. Install [Gitbash](https://git-scm.com/install/windows)

7. Install jq

   - Download the Windows binary from:
    ```sh
    https://stedolan.github.io/jq/download/
    # Download jq-windows-amd64.exe
    ```

   - Rename it and place it in a directory that's on your PATH. The recommended approach:

    ```powershell   
    # Create a tools folder if it doesn't exist
    New-Item -ItemType Directory -Force -Path "C:\tools"
    
   # Move/rename the downloaded file
   Move-Item "$env:USERPROFILE\Downloads\jq-windows-amd64.exe" "C:\tools\jq.exe"

   # Add C:\tools to system PATH permanently
   [System.Environment]::SetEnvironmentVariable(
     "Path",
     $env:Path + ";C:\tools",
     [System.EnvironmentVariableTarget]::Machine
   )
    ```
    Restart your PowerShell session, then verify:

    ```powershell   
    jq --version
    ```
<!-- 8. envsubst (via Git for Windows)

   - envsubst is not natively available on Windows. The easiest way to get it is via Git for Windows:

   - Download and install Git for Windows from:
    ```sh
   https://git-scm.com/download/win
    ```
Add Git's usr\bin to your system PATH:

```powershell   [System.Environment]::SetEnvironmentVariable(
     "Path",
     $env:Path + ";C:\Program Files\Git\usr\bin",
     [System.EnvironmentVariableTarget]::Machine
   )
```
Restart PowerShell and verify:

```powershell   
envsubst --version
``` -->

./oidc.sh demo-github-azure-oidc-connection mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC ./fics.json

```bash
$ ./oidc.sh demo-github-azure-oidc-connection mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC ./fics.json
Checking Azure CLI login status...
 ]DevOpsLearning"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
Do you want to use the above subscription? (Y/n) y
Getting Subscription Id...
SUB_ID: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Getting Tenant Id...
TENANT_ID: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Configuring application...
Existing AD app found.
APP_ID: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Configuring Service Principal...
First checking if the Service Principal already exists...
Existing Service Principal found.
SP_ID: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Creating Federated Identity Credentials...

Creating FIC with subject 'repo:mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC:pull_request'.
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#applications('b833d726-0eae-42dd-8f63-1fb0151b8cfb')/federatedIdentityCredentials/$entity",
  "audiences": [
    "api://AzureADTokenExchange"
  ],
  "description": "pr",
  "id": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "issuer": "https://token.actions.githubusercontent.com",
  "name": "prfic",
  "subject": "repo:mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC:pull_request"
}
Creating FIC with subject 'repo:mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC:ref:refs/heads/main'.
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#applications('b833d726-0eae-42dd-8f63-1fb0151b8cfb')/federatedIdentityCredentials/$entity",
  "audiences": [
    "api://AzureADTokenExchange"
  ],
  "description": "main",
  "id": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "issuer": "https://token.actions.githubusercontent.com",
  "name": "mainfic",
  "subject": "repo:mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC:ref:refs/heads/main"
}
Creating FIC with subject 'repo:mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC:ref:refs/heads/master'.
{
  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#applications('b833d726-0eae-42dd-8f63-1fb0151b8cfb')/federatedIdentityCredentials/$entity",
  "audiences": [
    "api://AzureADTokenExchange"
  ],
  "description": "master",
  "id": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "issuer": "https://token.actions.githubusercontent.com",
  "name": "masterfic",
  "subject": "repo:mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC:ref:refs/heads/master"
}
Creating the following GitHub repo secrets...
AZURE_CLIENT_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
AZURE_SUBSCRIPTION_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
AZURE_TENANT_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Logging into GitHub CLI...
? Where do you use GitHub? GitHub.com
? What is your preferred protocol for Git operations on this host? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: 81BA-6D8D
Press Enter to open https://github.com/login/device in your browser...
✓ Authentication complete.
- gh config set -h github.com git_protocol https
✓ Configured git protocol
✓ Logged in as mrsingh_xxx
! You were already logged in to this account
✓ Set Actions secret AZURE_CLIENT_ID for mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC
✓ Set Actions secret AZURE_SUBSCRIPTION_ID for mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC
✓ Set Actions secret AZURE_TENANT_ID for mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC

Administrator@WIN2025 MINGW64 ~/GitHub-Action-Azure_OpenID_Connect-OIDC (main)

```
Assign Contributor Role via Azure Portal GUI

Step 1 — Go to your Subscription

Open https://portal.azure.com
In the top search bar, type "Subscriptions" and click it
learn.microsoft.comdocs.azure.cnlearn.microsoft.comResults from the web
Click on your subscription named "DevOpsLearning"


Step 2 — Open Access Control (IAM)

In the left-hand menu of your subscription, click "Access control (IAM)"
You will see the IAM dashboard


Step 3 — Add Role Assignment

Click the "+ Add" button at the top
Select "Add role assignment" from the dropdown


Step 4 — Select the Contributor Role

You will land on the "Role" tab
In the search box, type Contributor
Click on "Contributor" from the list to select it
Click "Next" at the bottom


Step 5 — Assign Access to your Service Principal

On the "Members" tab:

Under "Assign access to" → select "User, group, or service principal"
Click "+ Select members"


In the search panel that opens on the right:

Type the App name: demo-github-azure-oidc-connection
OR paste the App ID: ff4d5216-a213-4c7e-8715-e1fa9da58da3


Click on it when it appears in the results to select it
Click "Select" at the bottom of the panel


Step 6 — Review and Assign

Click "Next" to go to the Review + assign tab
Confirm the details:

FieldExpected ValueRoleContributorAssigned todemo-github-azure-oidc-connectionScopeYour subscription (DevOpsLearning)

Click "Review + assign" button (you may need to click it twice)


Step 7 — Verify the Assignment

Stay on the Access Control (IAM) page
Click the "Role assignments" tab
In the search box, type demo-github-azure-oidc-connection
You should see:

NameRoleTypeScopedemo-github-azure-oidc-connectionContributorServicePrincipalSubscription

Step 8 — Re-run Your GitHub Actions Pipeline

Go to your GitHub repo:

   https://github.com/mrbalraj007/GitHub-Action-Azure_OpenID_Connect-OIDC

Click Actions tab
Select your workflow "Run Azure Login with OpenID Connect"
Click "Run workflow" → "Run workflow"


⏱️ Tip: Wait 2–3 minutes after assigning the role before re-running the pipeline. Azure role propagation is not instant.

```bash
Quick Visual Path Summary
portal.azure.com
  └── Subscriptions
        └── DevOpsLearning
              └── Access Control (IAM)
                    └── + Add → Add role assignment
                          ├── Role tab       → Select "Contributor"
                          ├── Members tab    → Select "demo-github-azure-oidc-connection"
                          └── Review + assign → Confirm ✅
```











--Ref Link
 - YouTube Link
   - [Connect to Azure from a GitHub Action with OpenID Connect (OIDC)](https://www.youtube.com/watch?v=IKuw9T6vZYU&list=PLJcpyd04zn7qSRKw6ROGuObYTE1iJoH20&index=4)
