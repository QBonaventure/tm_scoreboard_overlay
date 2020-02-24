defmodule TMSO.Repo.Migrations.FixTeamsShorthandNames do
  use Ecto.Migration
  import Ecto.Query

  def change do
    from(t in TMSO.Team, where: t.name == "Canity", update: [set: [shortname: "CNT"]])
    |> TMSO.Repo.update_all([])
  end
end
