# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :formerer, Formerer.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "1BtnYgLu2Iqq580hgcweNKDdRvVwa82Hi//QSHjkmzpc+EEMhZX+LIPDrMDEZ9/Z",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Formerer.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :formerer, ecto_repos: [Formerer.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
