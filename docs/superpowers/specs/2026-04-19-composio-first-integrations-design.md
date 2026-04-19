# Design: Composio-First Integrations for Hermes Chief of Staff

## Status

Approved for specification. Awaiting user review before implementation.

## Context

The project currently assumes MCP-backed integrations in its setup and operating documentation. The clearest examples are:

- `INSTALL.md`, which instructs users to configure `mcp_servers` for Gmail and Google Calendar in `~/.hermes/config.yaml`
- `workspace/TOOLS.md`, which asks users to record MCP server names for email, calendar, and other integrations

This creates two problems:

1. The default setup path is coupled to MCP even though the intended operating model is Hermes as the primary agent plus Composio as the connection layer.
2. The repository has no explicit policy for future integrations, so new docs or skills can drift back toward MCP-specific guidance.

The requested direction is:

- Hermes remains the main agent and orchestration surface.
- Composio CLI becomes the default connection mechanism for email, calendar, and any future external integration.
- Any new integration should use Composio first.

## Goals

- Replace MCP as the default integration path with Composio CLI.
- Keep Hermes as the execution and orchestration layer.
- Update setup docs, templates, skills, and operational language to reflect the new model.
- Define a repo-level policy that new integrations should use Composio first.
- Provide a migration path for existing MCP-based users.

## Non-Goals

- Rewriting Hermes itself.
- Implementing a general-purpose integration framework beyond the needs of this repository.
- Supporting every possible Composio app on day one.
- Preserving MCP as a first-class setup path in the main documentation.

## Decision Summary

Adopt a `Composio-first` integration model:

- Hermes remains responsible for skills, prompts, and cron-driven workflows.
- Composio CLI becomes the standard method for authenticating and exposing integrations.
- Repository language shifts from `MCP server` to `integration`, `connection`, or `connected app`.
- Legacy MCP guidance is removed from the primary path and retained only in a migration document if needed.

## Current State

### Explicit MCP coupling

- `INSTALL.md` includes a dedicated `Configurar as Integracoes MCP` step.
- `INSTALL.md` troubleshooting instructs users to reload MCP servers and inspect Hermes logs for MCP issues.
- `workspace/TOOLS.md` uses `Nome do servidor MCP` as a key data point for email, calendar, and other tools.

### Implicit coupling

The current repository structure suggests most of the dependency is operational and editorial rather than code-level. That is good news: the migration is primarily a contract and documentation update, not a deep software rewrite.

The main risk is inconsistency. If docs move to Composio but skills and templates still describe integrations in MCP terms, users will end up with conflicting instructions.

## Target Operating Model

### Core roles

- Hermes handles orchestration, reasoning, scheduling, and skill execution.
- Composio CLI handles external service connectivity and authorization.
- Project files continue to define owner context, task state, and operating rules.

### Integration contract

All external services should be described using a vendor-neutral contract:

- `provider`: the external system, such as Gmail, Google Calendar, Slack, Notion, or Sheets
- `connection`: the authenticated link managed through Composio CLI
- `account mapping`: which user identity or mailbox/calendar/workspace is tied to the connection
- `capabilities`: what the integration is used for in this project

Skills and docs should refer to the presence or absence of a connected integration, not the existence of an MCP server.

### Default policy

For any new external integration:

1. Try Composio first.
2. Only use another mechanism if Composio is not viable.
3. If an exception is made, document the reason explicitly.

## Proposed Repository Changes

### 1. Installation and onboarding

Update `INSTALL.md` so the main setup path becomes:

1. Install Hermes
2. Install and authenticate Composio CLI
3. Connect email, calendar, and other services through Composio
4. Validate access from Hermes workflows

Required changes:

- Replace `Configurar as Integracoes MCP` with `Configurar Integracoes via Composio CLI`
- Remove examples based on `mcp_servers` in `~/.hermes/config.yaml`
- Remove instructions to run `/reload-mcp`
- Rewrite troubleshooting around connection status, auth errors, and provider access in Composio terms

### 2. Workspace tool reference

Update `workspace/TOOLS.md` to record integration state in Composio terms.

Examples:

- Replace `Nome do servidor MCP` with `Integracao via Composio`
- Keep provider and account-mapping notes
- Add room for connection-specific notes, such as read-only calendars or multiple inbox rules

### 3. Context templates

Update the templates in `templates/` so `Ferramentas Disponiveis` and related sections describe integrations as connected apps through Composio.

Expected changes:

- Email accounts become mapped to Composio-backed connections
- Calendar accounts become mapped to Composio-backed connections
- Future integrations use the same vocabulary

