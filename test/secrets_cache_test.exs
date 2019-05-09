defmodule SecretsCacheTest do
  use ExUnit.Case
  doctest SecretsCache

  test "greets the world" do
    assert SecretsCache.hello() == :world
  end
end
