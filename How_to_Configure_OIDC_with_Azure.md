

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
8. envsubst (via Git for Windows)

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

powershell   envsubst --version


./oidc.sh demo-github-azure-oidc-connection mrbalraj007/GitHub-Action-Azure_OpenID_Connect-OIDC















--Ref Link
 - YouTube Link
   - [Connect to Azure from a GitHub Action with OpenID Connect (OIDC)](https://www.youtube.com/watch?v=IKuw9T6vZYU&list=PLJcpyd04zn7qSRKw6ROGuObYTE1iJoH20&index=4)
