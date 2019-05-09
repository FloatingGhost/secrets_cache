# SecretsCache

A cache and config merger for AWS Secrets. Give it a secret name, and an OTP application
name and it'll resolve the resultant configuration.

For example, let's say you've configured `:my_app` as such

```elixir
config :my_app,
    best_yuru: :yui
```

And you have in AWS a secret named `my_secret`, that looks like
```elixir
{"database": {"username": "user", "password": "heh"}}
```

SecretsCache can resolve this as follows:

```elixir
SecretsCache.get_config(:my_app, "my_secret")
[database: [username: "user", password: "heh"], best_yuru: :yui]
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `secrets_cache` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:secrets_cache, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/secrets_cache](https://hexdocs.pm/secrets_cache).

