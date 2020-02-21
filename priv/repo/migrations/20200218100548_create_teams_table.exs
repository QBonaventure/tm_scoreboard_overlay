defmodule TMSO.Repo.Migrations.CreateTeamsTable do
  use Ecto.Migration

  def up do
    create table(:teams) do
      add :name, :string
      add :shortname, :string
      add :logo_path, :string
      add :color, :string
    end

    create index(:teams, [:name])
    create unique_index(:teams, [:name, :shortname], name: :uk_teams_names_and_shortnames)
    flush()
    add_teams_data()
  end

  def down do
    drop table(:teams)
  end

  def add_teams_data do
    TMSO.Repo.insert_all(
      TMSO.Team,
      [
        %{
          name: "Fear The Coconut - Red Coco",
          shortname: "FTC",
          color: "#cf0000",
          logo_path: "images/FTC.png"
          },
        %{
          name: "Fear The Coconut - Creamy White",
          shortname: "FTC",
          color: "#ece5e5",
          logo_path: "images/FTC.png"
        },
      ]
    )
  end
end
