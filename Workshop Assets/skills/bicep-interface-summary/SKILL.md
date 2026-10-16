---
name: bicep-interface-summary
description: "Summarise a Bicep module's consumable interface — its parameters (name, type, default, allowed values) and its outputs — so a caller can consume it without guessing. Use for module interface, parameter/output summary, 'how do I call this module'."
user-invocable: false
---

# Bicep Interface Summary

Given a Bicep module (a `main.bicep` or equivalent entry point):

1. List every parameter: name, type, whether required, default, and any `@allowed` values.
2. List every output: name, type, and what a consumer would use it for.
3. Flag anything a caller must supply that has no default.
4. Do not invent parameters or outputs — report only what the file declares.

## Optional result contract (one pattern, not required)
Return a status: `COMPLETE` when every parameter and output is summarised, or
`PARTIAL` with the reason if the module could not be fully read.