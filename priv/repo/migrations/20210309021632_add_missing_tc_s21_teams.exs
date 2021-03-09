defmodule TMSO.Repo.Migrations.AddCps20Teams do
  use Ecto.Migration
  import Ecto.Query

  def up do
    TMSO.Repo.insert_all(TMSO.Team, new_teams_list)

    TMSO.Repo.get_by(TMSO.Team, shortname:"LDG")
    |> Ecto.Changeset.change(%{logo_path: "images/loading_tm.jpg", color: "#199a8f"})
    |> TMSO.Repo.update
  end

  def down do
    new_teams_list
    |> Enum.each(fn team ->
      from(t in TMSO.Team, where: t.name == ^team.name)
      |> TMSO.Repo.delete_all
    end)

    TMSO.Repo.get_by(TMSO.Team, shortname:"LDG")
    |> Ecto.Changeset.change(%{logo_path: "images/Logo_Trackmania.png", color: "#ffffff"})
    |> TMSO.Repo.update
  end

  def new_teams_list do
    [
      %{
        name: "Bestiary",
        shortname: "BST",
        color: "#e41429",
        logo_path: "images/bestiary.png"
      },
      %{
        name: "Engines Stuttgart",
        shortname: "ENG",
        color: "#4cca26",
        logo_path: "images/engines_stuttgart.png"
      },
      %{
        name: "Revival",
        shortname: "RVL",
        color: "#199a8f",
        logo_path: "images/f28705.png"
      },
      %{
        name: "Team Spirit",
        shortname: "TSP",
        color: "#b0b821",
        logo_path: "images/team_spirit.png"
      },
      %{
        name: "Unranked",
        shortname: "UNR",
        color: "#ffffff",
        logo_path: "images/unranked.png"
      },
      %{
        name: "Venalia",
        shortname: "VNL",
        color: "#a1171c",
        logo_path: "images/venalia.png"
      },
      %{
        name: "Venasty",
        shortname: "VST",
        color: "#3d0671",
        logo_path: "images/venasty.png"
      },
      %{
        name: "Vincit",
        shortname: "VCT",
        color: "#10266e",
        logo_path: "images/vincit.png"
      },
      %{
        name: "Random 2.0",
        shortname: "RDM",
        color: "#ffffff",
        logo_path: "images/Logo_Trackmania.png"
      },
    ]
  end

end
