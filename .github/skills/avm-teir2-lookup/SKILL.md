---
name: avm-teir2-lookup
description: "Tier 2 Azure Verified Modules lookup. Use only after the internal Acuity registry returns NOT_FOUND to discover and verify a suitable public AVM Bicep resource or pattern module."
user-invocable: false
---

# Tier 2: Azure Verified Modules Lookup

Search Azure Verified Modules only when Tier 1 has returned `NOT_FOUND` for the same requirement.

## Preconditions

- Preserve the Tier 1 search evidence and mismatch reason.
- Do not run this skill concurrently with Tier 1.

## Procedure

1. Call `azure-bicep/list_avm_metadata` and filter the returned metadata by resource provider, resource type, service name, and required capability.
2. Prefer AVM resource modules. Use an AVM pattern module only when the requirement is an architecture pattern and its behavior is a closer fit.
3. Verify module status, version, Bicep registry reference, deployment scope, parameters, outputs, and child-resource support from returned metadata.
4. Select only a published, stable module that satisfies the requirement. Do not invent a version or construct a registry reference from memory.
5. Record any project adaptations needed at the consumer layer without forking or rewriting the AVM module.

## Result Contract

Return exactly one status:

- `FOUND`: Include the AVM name, selected version, exact `br/public:avm/...` reference, matching parameters and outputs, and compatibility evidence.
- `NOT_FOUND`: Include the metadata filters used, candidates reviewed, and each concrete mismatch. This status authorizes Tier 3 only when Tier 1 also returned `NOT_FOUND`.

Do not create or modify files in this skill.
