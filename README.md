# Attendee README - GitHub Copilot IaC Hackathon

Welcome! This workshop focuses on customizing GitHub Copilot for Acuity's IaC
process using real Bicep modules. You will explore both **VS Code Copilot Chat**
and **GitHub Copilot CLI**, then build a customization stack for a workflow your
team actually uses.

**Start with the [attendee demo script](./attendee-demo-script.md)** if you want to
follow along. Participation in **every demo, including section 7, is optional**;
watching is equally welcome.

## Agenda

This agenda follows slide 2 of [the presentation](./deck.pptx).
The deck does not specify section durations.

| # | Section |
|---|---|
| 1 | Welcome, Objectives & the Acuity Module Hierarchy |
| 2 | Chat Modes + Context Precision |
| 3 | Custom Instructions - Encode the Hierarchy |
| - | **Break** |
| 4 | Prompt Files - The Module Reviewer |
| 5 | Agent Skills - Build a Reusable Capability |
| - | **Break** |
| 6 | Custom Agents - A Named Persona |
| 7 | MCP - Live Data from Real Systems |
| 8 | Copilot CLI - Same Customizations, New Surface |
| - | **Lunch** |
| 9 | Hacking |

## Before the session

Have these installed and ready:

- VS Code with GitHub Copilot Chat and the Bicep extension.
- GitHub Copilot CLI, signed in with an authorized GitHub account.
- Git and access to the workshop repository.
- Azure CLI with the Bicep compiler for **local compilation only**.
- PowerShell for the copy-and-paste terminal examples.

Open the repository's **`acuity-module-repo` folder** as your VS Code workspace.
This keeps the demo focused on the local module catalog and its customizations,
rather than the parent repository's proof-of-concept agents and skills.

From a terminal in that folder, check:

```powershell
git status --short
Test-Path .\modules\security\keyvault\main.bicep
Test-Path .\modules\exports\global.bicep
az bicep version
copilot --version
```

Both path checks should return `True`. If something is missing, you can watch the
demo and work with the facilitator to resolve setup.

**No Azure sign-in, subscription, private ACR access, or Python is needed.**
Copilot requires GitHub authentication and network access; that is separate from
Azure authentication.

## Working safely

Work in your own workshop copy and preserve existing changes. Do not run
`az login`, Azure deployments, what-if, or module test PowerShell scripts.
`az bicep build` compiles locally and does not create Azure resources.

**Section 7 is optional to follow along.** You can connect to the public Microsoft
Learn MCP server and try the documentation lookup, or simply watch the facilitator.
Setup and prompts are in section 7 of the attendee demo script. No Azure
environment, endpoint authentication, or registry credentials are needed.

For section 3, the local Acuity modules represent **Tier 1**. Read the local
README and source before considering AVM or custom Bicep. The local copy does not
verify a published ACR version. The added cost-center tag and Key Vault settings
are **illustrative workshop standards, not confirmed Acuity production policy**.

A new repo may still load user-level or extension-provided customizations. Inspect
the trace and applied references instead of assuming no skills are available.
Instructions guide generation; review and automated checks are still needed.

## Hacking: build something useful to your team

Pick a small, repeatable IaC task such as summarizing a module interface,
preparing a consumer, or reviewing a module against local standards.

Build your own combination of repository instructions, a reusable prompt, a skill,
and a custom agent. Keep the module sourcing order explicit: **Acuity first, AVM
only when no suitable Acuity module exists, custom only after both tiers miss**.
For local exercises, use the provided Acuity module catalog; an access error is
not proof that a tier has no suitable module.

Try a realistic request, inspect the files and tools used, and check the result
against your requirements. Compile locally if you generate Bicep. Be ready to
explain what your customization changed and what remains unverified.

There is no single required agent design. Keep the scope local and non-deploying,
and do not commit workshop-only standards as production policy. Review your diffs
and use the attendee script's targeted cleanup steps when finished.
