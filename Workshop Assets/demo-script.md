# Attendee Demo Script - Zero to Agents for Bicep

Use this optional follow-along alongside the live presentation. You can watch any
section instead of running it. Section numbers match the facilitator's demos;
there is no hands-on demo in section 1.

**Safety boundary:** work locally only. Do not run `az login`, deployments,
what-if, or module test PowerShell scripts. Do not configure MCP or access a
private registry. GitHub sign-in for Copilot is separate from Azure authentication
and is required to use Copilot. Local compilation does not deploy resources.

## Before you begin

You need VS Code with GitHub Copilot Chat, GitHub Copilot CLI, Git, and Azure CLI
with the Bicep compiler already installed. You also need the workshop's complete
`acuity-module-repo` folder. No Azure subscription, Python, or ACR access is needed.
Copilot itself requires network access and an authorized GitHub account.

Open **`acuity-module-repo` as your VS Code folder**, not the parent workshop
repository. All filesystem paths and PowerShell commands below are relative to
that folder unless stated otherwise. Forward slashes inside Bicep references and
chat file mentions are intentional.

Run in the VS Code PowerShell terminal:

```powershell
git status --short
Test-Path .\modules\security\keyvault\main.bicep
Test-Path .\modules\exports\global.bicep
az bicep version
copilot --version
```

Both path checks should return `True`. If a tool or module file is missing, watch
the demo and ask the facilitator for help rather than installing or authenticating
to Azure during the session.

Use a workshop copy of the repository. Preserve existing work and customization
files; do not overwrite them with samples below. Save a copy of any instructions
you intend to edit **outside the workspace**. Do not commit workshop changes to a
shared branch unless your team agrees.

> A new repository can still have user-level or extension-provided skills and
> instructions available. Inspect Copilot's applied references and tool trace.
> Generated answers may vary; compare evidence and requirements, not exact wording.

## Section 2 - Ask, Plan, Agent, and context

**Surface:** VS Code Copilot Chat.

1. Close your editor tabs, start a new chat, and select **Ask**. Send:

```text
What parameters and outputs does the Key Vault module expose?
```

2. Open `modules\security\keyvault\main.bicep`. Attach that exact file with the
   chat's file picker or `#file:` autocomplete, then send:

```text
What parameters and outputs does THIS module expose? List them exactly as written.
```

3. Optionally switch to **Plan**, keep the same file attached, and send:

```text
Plan adding private endpoint support to this Key Vault module. Do not write code yet. Outline the parameters, submodule, and outputs you would add, consistent with the repo's module standards. Do not authenticate or deploy.
```

**Checkpoint:** inspect which files Copilot read. Workspace search can find the
right module without an attachment; attaching it lets you choose the source.
Neither exercise should change a module. Do not implement the optional plan.

## Section 3 - Same prompt, reusable instructions

**Surface:** VS Code Copilot Chat, **Agent** mode.

The local `modules` catalog represents Acuity Tier 1 for this exercise. Its source
shows the interface, not which version is currently published in ACR.

### A. Run the baseline

Create a dedicated empty consumer:

```powershell
New-Item -ItemType Directory -Force .\scratch | Out-Null
New-Item -ItemType File -Path .\scratch\hero-tier1-consumer.bicep -ErrorAction Stop | Out-Null
```

If the file already exists, stop and inspect it. Do not overwrite someone else's
work. Use a fresh workshop copy if needed.

Open the file, start a new chat in **Agent**, and paste:

```text
Create a Bicep consumer in scratch/hero-tier1-consumer.bicep for a Key Vault named kv-acuity-demo, tagged environment=demo and owner=platform. Explain which module or resource you selected and cite the files or documentation you used to verify its parameters. Identify anything you could not verify. Do not modify existing modules, deploy anything, or authenticate to Azure.
```

Save the baseline result outside the workspace for comparison. Record the chosen
module, tags, explicit control settings, and outputs. If Copilot proposes Azure
authentication or deployment, decline and restate the local-only boundary.
Respect any required local workflow approvals.

### B. Add the workshop standards

Open `.github\copilot-instructions.md`. Preserve its existing contents and append
the following block **once**. If the file does not exist, create it under
`.github`. These extra settings are **illustrative workshop rules, not confirmed
Acuity production policy**.

