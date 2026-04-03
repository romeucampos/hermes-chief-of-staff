# Heartbeat

**What this file is**: Instructions for the recurring EA sweep (runs every 15 minutes during business hours). The cron job invokes the executive-assistant skill with these standing orders.

## Sweep Procedure

1. Check `workspace/tasks/current.md` for tasks due now or overdue.
2. Check inbox for new messages (use message-level search, not thread-only).
3. For each new message: classify per authority framework and act accordingly.
4. Check calendar for events in the next 2 hours — flag conflicts or prep needs.
5. Check `workspace/relationships/current.md` for follow-ups due today.
6. If any follow-ups are overdue, draft the next touch per cadence.

## Escalation

Surface urgent items to the owner via the configured escalation channel (from `CHIEF_OF_STAFF_CONTEXT.md`). Urgent = time-sensitive within 2 hours, or flagged by the owner.

## Quiet Hours

During configured quiet hours, only escalate genuinely urgent items. Everything else waits for morning.

## When Nothing Is Actionable

Return `HEARTBEAT_OK` — no message to the owner, no noise.

## Operating Principles

- Be proactive but don't create noise.
- Handle what you can, escalate what you should, ignore what doesn't matter.
- Prioritize: urgent tasks > new high-value emails > calendar prep > follow-ups > routine inbox.
