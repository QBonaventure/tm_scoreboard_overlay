use Mix.Config

# Configure your database
config :tm_scoreboard_overlay, TMSO.Repo,
  username: "postgres",
  password: "postgres",
  database: "tm_scoreboard_overlay_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tm_scoreboard_overlay, TMSOWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
