defmodule TMSO.Repo do
  use Ecto.Repo,
    otp_app: :tm_scoreboard_overlay,
    adapter: Ecto.Adapters.Postgres
end
