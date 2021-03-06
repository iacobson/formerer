defmodule Formerer.Mixfile do
  use Mix.Project

  def project do
    [app: :formerer,
      version: "0.0.1",
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases,
      deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Formerer, []},
      applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
        :phoenix_ecto, :postgrex, :httpotion, :comeonin, :timex, :timex_ecto,
        :swoosh, :phoenix_swoosh]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support", "test/factories"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0-rc"},
      {:postgrex, ">= 0.11.0"},
      {:phoenix_html, "~> 2.3"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.9"},
      {:comeonin, "~> 2.0"},
      {:uuid, "~> 1.1" },
      {:hound, "~> 1.0", only: :test},
      {:ex_machina, "~> 1.0", only: :test},
      {:httpotion, "~> 3.0"},
      {:poison, "~> 2.0"},
      {:cowboy, "~> 1.0"},
      {:timex, "~> 2.1"},
      {:timex_ecto, "~> 1.0"},
      {:swoosh, "~> 0.3"},
      {:phoenix_swoosh, "~> 0.1"}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
