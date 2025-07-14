defmodule Pusher.MixProject do
  use Mix.Project

  def project do
    [
      app: :pusher,
      version: version(),
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(),
      releases: [pusher: release()],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def release do
    [
      include_executables_for: [:unix],
      include_erts: true,
      strip_beams: true
    ]
  end

  def version do
    "1.0.0"
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Pusher.Application, []}
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.7"},
      {:plug, "~> 1.18"},
      {:phoenix, "~> 1.7.21"},
      {:phoenix_pubsub, "~> 2.1"},
      {:websock, "~> 0.5"},
      {:websock_adapter, "~> 0.5"},
      {:open_api_spex, "~> 3.21"},
      {:joken, "~> 2.6"},
      {:jason, "~> 1.4"},
      {:fresh, "~> 0.4", only: [:dev, :test]}
    ]
  end

  defp elixirc_paths(env \\ Mix.env())
  defp elixirc_paths(:test), do: elixirc_paths(:prod) ++ ["test/support"]
  defp elixirc_paths(:dev), do: elixirc_paths(:test)
  defp elixirc_paths(_), do: ["lib"]
end
