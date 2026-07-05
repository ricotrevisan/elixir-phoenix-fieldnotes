# Contributing

Thanks for helping turn field notes into reusable recipes.

## What belongs here?

Good entries are practical notes from real Phoenix, Ash, Elixir, or Pi work:

- local-development fixes
- setup recipes
- integration notes
- snippets with verification commands
- small conventions that prevent recurring mistakes

## Recipe lifecycle

Use one of these statuses near the top of each recipe:

- `draft` — idea captured, not fully extracted.
- `proven` — used successfully in a real project.
- `needs-refresh` — useful historically, but likely needs version updates.

## New recipe checklist

- [ ] Start from [`templates/recipe.md`](templates/recipe.md).
- [ ] Explain the failure mode or motivation.
- [ ] Include copy/pasteable snippets when possible.
- [ ] Include verification commands.
- [ ] Document tradeoffs and when not to use it.
- [ ] Mark the recipe status honestly.

## Local checks

Run:

```bash
scripts/check-snippets
```

This repo is mostly Markdown, so checks are intentionally lightweight.