### 4. Skills and references

Review all `skills/*/SKILL.md` and supporting `references/` files for:

- MCP-specific terminology
- assumptions about server names
- setup or troubleshooting text that points users back to MCP

Replace with:

- instructions to use connected integrations through Composio
- references to account mapping in `CHIEF_OF_STAFF_CONTEXT.md`
- provider-neutral operational guidance wherever possible

### 5. Project-level integration policy

Add a short policy statement to the user-facing docs, likely in `README.md` and `docs/adaptation-guide.md`:

- Hermes is the agent layer
- Composio is the default connection layer
- New integrations should use Composio first

This reduces future drift.

### 6. Migration guide

Add a dedicated migration doc for existing users, for example:

- `docs/composio-migration.md`

It should cover:

- who needs to migrate
- what changes in practice
- what can be removed from Hermes config
- how to reconnect email and calendar via Composio CLI
- how to validate that heartbeat, inbox checks, and calendar checks still work

## Implementation Plan

### Phase 1: Audit and terminology alignment

- Search the repo for `MCP`, `mcp`, `reload-mcp`, `server`, `gmail`, `calendar`, and related terms
- Build a list of files that need changes
- Standardize on approved terminology:
  - `integration`
  - `connection`
  - `connected app`
  - `provider`
  - `account mapping`

### Phase 2: Update primary docs

- Rewrite `INSTALL.md`
- Update `README.md`
- Update `workspace/TOOLS.md`
- Update `templates/CHIEF_OF_STAFF_CONTEXT.example.md`
- Update `templates/CHIEF_OF_STAFF_CONTEXT.demo.md`

### Phase 3: Update skills and references

- Review all skill docs
- Replace MCP-specific instructions
- Ensure all workflow descriptions remain coherent after the terminology shift

### Phase 4: Add migration material

- Create `docs/composio-migration.md`
- Move any remaining legacy MCP guidance there if it is still worth preserving

### Phase 5: Validation

Check the documented flows end to end:

- inbox access
- calendar access
- heartbeat workflow
- morning briefing workflow
- onboarding flow for a new user

## File-Level Execution Plan

### High priority

- `INSTALL.md`
- `README.md`
- `workspace/TOOLS.md`
- `templates/CHIEF_OF_STAFF_CONTEXT.example.md`
- `templates/CHIEF_OF_STAFF_CONTEXT.demo.md`

### Medium priority

- `docs/adaptation-guide.md`
- `docs/recommended-founder-setup.md`
- `docs/maturity-levels.md`
- `skills/assistente-executivo/SKILL.md`
- `skills/assistente-executivo/references/calendar-rules.md`

### Sweep priority

- Remaining `skills/*/SKILL.md`
- Remaining `skills/*/references/*`
- Any future docs that still mention MCP after the first pass

## Risks

### Terminology mismatch

If some files say `MCP` and others say `Composio`, users will not know which system is authoritative.

Mitigation:

- Update the highest-traffic docs first
- Run a full repo search after edits

### Hidden workflow assumptions

Some skills may implicitly assume capabilities or account-selection behavior that does not map exactly from MCP to Composio.

Mitigation:

- Preserve owner-controlled account mapping in `CHIEF_OF_STAFF_CONTEXT.md`
- Keep provider rules in reference docs, separate from transport details

### Over-coupling to a new vendor

Replacing one vendor-specific term with another everywhere can create future lock-in.

Mitigation:

- Use vendor-neutral terminology in skill logic and templates
- Mention Composio explicitly in setup and migration docs, where it matters

## Testing and Acceptance Criteria

The migration is complete when:

- The primary installation path no longer depends on MCP.
- The primary installation path clearly uses Composio CLI.
- Workspace and context templates describe integrations in Composio-compatible terms.
- Skills do not require users to think in terms of MCP servers.
- A migration guide exists for legacy MCP users.
- A repo search for `MCP` only finds legacy or intentionally scoped references.

## Open Questions

These questions do not block the documentation migration, but they may affect implementation details:

- What is the exact Composio CLI setup sequence the repo should recommend?
- Are there any Hermes-side commands or wrappers needed for invoking Composio-backed tools?
- Are some integrations better described as optional rather than baseline?

The implementation should answer these with concrete commands and examples before finalizing the install guide.

## Recommendation

Implement this as a documentation-and-contract migration first, then sweep the remaining skill text for consistency.

This is the right order because the repository currently appears to be coupled to MCP mostly by instructions and operating language, not by deep embedded code. The fastest safe path is to make the default path unambiguous, then clean the long tail.
