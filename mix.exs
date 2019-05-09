defmodule SecretsCache.MixProject do
  use Mix.Project

  def project do
    [
      app: :secrets_cache,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "A cache and config merger for AWS SecretManager"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SecretsCache.Application, []}
    ]
  end

  defp package do
    [
      maintainers: ["FloatingGhost"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/FloatingGhost/secrets_cache"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cachex, "~> 3.1"},
      {:secrets, "~> 0.1.0"},
      {:jason, "~> 1.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
