# defmodule Semantic.ElixirProjectTest do
#   use ExUnit.Case, async: true

#   project_pattern = "../elixir/**/*.ex{,s}"

#   for path <- Path.wildcard(project_pattern) do
#     test "semantics of #{path} after formatting" do
#       unquote(path)
#       |> File.read!()
#       |> Exfmt.format!()
#     end
#   end
# end
