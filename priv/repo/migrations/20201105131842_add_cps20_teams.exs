defmodule TMSO.Repo.Migrations.AddCps20Teams do
  use Ecto.Migration
  import Ecto.Query

  def up do
    TMSO.Repo.insert_all(TMSO.Team, new_teams_list)

    TMSO.Repo.get(TMSO.Team, 49)
    |> Ecto.Changeset.change(%{shortname: "HK", logo_path: "images/hypnotik2.jpg", color: "#ff0617"})
    |> TMSO.Repo.update

    TMSO.Repo.get(TMSO.Team, 32)
    |> Ecto.Changeset.change(%{logo_path: "images/thc2.jpg", name: "Tetrahydrocannabinol"})
    |> TMSO.Repo.update
  end

  def down do
    new_teams_list
    |> Enum.each(fn team ->
      from(t in TMSO.Team, where: t.name == ^team.name)
      |> TMSO.Repo.delete_all
    end)

    TMSO.Repo.get(TMSO.Team, 49)
    |> Ecto.Changeset.change(%{shortname: "HK", logo_path: "images/Hypnotik.png", color: "#e3a9a4"})
    |> TMSO.Repo.update

    TMSO.Repo.get(TMSO.Team, 32)
    |> Ecto.Changeset.change(%{logo_path: "images/THC.png", name: "Tetra Hydro Cannabinol"})
    |> TMSO.Repo.update
  end

  def new_teams_list do
    [
      %{
        name: "Polaria Esport",
        shortname: "POL",
        color: "#286ea0",
        logo_path: "images/polaria.jpg"
      },
      %{
        name: "Spam Team",
        shortname: "SPM",
        color: "#0555c8",
        logo_path: "images/spam.jpg"
      },
      %{
        name: "4 Wheels",
        shortname: "FW",
        color: "#0185fb",
        logo_path: "images/4wheels.jpg"
      },
      %{
        name: "Team Shift",
        shortname: "TS",
        color: "#ffffff",
        logo_path: "images/shift.jpg"
      },
      %{
        name: "Minus & Cortex",
        shortname: "MC",
        color: "#ffe400",
        logo_path: "images/minuscortex.jpg"
      },
      %{
        name: "Immuta Tech",
        shortname: "IMT",
        color: "#000035",
        logo_path: "images/immuta.jpg"
      },
      %{
        name: "Purge ESC",
        shortname: "PRG",
        color: "#6e0000",
        logo_path: "images/purge.jpg"
      },
      %{
        name: "SG eSports",
        shortname: "SG",
        color: "#b31c3b",
        logo_path: "images/sg.jpg"
      },
      %{
        name: "Team Exotik",
        shortname: "EXO",
        color: "#0e0e0e",
        logo_path: "images/exotik.jpg"
      },
      %{
        name: "Team Titan TM",
        shortname: "TTT",
        color: "#9d793f",
        logo_path: "images/teamtitan.jpg"
      },
      %{
        name: "Nelesta",
        shortname: "NLS",
        color: "#5269EA",
        logo_path: "images/nelesta.jpg"
      },
      %{
        name: "Next Event Jaune",
        shortname: "NEJ",
        color: "#ffe228",
        logo_path: "images/nexteventjaune.jpg"
      },
      %{
        name: "Next Event Orange",
        shortname: "NEO",
        color: "#F3861B",
        logo_path: "images/nexteventorange.jpg"
      },
      %{
        name: "Sharks Black",
        shortname: "SHK",
        color: "#454adb",
        logo_path: "images/sharks.jpg"
      },
      %{
        name: "Cannabidiol",
        shortname: "CBD",
        color: "#6fc952",
        logo_path: "images/cbd.jpg"
      },
      %{
        name: "Evodream",
        shortname: "EVD",
        color: "#ffffff",
        logo_path: "images/Logo_Trackmania.png"
      },
      %{
        name: "We All Care",
        shortname: "WAC",
        color: "#ffffff",
        logo_path: "images/Logo_Trackmania.png"
      },
      %{
        name: "WeArePositive",
        shortname: "WAP",
        color: "#ffffff",
        logo_path: "images/Logo_Trackmania.png"
      },
      %{
        name: "Tenescia",
        shortname: "TNS",
        color: "#ffffff",
        logo_path: "images/Logo_Trackmania.png"
      },
      %{
        name: "LoadingTM",
        shortname: "LTM",
        color: "#ffffff",
        logo_path: "images/Logo_Trackmania.png"
      },
      %{
        name: "UK & Ireland",
        shortname: "UKI",
        color: "#ffffff",
        logo_path: "images/Logo_Trackmania.png"
      }
    ]
  end

end
