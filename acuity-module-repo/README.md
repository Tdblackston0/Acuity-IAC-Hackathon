# Acuity Bicep Registry Repository

This Repo holds various Bicep Modules that are shared out via ACR for teams to make use of.

## Getting Started

To work with this repo you'll need the following

1. [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
   1. Note this is PowerShell not Windows PowerShell
1. PowerShell Modules
   1. [AZ](https://www.powershellgallery.com/packages/Az)
   1. [Bicep](https://www.powershellgallery.com/packages/Bicep)
1. [VSCode](https://code.visualstudio.com/)
1. VSCode Extensions
   1. [PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
   1. [Azure Account](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azure-account)
   1. [Azure Resource Manager (ARM) Tools](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
   1. [Azure Pipelines](https://marketplace.visualstudio.com/items?itemName=ms-azure-devops.azure-pipelines)
   1. [Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
   1. [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)
   1. [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

## Build and Test

### Folder and File structure

```
terra-armt-shared-resources
 ┣ 📂ci
 ┃ ┣ 📂 <Module Family 1>
 ┃ ┃ ┣ 📜<Module1>.cicd.yaml
 ┃ ┃ ┗ 📜<Module2>.cicd.yaml
 ┃ ┣ 📂 <Module Family 2>
 ┃ ┃ ┣ 📜<Module1>.cicd.yaml
 ┃ ┃ ┗ 📜<Module2>.cicd.yaml
 ┃ ┗ 📂templates
 ┣ 📂modules
 ┃ ┣ 📂 <Module Family 1>
 ┃ ┃ ┣ 📂 <Module1>
 ┃ ┃ ┗ 📂 <Module2>
 ┃ ┣ 📂 exports
 ┃ ┃  ┗ 📜 global.bicep
 ┃ ┗ 📂 <Module Family 2>
 ┣ 📂scripts
 ┃ ┣ 📂 helper
 ┃ ┗📜<tooling scripts>
 ┣ 📂test <Deprecated. Module tests>
 ┣ 📂techdocs
 ┃ ┣ 📂 <Module Family>
 ┃ ┃  ┣ 📂 <Module>
 ┃ ┃  ┃ ┣ 📜 metadata.json
 ┃ ┃  ┃ ┣ 📜 README.<version>.md
 ┃ ┃  ┃ ┗ 📜 README.md
 ┃ ┃  ┗ 📜 README.md
 ┃ ┣ 📜 README.md
 ┃ ┗ 📜 training.md
 ┣ 📂wikiRoot <Deprecated. Module documentation area, no longer updated.>
 ┗ 
 ```

### Overview

- **ci** Directory for pipelines.
  - *modulefamily* Directory for module specific pipelines for the same family.
  - **templates** Directory for pipeline templates.
- **modules** Directory for modules.
  - *modulefamily* Directory for family of modules.
    - *moduledirectory* Directory for individual modules.
- **scripts** Directory for supporting scripts.
- **techdocs** Directory for Techdocs documentation.

For details on the module folder structure and standards see [Acuity Bicep Module Standards](./module_standards)

## Contribute

1. Create a feature branch off develop.
1. Make and test your changes.
1. Update the README.md file using the script tools.
1. When ready create a PR.
1. Only one module can be in flight at a time. If the pipeline for a module is `In-Progress` then do not complete the PR until is is `Complete` or `Canceled`. This is due to the automation in the pipeline to update the TechDocs.

## Key Areas of Technical Debt

### 1. Storage Accounts

- **Diagnostic Settings**  
  - Retention settings are no longer supported in the latest version of diagnostic settings.
  - Current configuration does not set retention.
- **Module Versioning**  
  - Current version: `1.0.1`  
  - Latest available: `1.1.16`  
  - **Action:** Upgrade to the latest module version.
- **Monitoring Share (filesharesslsr)**  
  - Originally used for Prometheus monitoring.
  - Currently zero-cost; cleanup is not urgent but should be tracked as tech debt.

---

### 2. Dapr Integration

- Dapr needs to be rolled into the **AKS shared module** for consistency and simplified deployment.

---

### 3. Tracking Technical Debt

- Options discussed:
  - **Work Items (WI)** in Azure DevOps or Jira.
  - Document in **repo-level README** or **shared module README**.
- **Decision pending:** Define a standard tracking mechanism.

---

### 4. Cluster Deployment Configuration

- Differences exist between **Bicep configurations** for clusters.
- **Proposal:** Create a **single cluster template parent file** to standardize deployments.
- **Status:** Discussion ongoing; may be deferred.

---

### 5. Feature Flag Lifecycle

- Define lifecycle for feature flag operations:
  - Creation
  - Activation/Deactivation
  - Retirement

---

### 6. Monitoring Differences

- Reminder: Monitors in `terra-app-monitoring` differ from KPS to ManProm.
- Installed CRDs need review for alignment.

**Additional Details:**

- Monitors in `terra-app-monitoring` repo differ from KPS to ManProm; installed CRDs.
- API version of service monitor differs for ManProm CRDs → `azmonitoring`.
- Two types of monitors: **service monitors** and **pod monitors**.
- Aqua and monitoring folder node exporters can be removed.
- Review differences in monitors and determine what needs to be switched.
- Check ATR dev or platform (`devportal-api-metrics`).
- After fixing current service monitors, **Kiali** may need to return and its service monitors should be reviewed.

---

## Action Items

- Upgrade **Storage Account module** to `1.1.16`.
- Integrate **Dapr** into AKS shared module.
- Evaluate feasibility of **single cluster template parent file**.
- Add **region** and other parameters to DCR module.
- Define **feature flag lifecycle**.
- Align monitoring configurations across repos.
- Add instructions for using the AI prompts.

---

## Tech Debt Tracking

- Use **Azure DevOps Work Items** for formal tracking.
- Maintain a **Tech Debt section in README** for quick reference.
- Review and update quarterly during architecture reviews.

---
