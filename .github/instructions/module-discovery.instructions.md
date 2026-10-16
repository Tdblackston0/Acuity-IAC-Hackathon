---
name: "Module Discovery Workflow Instructions"
description: "Use when creating, editing, or reviewing the Module Discovery Agent and its Tier 1 internal registry, Tier 2 AVM, or Tier 3 custom Bicep module skills."
applyTo:
  = ".github/agents/module-discovery.agent.md"
  - ".github/skills/acuity-tier1-lookup/**"
  - ".github/skills/avm-teir2-lookup/**"
  - ".github/skills/custom-teir3-scaffold/**"
---

# Module Discovery Workflow

- Preserve the mandatory order: internal Acuity registry, then AVM, then custom module.
- Require an explicit `NOT_FOUND` result with search evidence before advancing to the next tier.
- If Tier 3 also yields `NOT_FOUND` or cannot be scaffolded, stop and report the requirement, tiers searched, evidence collected, and request user guidance rather than fabricating a module.
- Never run Tier 1 and Tier 2 concurrently or select a module from its name alone.
- Verify candidate parameters, outputs, deployment scope, child-resource support, status, and exact published version.
- Treat registry metadata as authoritative. Never invent module references, versions, parameters, or outputs.
- Stop at the first suitable module unless the user explicitly requests a comparison.
- Keep Tier 1 and Tier 2 read-only. Tier 3 may edit files only when implementation is requested or separately approved.
- Before Tier 3 generation, read `acuity-module-repo/module_standards.md`, inspect the nearest comparable module, and retrieve current Bicep best practices from the official Microsoft Bicep documentation at `learn.microsoft.com/azure/azure-resource-manager/bicep/best-practices`.
- Compile every generated or modified Bicep entry point and report actual diagnostics. Do not claim deployment or What-If validation unless it ran.
- If compilation reports errors, attempt at most 2 remediation passes; if errors remain, stop and report the diagnostics and current file state to the user without claiming success.
- Keep discovery output auditable: requirement, selected tier, module and version, evidence, and decision.
- Keep these instructions scoped to this agent and its skills; do not broaden `applyTo` to all Bicep or workspace files.
