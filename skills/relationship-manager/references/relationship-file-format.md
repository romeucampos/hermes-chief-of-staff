# Relationship File Format Reference

The relationship tracking file (workspace/relationships/current.md) has three sections:

## Active Follow-ups

Table format:

```
| Person | Context | Last Contact | Next Follow-up | Touch # | Status |
|--------|---------|--------------|----------------|---------|--------|
```

- **Person**: Full name.
- **Context**: Brief description of the relationship/thread (e.g., "Partnership discussion," "Sales intro from Mike").
- **Last Contact**: YYYY-MM-DD — date of most recent outreach or response.
- **Next Follow-up**: YYYY-MM-DD — when the next follow-up is due.
- **Touch #**: Which follow-up attempt this is (1, 2, or 3).
- **Status**: Current state — Awaiting reply / Meeting scheduled / Replied / Escalated to owner.

## Nurture

For contacts that don't need active follow-up but should be checked in on periodically.

Table format:

```
| Person | Context | Last Contact | Frequency | Next Check-in |
|--------|---------|--------------|-----------|---------------|
```

- **Frequency**: How often to check in (weekly, monthly, quarterly).
- **Next Check-in**: YYYY-MM-DD.

## Archived

Completed or closed-out follow-ups. Keep for reference. No specific format required — just the person, context, and outcome.

## Rules

- One row per person per active thread (a person can have multiple active follow-ups if they're about different topics).
- Dates always in YYYY-MM-DD format.
- When a follow-up resolves, move the row to Archived with the outcome.
- When all 3 touches are exhausted with no response, move to Archived with status "No response — escalated."
