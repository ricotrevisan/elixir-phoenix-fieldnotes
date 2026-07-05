# Elixir Phoenix Fieldnotes

A growing collection of practical recipes, snippets, and notes for Phoenix, Ash, Pi, and local-development workflows.

This repo is intentionally practical: every full recipe should explain the problem, show the smallest useful solution, include copy/pasteable snippets, and say how the idea was verified.

In this repo, **Pi** means the coding-agent harness I use for development workflows. Planned recipes may also mention tools like **Varlock** for environment contracts and **Tidewave** for Phoenix development workflows; those notes stay marked as planned until they are extracted into complete recipes.

## Recipes

| Status | Recipe | What it solves |
| --- | --- | --- |
| proven | [Worktree-safe Postgres database names for Phoenix](recipes/phoenix/worktree-postgres-db-names) | Keeps dev/test DB names deterministic and under PostgreSQL's 63-byte identifier limit when branch or worktree names get long. |
| planned | [Phoenix + Varlock](recipes/phoenix/varlock) | Capture environment contracts in a Phoenix app. |
| planned | [Tidewave with Pi](recipes/pi/tidewave-with-pi) | Use Tidewave from a Pi-assisted workflow. |
| planned | [Initial Ash project setup](recipes/ash/initial-project-setup) | Opinionated starting point for Ash/Phoenix apps. |

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

- `planned` — placeholder for an idea that has not been extracted yet.
- `draft` — promising idea, partially extracted, not fully proven as a reusable recipe.
- `proven` — used successfully in a real project.
- `needs-refresh` — likely useful, but dependency or framework versions have moved.

Issues are welcome for recipe ideas, corrections, and better snippets.

## Copy/paste policy

Code snippets are MIT licensed. Use them freely in your projects.

The prose is also intentionally open: if a note helps you, copy the pattern and credit this repo if convenient.
