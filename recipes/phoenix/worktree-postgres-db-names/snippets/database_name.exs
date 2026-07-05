defmodule MyApp.Config.DatabaseName do
  @moduledoc """
  Builds deterministic, PostgreSQL-safe database names for local worktrees.

  Copy this file to `config/database_name.exs`, then rename `MyApp` to your
  application module.
  """

  @postgres_identifier_limit 63
  @hash_length 8
  @prefix_length_limit 24
  @suffix_length_limit 16

  def for_worktree(prefix, suffix, opts \\ [])
      when is_binary(prefix) and is_binary(suffix) do
    opts
    |> Keyword.get(:cwd, File.cwd!())
    |> Path.basename()
    |> from_worktree_basename(prefix, suffix)
  end

  def from_worktree_basename(worktree_basename, prefix, suffix)
      when is_binary(worktree_basename) and is_binary(prefix) and is_binary(suffix) do
    prefix = prefix |> slugify_part() |> limit_part(@prefix_length_limit) |> default_part("app")
    suffix = suffix |> slugify_part() |> limit_part(@suffix_length_limit) |> default_part("dev")

    slug =
      worktree_basename
      |> slugify_part()
      |> String.replace_prefix("#{prefix}_", "")
      |> default_part("main")

    hash = worktree_hash(worktree_basename)
    max_slug_length = @postgres_identifier_limit - byte_size("#{prefix}__#{hash}_#{suffix}")

    truncated_slug =
      slug
      |> String.slice(0, max(max_slug_length, 0))
      |> String.trim("_")

    [prefix, truncated_slug, hash, suffix]
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("_")
  end

  defp slugify_part(part) do
    part
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "_")
    |> String.trim("_")
  end

  defp limit_part(part, max_length) do
    part
    |> String.slice(0, max_length)
    |> String.trim("_")
  end

  defp default_part("", default), do: default
  defp default_part(part, _default), do: part

  defp worktree_hash(worktree_basename) do
    :sha256
    |> :crypto.hash(worktree_basename)
    |> Base.encode16(case: :lower)
    |> binary_part(0, @hash_length)
  end
end