```markdown
<!-- HERO-TIER1-DEMO START -->
## Module discovery and consumption - local Tier 1 demo
- Treat the Acuity modules under modules/ as Tier 1 for this local demonstration. Search that catalog first and read a candidate's README.md and main.bicep to establish suitability.
- Only if no suitable Tier 1 module exists, check Azure Verified Modules (Tier 2). Only if both tiers have no suitable module, author custom Bicep (Tier 3). Search serially and stop at the first suitable match.
- If Tier 1 cannot be read or verified, report the blocker; do not treat an access error as "no suitable module."
- Verify parameter names, types, defaults, and outputs against the local source; use the README for usage guidance. Report discrepancies rather than guessing.
- Consume a suitable local module by a relative file reference from the consumer. Do not invent an ACR version or claim this local copy proves the currently published registry version.
- Cite the files used and explain why the selected module meets the request. Do not modify existing modules or run Azure authentication/deployment commands.

## Key Vault consumer standards - illustrative workshop rules, not confirmed Acuity policy
- Explicitly set enableRbacAuthorization: true and enablePurgeProtection: true.
- Explicitly set softDeleteRetentionInDays: 90 rather than relying on the module default.
- Add costCenter: 'workshop-demo' to resourceTags, preserving the tags requested in the prompt.
- Expose the module's keyVaultId and keyVaultName as consumer outputs.
- Verify these parameter and output names against the local module source before using them.
<!-- HERO-TIER1-DEMO END -->
```

### C. Repeat the exact prompt

Clear **only** the dedicated consumer's contents after saving the baseline. Start
a new chat with the same model, skills/tools, and workspace settings. Repeat the
exact prompt from part A; do not add the new standards to the prompt itself.
Inspect the applied references to confirm the instructions were used.

Compare the result against this checklist:

| Requirement | Expected result after adding instructions |
|---|---|
| Module | `../modules/security/keyvault/main.bicep`; no AVM or custom resource needed |
| Name | `keyVaultName: 'kv-acuity-demo'` |
| Tags | Object with `environment: 'demo'`, `owner: 'platform'`, and `costCenter: 'workshop-demo'` |
| RBAC | Explicit `enableRbacAuthorization: true` |
| Purge protection | Explicit `enablePurgeProtection: true` |
| Retention | Explicit `softDeleteRetentionInDays: 90` |
| Outputs | Consumer exposes the module's `keyVaultId` and `keyVaultName` |
| Evidence | Reads `modules\security\keyvault\README.md` and `main.bicep` |

Compile locally:

```powershell
az bicep build --file .\scratch\hero-tier1-consumer.bicep --stdout > $null
if ($LASTEXITCODE -ne 0) { throw 'Local compilation failed. Read the compiler diagnostics before continuing.' }
```

**Checkpoint:** the prompt requested a name and two tags; the instructions supplied
additional standards. RBAC and purge protection already default to `true` in the
module; explicit settings document intent. Retention changes its 7-day default.
Both baseline and instructed output can be valid. If the baseline already included
some settings, acknowledge that overlap rather than manufacturing a failure.

Instructions guide generation; they do not enforce compliance. Compilation checks
the interface, not every workshop rule, Azure name availability, policy, or
deployment success. Faster execution or skipped approvals is not the lesson.

## Section 4 - Run a reusable review prompt

**Surface:** VS Code Copilot Chat.

If the workshop copy contains
`.github\prompts\Module-Review.prompt.md`, start a new chat, type `/`, and select
**Module-Review**. Add:

```text
Review the module security/keyvault. Report findings only; do not edit files, run test scripts, authenticate, deploy, or run what-if. Use local source and standards; label any external comparison you cannot verify.
```

If asked for the identifier, answer `security/keyvault`. If the prompt or a
required tool is unavailable, watch this section instead; do not configure MCP.

**Checkpoint:** verify findings against the files. Look for name validation,
output descriptions, and parameter typing; do not assume a predicted finding is
correct. Review "tiers" mean standards, Azure pillars, and AVM benchmarking.
They are different from the **sourcing** tiers: Acuity, AVM, custom.

## Section 5 - Add a small interface-summary skill

**Surface:** VS Code Copilot Chat, **Agent** mode.

Create `.github\skills\bicep-interface-summary\SKILL.md` only if it does not already
exist. Paste:

```markdown
---
name: bicep-interface-summary
description: "Summarise a Bicep module's consumable interface: parameters, defaults, allowed values, and outputs. Use when asked how to call a module or summarise its interface."
user-invocable: false
---

# Bicep Interface Summary

1. Read the specified module entry point.
2. List every parameter's name, type, required status, default, and allowed values.
3. List every output's name, type, and intended use based on the source.
4. Highlight required inputs with no default.
5. Report only declarations you verified. If a file cannot be read, state the blocker.
6. Do not edit modules, authenticate, or deploy.
```

Start a new chat, attach `modules\security\keyvault\main.bicep`, and send without
naming the skill:

```text
I'm about to consume this Key Vault module. Give me a clean summary of its parameters and outputs so I don't have to guess how to call it.
```

**Checkpoint:** inspect the trace for skill selection, then verify the summary
against the source. If it answers directly without loading the skill, do not
claim activation. Check skill discovery and the description with the facilitator;
an accurate summary alone does not prove the skill ran.

## Section 6 - Give the workflow a custom agent

**Surface:** VS Code Copilot Chat.

Create `.github\agents\module-helper.agent.md` only if it does not already exist:

```markdown
---
description: "Read-only Bicep module helper for local module consumption and interface summaries."
tools: [read, search]
---

You help an engineer understand an existing local Bicep module before consuming it.

1. Clarify the requirement in one line.
2. Locate the local candidate and use the bicep-interface-summary skill when available.
3. Report required inputs, supported outputs, and any suitability gaps.
4. Cite the source files and state anything you could not verify.

Do not invent interfaces, versions, or registry references. Do not edit files,
authenticate, deploy, or run test scripts. If the skill is unavailable, say so
and provide a source-backed summary without claiming skill activation.
```

Select **module-helper** in the chat agent picker, start a new chat, and send:

```text
Help me consume the local modules/security/keyvault/main.bicep module for a new environment. Summarise its interface and flag anything I should confirm before writing Bicep. Do not edit files.
```

**Checkpoint:** verify the selected agent and any skill activation in the trace.
If the agent is not listed, ask the facilitator to check discovery; sending its
intent to the default agent is not proof that the custom agent ran.
This is one example design, not a prescribed production agent.

## Section 7 - MCP: watch only

Do not install or register an MCP server, authenticate to Azure, or restore a
private module. Watch the facilitator's sandbox registry lookup.

Look for the distinction: section 3 read local source directly; this demo reads
registry metadata through tools. Compare the returned reference, version,
parameters, and outputs. A sandbox module may have a different interface from the
local Acuity module. Do not copy its parameters into your local consumer.

## Section 8 - Use the terminal surface

**Surface:** PowerShell and GitHub Copilot CLI, still in `acuity-module-repo`.

Launch:

```powershell
copilot
```

Use `/help` to see commands supported by your installed version. Use
`/instructions` and `/skills` to inspect available customizations; where supported,
`/env` shows the loaded environment. Repo instructions and skills should be
verified here rather than assumed to have loaded.

Use `@` file autocomplete to select the module and send:

```text
@modules/security/keyvault/main.bicep List the exact parameters and outputs this module exposes. Read only; do not authenticate or deploy.
```

Use `/plan` and request:

```text
Plan a consumer for the local modules/security/keyvault/main.bicep module. Follow the repository's workshop consumer standards. Do not write files, restore a private registry module, authenticate, or deploy.
```

Planning does not require enabling autopilot or granting blanket permissions.
Use `/agent` to select **module-helper**, if discovered, and repeat the section 6
request. Check the trace for actual agent and skill use. If either is missing,
inspect discovery rather than assuming identical behavior across surfaces.

The VS Code prompt-file exercise is not a CLI dependency. Do not assume that its
`/Module-Review` invocation is available; check the commands your CLI exposes.

Exit with `/exit`. Back in PowerShell, compile and pipe the local template into
Copilot for a read-only explanation:

```powershell
$compiled = az bicep build --file .\modules\security\keyvault\main.bicep --stdout
if ($LASTEXITCODE -ne 0) { throw 'Local compilation failed; do not send partial output to Copilot.' }
$template = $compiled | Out-String
"Explain this compiled ARM template, including defaults and risks visible in it. Do not execute commands, edit files, authenticate, or deploy.`n$template" | copilot -s
if ($LASTEXITCODE -ne 0) { throw 'Copilot explanation failed.' }
```

**Checkpoint:** you receive a source-backed explanation without contacting Azure.
Use only workshop material authorized for your organization's Copilot service;
do not paste secrets or unauthorized templates.

## Finish and clean up

Review `git status --short` and your diffs. Keep your work if you want to build on
it, but do not commit the illustrative standards as production policy.

For a reset, remove only the consumer you created:

```powershell
Remove-Item -LiteralPath .\scratch\hero-tier1-consumer.bicep
```

Remove only your appended `HERO-TIER1-DEMO` block from the instructions file,
comparing with the pre-exercise copy. If you created the whole file, delete it
only after confirming it contains no other work. Remove the section 5 skill and
section 6 agent only if you created them and no longer want them. Review any
additional files Copilot created before removing them individually.

**Do not delete the shared scratch folder, reset the repository, or discard
unrelated changes.** The intended takeaway is a reusable, source-grounded workflow,
not a deployed Azure resource.
