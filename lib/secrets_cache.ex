defmodule SecretsCache do
  @moduledoc """
  Documentation for SecretsCache.

  A cache and merger for AWS secrets, with handling for embedded keys
  """
  require Logger

  defp get_secret(name, opts) do
    Cachex.execute(:aws_secrets_cache, fn cache ->
      case Cachex.get(cache, name) do
        {:ok, nil} ->
          Logger.info("Loading secret #{name} from network...")

          %{"SecretString" => value} =
            ExAws.Secrets.get_secret_value(name)
            |> ExAws.request!(region: opts[:region])

          {:ok, true} = Cachex.put(cache, name, value)
          Cachex.get(cache, name)

        {:ok, value} ->
          {:ok, value}
      end
    end)
  end

  @doc """
  Force loading of a secret from the network, even if we have a cached
  version available, then put that value back in the cache.

  Useful if your secret rotates or otherwise changes

      iex> reload_secret("my_secret")
      {:ok, "some_value"}
  """
  def reload_secret(name, opts \\ [region: "eu-west-1"]) do
    Cachex.execute(:aws_secrets_cache, fn cache ->
      Logger.info("Loading secret #{name} from network...")

      %{"SecretString" => value} =
        ExAws.Secrets.get_secret_value(name)
        |> ExAws.request!(region: opts[:region])

      {:ok, true} = Cachex.put(cache, name, value)
      Cachex.get(cache, name)
    end)
  end

  defp put_value(config, keys, value) do
    keys
    |> Enum.with_index()
    |> Enum.reduce(
      config,
      fn {_key, index}, config ->
        keys_to_here = Enum.take(keys, index + 1)
        v = get_in(config, keys_to_here)

        if is_nil(v) do
          put_in(config, keys_to_here, [])
        else
          config
        end
      end
    )
    |> put_in(keys, value)
  end

  @doc """
  Get the config associated with an otp app, and merge in the 
  config described by the secret

  For example, if your secret looks like

      {"database": {"username": "abc", "password": "fff"}, apikey: "123"}

  And your OTP app is configured as such

      config :my_app,
        nice: "meme"

  You can call

      iex> get_config(:my_app, "database_secret")
      [database: [username: "abc", password: "fff"], nice: "meme"]

  Will use the cached secret if available. Use `reload_secret\2` if you need
  to refresh whilst running.
  """
  def get_config(otp_app, secret_name, opts \\ [region: "eu-west-1"]) do
    with {:ok, value} <- get_secret(secret_name, opts),
         {:ok, value} <- Jason.decode(value) do
      base_config = Application.get_all_env(otp_app)

      value
      |> Map.to_list()
      |> Enum.reduce(
        base_config,
        fn {key, value}, config ->
          keys =
            key
            |> String.split(".")
            |> Enum.map(&String.to_atom/1)

          put_value(config, keys, value)
        end
      )
    else
      {:error, reason} ->
        {:error, reason}
    end
  end
end
