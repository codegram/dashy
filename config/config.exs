# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dashy,
  ecto_repos: [Dashy.Repo]

# Configures the endpoint
config :dashy, DashyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aolxoORjdoDyW02zzqvJvVDSe3zaT/Gimz5o5CHsao8oz5JYVLtUl3xEpJ2wbqBP",
  render_errors: [view: DashyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Dashy.PubSub,
  live_view: [signing_salt: "y4Dah9+Z"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :dashy, Dashy.Repo, migration_timestamps: [type: :utc_datetime_usec]

config :dashy, Dashy.Fetcher, token: System.get_env("GITHUB_TOKEN")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
