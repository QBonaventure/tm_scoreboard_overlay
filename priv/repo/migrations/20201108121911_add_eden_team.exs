defmodule TMSO.Repo.Migrations.AddEdenTeam do
  use Ecto.Migration

  def up do
    TMSO.Repo.insert_all(TMSO.Team, [%{name: "eDen eSport", shortname: "EDN", logo_path: "images/eden.jpg", color: "#FF1400"}])
  end

  def down do
    TMSO.Repo.get_by(TMSO.Team, name: "eDen eSport")
    |> TMSO.Repo.delete()
  end
end
