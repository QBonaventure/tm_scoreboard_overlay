defmodule TMSO.Repo.Migrations.UpdateNelestaTrigram do
  use Ecto.Migration

  def change do
    TMSO.Repo.get_by(TMSO.Team, name: "Nelesta")
    |> Ecto.Changeset.change(%{shortname: "NLT"})
    |> TMSO.Repo.update
  end
end
