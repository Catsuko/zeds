defmodule World.MixProject do
  use Mix.Project

  def project do
    [
      app: :world,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :eex, :wx, :observer, :runtime_tools],
      mod: {World, ["Durotar", "The Barrens", "Stonetalon Mountains"]}
    ]
  end

  defp deps do
    [
      {:cluster_supervisor, in_umbrella: true}
    ]
  end
end
