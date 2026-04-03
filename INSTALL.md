# Installation Guide

Step-by-step setup for the Chief of Staff OS on Hermes Agent.

---

## Prerequisites

- [Hermes Agent](https://hermes-agent.nousresearch.com/) installed and configured
- At least one email account accessible via MCP (Gmail recommended)
- Calendar access via MCP (Google Calendar recommended)

## Step 1: Clone the Repo

```bash
git clone https://github.com/TheCraigHewitt/hermes-chief-of-staff.git
cd hermes-chief-of-staff
```

## Step 2: Install Skills

Copy the skills to your Hermes skills directory:

```bash
cp -r skills/* ~/.hermes/skills/
```

Verify they're detected:

```bash
hermes chat
# Then type: /skills
# You should see: executive-assistant, daily-task-manager, daily-task-prep,
#                  relationship-manager, chief-of-staff
```

## Step 3: Set Up the Context File

Copy the template to your project root:

```bash
cp templates/CHIEF_OF_STAFF_CONTEXT.example.md ~/your-project/CHIEF_OF_STAFF_CONTEXT.md
```

Open it and fill in every section:

- **About You**: Name, timezone, role
- **Communication**: Email accounts, calendar accounts, tone preference
- **Authority**: What the assistant can handle vs. what needs your approval
- **Work Hours**: When sweeps should run, quiet hours
- **Tools Available**: Which MCP integrations are connected
- **Follow-up Preferences**: Default cadence, VIP contacts
- **Business Context**: Brief notes to help the assistant make better decisions

## Step 4: Set Up Workspace Files

Copy the workspace directory to your project:

```bash
cp -r workspace/ ~/your-project/workspace/
```

This creates:
- `workspace/tasks/current.md` — Your canonical task file (edit the example entries)
- `workspace/relationships/current.md` — Your follow-up tracking file (edit the examples)
- `workspace/HEARTBEAT.md` — Instructions for automated sweeps
- `workspace/TOOLS.md` — Local tool environment notes (fill in as needed)

## Step 5: Set Up Personality (Optional)

Copy the SOUL template for the CoS personality:

```bash
cp templates/SOUL.example.md ~/.hermes/SOUL.md
```

Copy the USER template for your profile:

```bash
cp templates/USER.example.md ~/.hermes/memories/USER.md
```

Edit both to match your preferences.

## Step 6: Configure MCP Integrations

In `~/.hermes/config.yaml`, set up MCP servers for your email and calendar. Example for Gmail:

```yaml
mcp_servers:
  gmail:
    command: "npx"
    args: ["-y", "@anthropic/mcp-server-gmail"]
  google_calendar:
    command: "npx"
    args: ["-y", "@anthropic/mcp-server-google-calendar"]
```

Reload after changes:

```bash
hermes chat
# Then type: /reload-mcp
```

## Step 7: Set Up Cron Schedules

Start the Hermes cron scheduler:

```bash
hermes cron start
```

Add the recommended schedules (adjust times to your timezone):

```bash
# EA inbox sweep — every 15 min, business hours, weekdays
hermes cron add "*/15 8-21 * * 1-5" "Run the executive-assistant skill in heartbeat mode. Follow workspace/HEARTBEAT.md. Return HEARTBEAT_OK if nothing actionable."

# Daily task prep — 2 AM nightly
hermes cron add "3 2 * * *" "Run the daily-task-prep skill. Enrich tomorrow's task list with recurring items, due dates, and calendar events."

# Follow-up check — twice daily, weekdays
hermes cron add "47 9,14 * * 1-5" "Run the relationship-manager skill. Check for follow-ups due today. Draft messages for any that are overdue."

# Morning briefing — once daily, weekdays
hermes cron add "57 7 * * 1-5" "Run the chief-of-staff skill in morning briefing mode. Summarize today's tasks, inbox highlights, calendar, and due follow-ups."
```

See [cron/README.md](cron/README.md) for details and customization options.

## Validation Checklist

Run through this after setup to confirm everything works:

- [ ] Skills show up in `/skills` list
- [ ] `CHIEF_OF_STAFF_CONTEXT.md` is filled out and readable from your project root
- [ ] `workspace/tasks/current.md` exists and has proper section headers
- [ ] `workspace/relationships/current.md` exists and has proper section headers
- [ ] MCP integrations are connected (test: "check my inbox" or "what's on my calendar")
- [ ] Cron jobs are listed in `hermes cron list`
- [ ] Test a heartbeat: "Run executive-assistant in heartbeat mode" — should return HEARTBEAT_OK or a summary
- [ ] Test a briefing: "Morning briefing" — should return a structured daily overview

## Choosing What to Install

You don't need everything. See [docs/maturity-levels.md](docs/maturity-levels.md) for which skills and cron jobs to set up at each level:

- **Level 1 (Personal EA)**: Steps 2-4 with just `executive-assistant` and `daily-task-manager`
- **Level 2 (Founder)**: Full Steps 2-6, all cron jobs except morning briefing
- **Level 3 (Full CoS)**: Everything above

## Troubleshooting

**Skills not showing up**: Make sure the SKILL.md files are in `~/.hermes/skills/<skill-name>/SKILL.md`. Each skill needs its own directory.

**MCP not connecting**: Run `/reload-mcp` in a Hermes chat session. Check `~/.hermes/logs/` for errors.

**Cron not running**: Make sure `hermes cron start` is running. Check status with `hermes cron list`.

**Context file not found**: Skills look for `CHIEF_OF_STAFF_CONTEXT.md` in your project root (the directory where you start Hermes). Make sure it's there.
