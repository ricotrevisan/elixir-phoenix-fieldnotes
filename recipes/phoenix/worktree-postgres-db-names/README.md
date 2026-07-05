# Worktree-safe Postgres database names for Phoenix

**Status:** proven  
**Stack:** Phoenix, Ecto/AshPostgres, PostgreSQL  
**Last verified:** 2026-07-05

## Problem

A common Phoenix local-development pattern is to derive the dev/test database name from the current worktree or branch name:

```elixir
worktree_name =
  File.cwd!()
  |> Path.basename()
  |> String.replace(~r/[^a-zA-Z0-9_]/, "_")

database: "my_app_#{worktree_name}_dev"
```

That works until branch/worktree names get long, for example:

```text
my_app.feature-def-1862-link-event-to-existing-meeting
```

PostgreSQL identifiers are limited to 63 bytes. If the generated database name is longer than that, Postgres truncates the identifier during creation, while your app still tries to connect to the full name.

The failure can look confusing:

```text
The database for MyApp.Repo has already been created
FATAL 3D000 (invalid_catalog_name) database "my_app_my_app_feature_def_1862_link_event_to_existing_meeting_dev" does not exist
```

## When to use this

Use this when:

- you use git worktrees for Phoenix development;
- dev/test database names include a branch, folder, or worktree slug;
- your team uses descriptive branch names;
- you still want each worktree to get an isolated local database by default.

Do not use this if:

- every local checkout should intentionally share one `my_app_dev` database;
- your app never derives database names from filesystem or branch names.

You can still opt into a shared database with an environment override:

```bash
DATABASE_NAME=my_app_dev mix setup
TEST_DATABASE_NAME=my_app_test mix test
```

## Solution

Generate the database name from four parts:

1. a short app prefix, such as `my_app`;
2. a sanitized/truncated worktree slug;
3. a short hash of the original worktree name;
4. a suffix, such as `dev`, `test`, or `test7`.

That produces readable names with collision resistance while staying under PostgreSQL's 63-byte identifier limit:

```text
my_app_feature_def_1862_link_event_to_existing_me_a1b2c3d4_dev
```

The hash matters because two long branch names can share the same truncated prefix.

## Copy/paste snippets

Copy [`snippets/database_name.exs`](snippets/database_name.exs) into your Phoenix project as:

```text
config/database_name.exs
```

Then rename `MyApp.Config.DatabaseName` to your real application module, for example `Acme.Config.DatabaseName`.

### `config/dev.exs`

```elixir
import Config

Code.require_file("database_name.exs", __DIR__)

default_database_name = MyApp.Config.DatabaseName.for_worktree("my_app", "dev")

config :my_app, MyApp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: System.get_env("DATABASE_NAME", default_database_name),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

### `config/test.exs`

Keep CI stable, but use worktree-safe names locally:

```elixir
import Config

Code.require_file("database_name.exs", __DIR__)

partition = System.get_env("MIX_TEST_PARTITION")

default_test_database =
  if System.get_env("CI") do
    "my_app_test#{partition}"
  else
    MyApp.Config.DatabaseName.for_worktree("my_app", "test#{partition}")
  end

config :my_app, MyApp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: System.get_env("TEST_DATABASE_NAME", default_test_database),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2
```

### Optional regression test

Adapt [`snippets/database_name_test.exs`](snippets/database_name_test.exs) into your app's test suite if you want to lock the behavior down.

If your test reads config files with `Config.Reader`, remember that config files use the current working directory, so a regression test may need to temporarily `File.cd!/2` into a fake long worktree directory.

## Verification

In a Phoenix project:

```bash
mix format config/dev.exs config/test.exs config/database_name.exs
mix test test/config/database_name_test.exs
mix ecto.create
mix ecto.migrate
```

For AshPostgres projects that use Ash setup tasks:

```bash
mix ash.setup
```

To inspect the generated local dev database name:

```bash
mix run -e 'IO.puts(Application.fetch_env!(:my_app, MyApp.Repo)[:database])'
```

Expected behavior:

- generated names are `<= 63` bytes;
- `DATABASE_NAME` and `TEST_DATABASE_NAME` still override the defaults;
- CI test databases keep their existing stable names;
- `mix ecto.create` and the app connect to the same database name.

## Tradeoffs

- Renaming the worktree directory changes the default database name, because the hash is based on the directory basename.
- Old local databases are not renamed automatically. Drop them manually when they are no longer useful.
- The snippet assumes ASCII-safe database identifiers after slugification.
- Prefixes and suffixes are capped to keep the whole name safe. Keep them short and boring.

## Source / proven in

Extracted from a Phoenix/Ash project after a long feature worktree produced a 67-byte database name. Postgres created the truncated 63-byte identifier, while the app tried to connect to the untruncated name. The fix was verified with the app's config regression test and full precommit suite.
