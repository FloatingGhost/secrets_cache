defmodule SecretsCache.MixProject do
  use Mix.Project

  def project do
    [
      app: :secrets_cache,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SecretsCache.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cachex, "~> 3.1"},
      {:secrets, github: "floatingghost/ex_aws_secrets"},
      {:jason, "~> 1.1"}
    ]
  end
end
