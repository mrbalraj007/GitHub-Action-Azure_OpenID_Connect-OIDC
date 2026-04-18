# How to Configure OIDC with Azure

---

## Prerequisites

1. Install the [Azure CLI (v2.30.0+)](https://docs.microsoft.com/cli/azure/install-azure-cli)

   ```sh
   # Verify Azure CLI version
   az --version
   ```

2. Log in to Azure CLI

   ```sh
   az login
   ```

3. Make sure the correct subscription is set

   ```sh
   az account show
   az account set
   ```

4. Install the [GitHub CLI](https://github.com/cli/cli) — needed to create the repo secrets.
   *(Alternative install guide for Windows: [Direct GitHub CLI install](https://medium.com/@rabeehco/how-to-install-and-setup-github-cli-on-windows-cdf16115dc04))*

   ```bash
   # Verify version
   gh --version

   # Log in
   gh auth login
   ```

5. Install [Git Bash](https://git-scm.com/install/windows)

6. Install `jq`

   - Download the Windows binary from [https://stedolan.github.io/jq/download/](https://stedolan.github.io/jq/download/) — grab `jq-windows-amd64.exe`

   - Rename it and place it somewhere on your PATH. Here's the recommended approach:

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

   - Restart your PowerShell session, then verify:

     ```powershell
     jq --version
     ```

---

## Create an OIDC Connector Automatically

Run the script with your app name, GitHub repo, and FICs JSON file:

```sh
./oidc.sh demo-github-azure-oidc-connection mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC ./fics.json
```
<img width="300" height="150" alt="Image" src="https://github.com/user-attachments/assets/00bd9373-d945-41df-b52f-ed2cf5b53b63" />


<details>
<summary><b>▶ Expected output</b></summary>

```bash
$ ./oidc.sh demo-github-azure-oidc-connection mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC ./fics.json
Checking Azure CLI login status...
]Learning_Dev_OPS"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
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

</details>

---

## Pipeline Error — Missing Role Assignment

I ran into an error while running the pipeline. Turns out the Service Principal wasn't assigned a role on the subscription. Here's the fix.

![Pipeline error screenshot](https://github.com/user-attachments/assets/9515536e-7b22-43d5-90d1-87b2fa520b76)

<details>
<summary><b>🔍 Useful commands to inspect your app registration</b></summary>

<br>

**Get App Registration details**
```bash
az ad app list --filter "displayName eq 'demo-github-azure-oidc-connection'" -o table
```

**Get just the App ID**
```bash
az ad app list --filter "displayName eq 'demo-github-azure-oidc-connection'" --query [].appId -o tsv
```

**Get the Service Principal details**
```bash
az ad sp list --filter "displayName eq 'demo-github-azure-oidc-connection'" -o table
```

**Get just the Service Principal Object ID**
```bash
az ad sp list --filter "displayName eq 'demo-github-azure-oidc-connection'" --query [].id -o tsv
```

**Get everything in one shot (App ID + SP ID + Tenant)**
```bash
az ad sp list --filter "displayName eq 'demo-github-azure-oidc-connection'" \
  --query "[].{DisplayName:displayName, AppId:appId, SPObjectId:id}" \
  -o table
```

**Verify Federated Credentials are attached**
```bash
APP_ID=$(az ad app list --filter "displayName eq 'demo-github-azure-oidc-connection'" --query [].appId -o tsv)
az ad app federated-credential list --id $APP_ID --query "[].{Name:name, Subject:subject}" -o table
```

**Verify Role Assignment**
```bash
SP_ID=$(az ad sp list --filter "displayName eq 'demo-github-azure-oidc-connection'" --query [].id -o tsv)
az role assignment list --assignee $SP_ID --query "[].{Role:roleDefinitionName, Scope:scope}" -o table
```

> 💡 All these commands work in Git Bash on Windows Server 2025. Make sure you're logged in via `az login` before running them.

</details>

---

## Fix — Manually Assign the Role (CLI)

Run the following in Git Bash on your Windows Server 2025:

**Step 1 — Set your known values**

```bash

SP_ID="a778aa7b-f9e2XXXX"  # Finding SUB_ID (Subscription ID)
SUB_ID="2fc598a4-XXXX"     # Finding SP_ID (Service Principal Object ID)
```

**Step 2 — Check if a role assignment already exists**

```bash
az role assignment list \
  --assignee $SP_ID \
  --subscription $SUB_ID \
  --query "[].{Role:roleDefinitionName, Scope:scope}" \
  -o table
```

If the output is empty, the role is missing — proceed to Step 3.

**Step 3 — Assign the Contributor role**

```bash
az role assignment create \
  --role contributor \
  --subscription $SUB_ID \
  --assignee-object-id $SP_ID \
  --assignee-principal-type ServicePrincipal
```

Expected output:

```json
{
  "principalId": "a778aa7b-f9e2XXXX",
  "principalType": "ServicePrincipal",
  "roleDefinitionName": "Contributor"
}
```

> [!IMPORTANT]
> Wait 2–3 minutes, then re-run your GitHub Actions pipeline. Azure role assignments can take a moment to propagate.

---

## Fix — Assign Contributor Role via Azure Portal (GUI)

If you prefer clicking through the portal instead, here's the step-by-step.

**Step 1 — Go to your Subscription**

- Open [https://portal.azure.com](https://portal.azure.com)
- In the top search bar, type **Subscriptions** and click it
- Click on your subscription named **Learning_Dev_OPS**

**Step 2 — Open Access Control (IAM)**

- In the left-hand menu, click **Access control (IAM)**
- You'll land on the IAM dashboard

**Step 3 — Add Role Assignment**

- Click the **+ Add** button at the top
- Select **Add role assignment** from the dropdown

**Step 4 — Select the Contributor Role**

- On the **Role** tab, type `Contributor` in the search box
- Click **Contributor** to select it
- Click **Next**

**Step 5 — Assign Access to your Service Principal**

- On the **Members** tab, under *Assign access to* → select **User, group, or service principal**
- Click **+ Select members**
- In the search panel on the right, type either:
  - App name: `demo-github-azure-oidc-connection`
  - Or paste the App ID: `ff4d5216XXXX`
- Click on it when it appears, then click **Select**

**Step 6 — Review and Assign**

- Click **Next** to reach the *Review + assign* tab
- Confirm the details look right:

| Field       | Expected Value                    |
|-------------|-----------------------------------|
| Role        | Contributor                       |
| Assigned to | demo-github-azure-oidc-connection |
| Scope       | Learning_Dev_OPS (Subscription)   |

- Click **Review + assign** (you may need to click it twice)

**Step 7 — Verify the Assignment**

- Stay on the **Access control (IAM)** page
- Click the **Role assignments** tab
- Search for `demo-github-azure-oidc-connection`

You should see:

| Name                              | Role        | Type             | Scope        |
|-----------------------------------|-------------|------------------|--------------|
| demo-github-azure-oidc-connection | Contributor | ServicePrincipal | Subscription |

**Step 8 — Re-run Your GitHub Actions Pipeline**

- Go to your GitHub repo: `https://github.com/mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC`
- Click the **Actions** tab
- Select the workflow **Run Azure Login with OpenID Connect**
- Click **Run workflow** → **Run workflow**

> ⏱️ **Tip:** Wait 2–3 minutes after assigning the role before triggering the pipeline. Azure role propagation is not instant.

---

## Quick Reference

**Portal navigation path:**

```
portal.azure.com
  └── Subscriptions
        └── Learning_Dev_OPS
              └── Access Control (IAM)
                    └── + Add → Add role assignment
                          ├── Role tab       → Select "Contributor"
                          ├── Members tab    → Select "demo-github-azure-oidc-connection"
                          └── Review + assign → Confirm ✅
```

**Full setup overview:**

```
Azure AD App Registration
  └── Service Principal
        ├── Contributor Role → Subscription (Learning_Dev_OPS)  ✅
        └── Federated Identity Credentials
              ├── mainfic   → refs/heads/main                   ✅
              ├── masterfic → refs/heads/master                 ✅
              └── prfic     → pull_request                      ✅

GitHub Repo Secrets
  ├── AZURE_CLIENT_ID       ✅
  ├── AZURE_SUBSCRIPTION_ID ✅
  └── AZURE_TENANT_ID       ✅

ci.yml
  └── azure/login@v1 with OIDC (no passwords/keys)             ✅
```


## Delete OIDC connection
🧭 How to Run the Delete Script in Your Console

1️⃣ Save the script to a file
Create a new file named:
```sh
delete-oidc-app.sh
# Paste the script content into it.
```
2️⃣ Make the script executable
In your terminal, navigate to the folder where the script is saved, then run:
```sh
chmod +x delete-oidc-app.sh
```
This gives the script permission to run.

3️⃣ Run the script with required arguments
The script expects:
```sh
APP_NAME — the Azure AD application name
REPO — GitHub repo in the form ORG/REPO

Example:

# Dru Run
 ./delete-oidc-app.sh demo-github-azure-oidc-connection mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC --dry-run

 #Normal Run
 ./delete-oidc-app.sh demo-github-azure-oidc-connection mrsingh_xxx/GitHub-Action-Azure_OpenID_Connect-OIDC
```
That’s it — the script will:

  - Log into Azure (if needed) 
  - Find the app 
  - Delete FICs  
  - Delete role assignments  
  - Delete the service principal  
  - Delete the Azure AD application  
  - Delete GitHub secrets

🧪 Want to test before deleting?

You can run a dry run by checking what will be deleted:

Check if the app exists
```sh
az ad app list --filter "displayName eq 'ghazoidc1'" --query "[].appId"
```
Check service principal
```sh
az ad sp list --filter "appId eq '<APP_ID>'" --query "[].id"
```
Check FICs
```sh
az ad app federated-credential list --id <APP_ID>
```
If these return values, the delete script will remove them.

---

## References

- 📺 [Connect to Azure from a GitHub Action with OpenID Connect (OIDC)](https://www.youtube.com/watch?v=IKuw9T6vZYU&list=PLJcpyd04zn7qSRKw6ROGuObYTE1iJoH20&index=4)
