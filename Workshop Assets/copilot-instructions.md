<!-- HERO-TIER1-DEMO START -->
## Module discovery and consumption — local Tier 1 demo
- Treat the Acuity modules under modules/ as Tier 1 for this local demonstration. Search that catalog first and read a candidate's README.md and main.bicep to establish suitability.
- Only if no suitable Tier 1 module exists, check Azure Verified Modules (Tier 2). Only if both tiers have no suitable module, author custom Bicep (Tier 3). Search serially and stop at the first suitable match.
- If Tier 1 cannot be read or verified, report the blocker; do not treat an access error as "no suitable module."
- Verify parameter names, types, defaults, and outputs against the local source; use the README for usage guidance. Report discrepancies rather than guessing.
- Consume a suitable local module by a relative file reference from the consumer. Do not invent an ACR version or claim this local copy proves the currently published registry version.
- Cite the files used and explain why the selected module meets the request. Do not modify existing modules or run Azure authentication/deployment commands.

## Key Vault consumer standards — illustrative workshop rules, not confirmed Acuity policy
- Explicitly set enableRbacAuthorization: true and enablePurgeProtection: true.
- Explicitly set softDeleteRetentionInDays: 90 rather than relying on the module default.
- Add costCenter: 'workshop-demo' to resourceTags, preserving the tags requested in the prompt.
- Expose the module's keyVaultId and keyVaultName as consumer outputs.
- Verify these parameter and output names against the local module source before using them.
<!-- HERO-TIER1-DEMO END -->