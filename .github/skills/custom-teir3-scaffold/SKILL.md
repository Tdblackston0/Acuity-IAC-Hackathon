---
name: custom-teir3-scaffold
description: "Tier 3 custom Bicep module scaffolding for Acuity. Use only after both the internal registry and AVM return NOT_FOUND; creates a standards-compliant module with tests and validation."
user-invocable: false
---

# Tier 3: Custom Module Scaffold

Create a custom module only when Tier 1 and Tier 2 both returned `NOT_FOUND` for the same requirement.

## Preconditions

1. Confirm the result includes Tier 1 search evidence and its mismatch reason.
2. Confirm the result includes Tier 2 search evidence and its mismatch reason.
3. Stop if either tier found a suitable module.
4. Obtain user approval before creating files when the request was discovery-only.

## Procedure

1. Read `acuity-module-repo/module_standards.md` and inspect the nearest comparable module under `acuity-module-repo/modules/`.
2. Call `azure-bicep/get_bicep_best_practices` before generating Bicep.
3. Place the module at `acuity-module-repo/modules/<family>/<module>/` using the repository naming conventions.
4. Create the standard module surface as needed:
	- `main.bicep` for the consumer-facing interface and module composition.
	- `exports.bicep` for module-specific user-defined types.
	- `modules/` for the core resource, child resources, diagnostics, and role assignments.
	- `test/e2e/<scenario>/main.test.bicep` and `main.test.ps1` for each distinct code path.
	- `bicepconfig.json`, `README.md`, and `version.json` consistent with nearby modules.
5. Reuse types from `modules/exports/global.bicep` when available. Do not redefine shared types.
6. Include diagnostic settings and role assignments when the resource supports them.
7. Use the latest suitable GA resource API version unless a required capability needs preview. Keep API versions consistent across the module.
8. Output at least the resource ID and name plus useful non-secret properties. Never output secrets, keys, or connection strings.
9. Compile every created or changed Bicep entry point with `azure-bicep/build_bicep` and resolve relevant errors.
10. Report deployment or What-If tests separately from compile validation. Never claim they ran unless they did.

## Result Contract

Return one status:

- `SCAFFOLDED`: Include fallback evidence, created paths, design decisions, and compile/test results.
- `BLOCKED`: Include the missing prerequisite, unresolved requirement, or validation failure and the next concrete action.

Do not publish the module or deploy Azure resources unless the user explicitly requests it.
