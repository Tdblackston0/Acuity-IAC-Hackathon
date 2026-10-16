# Copilot Instructions for terra-armt-shared-modules

## Overview
This repository contains shared Bicep modules for Azure infrastructure, published via Azure Container Registry (ACR) for use across teams. The structure, automation, and documentation are highly standardized to ensure consistency and ease of use.

## Architecture & Structure
- **Modules** are organized by service family under `modules/`, e.g., `modules/containers/aks`, `modules/web/appservice`.
- Each module folder contains:
  - `main.bicep`: Entry point, customer-facing parameters, outputs, and sub-module calls.
  - `exports.bicep`: User-defined types for the module and submodules.
  - `modules/`: Submodules for core resources, diagnostic settings, role assignments, and sub-resources.
  - `test/e2e/<scenario>/main.test.bicep` and `.ps1`: End-to-end test cases and scripts.
  - `README.md`: Auto-generated using `Set-ModuleReadMe.ps1`.
  - `version.json`: Version tracking.
- **Global types** are defined in `modules/exports/global.bicep` and should be imported explicitly.
- **Techdocs** live in `techdocs/` and are updated automatically by pipelines.

## Developer Workflows
- **Build & Publish:**
  - Use Azure DevOps pipelines in `ci/` (see `ci/templates/publish-module.yaml`).
  - Bicep files are built to ARM templates, published to ACR, and documentation is updated in Techdocs.
- **Testing:**
  - End-to-end tests are defined per module in `test/e2e/` and run via PowerShell scripts.
  - Use WhatIf deployments for validation before PRs.
- **Documentation:**
  - Run `Set-ModuleReadMe.ps1` to generate or update module READMEs from Bicep templates.
  - Techdocs are versioned and updated by pipeline automation.
- **Contribution:**
  - Branch from `develop`, make changes, update docs, and submit a PR.
  - Only one module PR can be in-flight at a time due to pipeline automation.

## Project-Specific Patterns
- Always provide role assignments and diagnostic settings modules if supported by the resource.
- Prefer user-defined types and explicit imports for maintainability.
- If a type needed by a module already exists in `global.bicep`, always import it from there rather than redefining it in `exports.bicep`. Only define types in `exports.bicep` that are specific to that module and not present globally.
- Use parameter defaults and optional types (`?`) for flexible module interfaces.
- When importing 4 or more distinct named types from a single module file in one import statement, use a wildcard prefix instead (e.g., `import * as kvTypes from 'exports.bicep'`).
- All module documentation and metadata are generated/updated via scripts in `scripts/`.

## Key Files & Directories
- `modules/` — All Bicep modules, submodules, and exports.
- `ci/` — Azure DevOps pipeline definitions and templates.
- `scripts/` — PowerShell automation for docs and metadata.
- `techdocs/` — Published documentation, auto-managed.
- `module_standards.md` — Detailed standards for module structure and conventions.
- `README.md` — High-level repo overview and onboarding.

## Examples
- Importing global types:
  ```bicep
  import {roleParams} from '../../exports/global.bicep'
  ```
- Using a type prefix:
  ```bicep
  import * as kvTypes from 'exports.bicep'
  ```
- Generating a README:
  ```powershell
  . ./scripts/Set-ModuleReadMe.ps1
  Set-ModuleReadMe -TemplateFilePath ./modules/<ModuleFamily>/<Module>/main.bicep
  ```

For more, see `module_standards.md` and the `scripts/` directory.
