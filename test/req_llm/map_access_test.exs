defmodule ReqLLM.MapAccessTest do
  use ExUnit.Case, async: true

  alias ReqLLM.MapAccess

  describe "get/3" do
    test "returns false stored under the exact atom key" do
      assert MapAccess.get(%{stream?: false}, :stream?) == false
    end

    test "returns false stored under the exact string key" do
      assert MapAccess.get(%{"stream?" => false}, "stream?") == false
    end

    test "falls back to the string alias when the atom key is nil" do
      assert MapAccess.get(%{"cached_tokens" => 5}, :cached_tokens) == 5
    end

    test "falls back to the atom alias when the string key is nil" do
      assert MapAccess.get(%{cached_tokens: 5}, "cached_tokens") == 5
    end

    test "returns the default when the key is absent in both key forms" do
      assert MapAccess.get(%{}, :cached_tokens, 0) == 0
      assert MapAccess.get(%{"other" => 1}, "cached_tokens", 0) == 0
    end

    test "returns the default for non-map input" do
      assert MapAccess.get(nil, :key, :default) == :default
      assert MapAccess.get(nil, "key", :default) == :default
    end
  end

  describe "get_raw/3" do
    test "returns false stored under either key form" do
      assert MapAccess.get_raw(%{input_includes_cached: false}, :input_includes_cached) == false
      assert MapAccess.get_raw(%{"input_includes_cached" => false}, :input_includes_cached) ==
               false
    end

    test "does not create new atoms for unknown string keys" do
      unique_key = "definitely_not_an_existing_atom_#{System.unique_integer()}"

      assert MapAccess.get_raw(%{unique_key => 1}, unique_key) == 1
      assert MapAccess.get_raw(%{}, unique_key, :fallback) == :fallback
    end
  end
end
