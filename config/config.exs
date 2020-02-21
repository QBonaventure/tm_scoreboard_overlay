# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

config :tm_scoreboard_overlay,
  namespace: TMSO,
  ecto_repos: [TMSO.Repo]

# Configures the endpoint
config :tm_scoreboard_overlay, TMSOWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2AbbuKMnKMOLKSw28SxoTDjII8heox0w1Z/au7yJwIJtH3gkKSYseRPdsk0ugNC7",
  render_errors: [view: TMSOWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TMSO.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "hhiBSDHPRQki1PpMiSjZAc6ETqc9Vro7BFhTB9YF3oWnVpVJ+syOrPISLzBTn7qZ"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
