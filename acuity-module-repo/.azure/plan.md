# Azure Preparation Plan

> **Status:** Ready for Validation

Generated: 2026-10-15

---

## 1. Project Overview

**Goal:** Create a Bicep consumer at `scratch/hero-tier1-consumer.bicep` that invokes the existing Key Vault module to create `kv-acuity-demo` with `environment=demo` and `owner=platform` tags.

**Path:** Add Components

**Scope constraint:** Authoring and local validation only. Do not modify modules, deploy resources, or authenticate to Azure.

---

## 2. Requirements

| Attribute | Value |
|-----------|-------|
| Classification | Demo |
| Scale | One Key Vault |
| Budget | Not applicable to consumer authoring |
| Subscription | Not applicable; deployment and Azure authentication are excluded |
| Location | Inherited from `resourceGroup().location` by the selected module |

---

## 3. Components Detected

| Component | Type | Technology | Path |
|-----------|------|------------|------|
| Key Vault module | Infrastructure module | Bicep | `modules/security/keyvault/main.bicep` |
| Basic deployment test | Module consumer example | Bicep | `modules/security/keyvault/test/e2e/basic-deployment/main.test.bicep` |
| Requested consumer | Infrastructure consumer | Bicep | `scratch/hero-tier1-consumer.bicep` |

---

## 4. Recipe Selection

**Selected:** Bicep

**Rationale:**
- The requested artifact is a standalone Bicep consumer.
- The repository already contains a local Key Vault module entry point and a tested local-consumer pattern.
- A local module reference avoids authenticating to the private registry and allows offline compilation.

---

## 5. Architecture

**Stack:** Bicep module composition

| Component | Azure Service | Configuration |
|-----------|---------------|---------------|
| Key Vault | Azure Key Vault | Name `kv-acuity-demo`; tags `environment=demo`, `owner=platform`; all optional module parameters retain their defaults |

---

## 6. Provisioning Limit Checklist

No quota or capacity lookup will be performed because the user explicitly excluded Azure authentication and deployment. The planned change only authors and locally validates a consumer file.

| Resource Type | Number Described | Deployment Performed | Quota Validation |
|---------------|------------------|----------------------|------------------|
| `Microsoft.KeyVault/vaults` | 1 | No | Not applicable to offline authoring |

**Status:** Not applicable to the requested non-deployment task.

---

## 7. Execution Checklist

### Phase 1: Planning
- [x] Analyze workspace
- [x] Gather requirements from the explicit request
- [x] Scan the relevant module, documentation, and basic deployment test
- [x] Select the Bicep recipe and repository-local module entry point
- [x] Plan the single-resource consumer
- [x] User approved this plan

### Phase 2: Execution
- [x] Add the consumer to `scratch/hero-tier1-consumer.bicep`
- [x] Format and compile the consumer locally without Azure authentication
- [x] Report the selected module, evidence, and anything not verified

### Phase 3: Validation Proof
- [x] `format_bicep_file scratch/hero-tier1-consumer.bicep` completed successfully
- [x] `build_bicep scratch/hero-tier1-consumer.bicep` returned `success: true` using Bicep `0.48.1`
- [ ] Live ARM template validation was not run because it requires Azure authentication
- [ ] What-if and Azure Policy validation were not run because they require Azure context

**Validation status:** Offline authoring checks passed. The plan remains `Ready for Validation` because live Azure checks were explicitly excluded.

### Explicit Exclusions
- No changes to existing modules
- No Azure deployment
- No Azure authentication
- No private-registry lookup
