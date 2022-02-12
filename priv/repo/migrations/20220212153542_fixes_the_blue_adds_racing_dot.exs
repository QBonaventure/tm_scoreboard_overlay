defmodule TMSO.Repo.Migrations.AddCps20Teams do
  use Ecto.Migration
  import Ecto.Query

  def up do
    TMSO.Repo.insert_all(TMSO.Team, new_teams_list)
  end

  def down do
    new_teams_list
    |> Enum.each(fn team ->
      from(t in TMSO.Team, where: t.name == ^team.name)
      |> TMSO.Repo.delete_all
    end)
  end

  def new_teams_list do
    [
      %{
        name: "Racing Dot",
        shortname: "RDT",
        color: "#e42d9f",
        logo_path: "images/zephyr.png"
      },
    ]
  end

end
