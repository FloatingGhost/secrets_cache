defmodule SecretsCacheTest do
  use ExUnit.Case

  describe "Config merge" do
    test "works for flat keys" do
      secret = %{
        key: "value"
      }
      |> Jason.encode!()

      {:ok, true} = Cachex.put(:aws_secrets_cache, "test", secret)
      Application.put_env(:my_app, :existing_key, "yui")

      result = SecretsCache.get_config(:my_app, "test")
      assert result[:existing_key] == "yui"
      assert result[:key] == "value"
    end

    test "works for embedded keys" do
      secret = %{
        "key.embedded": "value"
      } 
      |> Jason.encode!()

      {:ok, true} = Cachex.put(:aws_secrets_cache, "test", secret)
      Application.put_env(:my_app, :existing_key, "yui")

      result = SecretsCache.get_config(:my_app, "test")
      assert result[:existing_key] == "yui"
      assert result[:key][:embedded] == "value"
    end
  end
end
