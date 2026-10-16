---
name: acuity-tier1-lookup
description: "Tier 1 Bicep module discovery in the internal Acuity private registry. Always use first for Azure resource module lookup, registry search, module selection, and compatibility verification."
user-invocable: false
---

# Tier 1: Acuity Registry Lookup

Search the internal Bicep registry before AVM or custom module work.

## Inputs

- Azure resource type or capability
- Required parameters and outputs
- Deployment scope and parent/child resource needs
- Compatibility or version constraints

## Procedure

1. Convert the requirement into focused search terms, including the Azure resource provider/type and common service name.
2. Call `bicep-registry/search_modules` for the strongest term. Try relevant synonyms when the first search has no credible candidates.
3. Use `bicep-registry/list_modules` only when focused searches are inconclusive.
4. For each credible candidate, call `bicep-registry/list_versions`.
5. Call `bicep-registry/get_module_metadata` for the latest stable compatible version.
6. Compare the returned description, parameters, outputs, and registry reference with every required capability.
7. Select a module only when metadata demonstrates compatibility. Never infer compatibility from its name alone.

## Result Contract

Return exactly one status:

- `FOUND`: Include the module name, selected version, exact `br:` reference, matching parameters and outputs, and evidence that it meets the requirement.
- `NOT_FOUND`: Include search terms, candidates reviewed, and the concrete capability mismatch or absence. This status authorizes Tier 2.

Do not search AVM and do not create or modify files in this skill.
