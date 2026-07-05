defmodule MyApp.Config.DatabaseNameTest do
  use ExUnit.Case, async: true

  @postgres_identifier_limit 63
  @long_worktree "my_app.feature-def-1862-link-event-to-existing-meeting"

  test "long worktree-derived dev database names fit PostgreSQL identifier limits" do
    database = MyApp.Config.DatabaseName.from_worktree_basename(@long_worktree, "my_app", "dev")

    assert byte_size(database) <= @postgres_identifier_limit

    assert database =~
             ~r/^my_app_feature_def_1862_link_event_to_existing(?:_[a-z0-9]+)?_[a-f0-9]{8}_dev$/

    refute database =~ "__"
  end

  test "long worktree-derived test database names include partitions and fit limits" do
    database = MyApp.Config.DatabaseName.from_worktree_basename(@long_worktree, "my_app", "test7")

    assert byte_size(database) <= @postgres_identifier_limit

    assert database =~
             ~r/^my_app_feature_def_1862_link_event_to_existing(?:_[a-z0-9]+)?_[a-f0-9]{8}_test7$/

    refute database =~ "__"
  end

  test "empty or punctuation-only worktree names still produce a useful name" do
    database = MyApp.Config.DatabaseName.from_worktree_basename("!!!", "my_app", "dev")

    assert database =~ ~r/^my_app_main_[a-f0-9]{8}_dev$/
    assert byte_size(database) <= @postgres_identifier_limit
  end
end
