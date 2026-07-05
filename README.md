# Elixir Phoenix Fieldnotes

Battle-tested recipes, snippets, and notes for Phoenix, Ash, Pi, and local-development workflows.

This repo is intentionally practical: every recipe should explain the problem, show the smallest useful solution, include copy/pasteable snippets, and say how the idea was verified.

## Recipes

| Status | Recipe | What it solves |
| --- | --- | --- |
| Proven | [Worktree-safe Postgres database names for Phoenix](recipes/phoenix/worktree-postgres-db-names) | Keeps dev/test DB names deterministic and under PostgreSQL's 63-byte identifier limit when branch or worktree names get long. |
| Planned | [Phoenix + Varlock](recipes/phoenix/varlock) | Capture environment contracts in a Phoenix app. |
| Planned | [Tidewave with Pi](recipes/pi/tidewave-with-pi) | Use Tidewave from a Pi-assisted workflow. |
| Planned | [Initial Ash project setup](recipes/ash/initial-project-setup) | Opinionated starting point for Ash/Phoenix apps. |

## Recipe format

Each recipe follows the same shape:

1. **Problem** — what broke or what hurt.
2. **When to use this** — constraints and fit.
3. **Solution** — the design in plain English.
4. **Copy/paste snippets** — code you can adapt.
5. **Verification** — commands or checks that prove it works.
6. **Tradeoffs** — what this approach does not solve.
7. **Source / proven in** — where this came from.

Use [`templates/recipe.md`](templates/recipe.md) for new entries.

## Build-in-public notes

This is a living field notebook. Recipes can be rough at first, as long as they are honest about their status:

- `draft` — promising idea, not fully extracted yet.
- `proven` — used successfully in a real project.
- `needs-refresh` — likely useful, but dependency or framework versions have moved.

Issues are welcome for recipe ideas, corrections, and better snippets.

## Copy/paste policy

Code snippets are MIT licensed. Use them freely in your projects.

The prose is also intentionally open: if a note helps you, copy the pattern and credit this repo if convenient.
