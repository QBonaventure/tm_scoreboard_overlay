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
          name: "Fear The Coconut",
          shortname: "FTC",
          color: "#cf0000",
          logo_path: "images/FTC.png"
          },
        %{
          name: "Astro",
          shortname: "AST",
          color: "#fff",
          logo_path: "images/Astro.jpg"
        },
        %{
          name: "beGenius",
          shortname: "BGN",
          color: "#f6a119",
          logo_path: "images/begenius.png"
        },
        %{
          name: "Canity",
          shortname: "CNT",
          color: "#914d99",
          logo_path: "images/canity.png"
        },
        %{
          name: "Dac-Sp",
          shortname: "DSP",
          color: "#095bf2",
          logo_path: "images/dacsp.png"
        },
        %{
          name: "Elementaries",
          shortname: "ELT",
          color: "#f68e1f",
          logo_path: "images/Elementaries.png"
        },
        %{
          name: "Team HOT",
          shortname: "HOT",
          color: "#fff",
          logo_path: "images/hot.png"
        },
        %{
          name: "Funtime",
          shortname: "FT",
          color: "#fff",
          logo_path: "images/funtime.png"
        },
        %{
          name: "Gaming 4 Seasons",
          shortname: "GFS",
          color: "#662d91",
          logo_path: "images/G4s_logo.png"
        },
        %{
          name: "Lambda Kappa",
          shortname: "LK",
          color: "#e30613",
          logo_path: "images/Lambdakappa_logo.png"
        },
        %{
          name: "MnM Gaming",
          shortname: "MNM",
          color: "#f7932a",
          logo_path: "images/MnM.png"
        },
        %{
          name: "Nordic Skirmishers",
          shortname: "NS",
          color: "#9bc0ff",
          logo_path: "images/Nordic_skirmishers.png"
        },
        %{
          name: "Project Conquerors",
          shortname: "PCS",
          color: "#ab200f",
          logo_path: "images/pcs.png"
        },
        %{
          name: "Team 300",
          shortname: "300",
          color: "#5b8eba",
          logo_path: "images/300.png"
        },
        %{
          name: "Tetra Hydro Cannabinol",
          shortname: "THC",
          color: "#6fc952",
          logo_path: "images/THC.png"
        },
        %{
          name: "Trackmania Heroes Europe",
          shortname: "THE",
          color: "#3497fd",
          logo_path: "images/THE_Blue.png"
        },
        %{
          name: "ZeyRo",
          shortname: "ZRO",
          color: "#",
          logo_path: "images/zeyro.png"
        },
        %{
          name: "Numelops",
          shortname: "NML",
          color: "#ff6600",
          logo_path: "images/numelops.png"
        },
        %{
          name: "Eclipse",
          shortname: "ECL",
          color: "#12499a",
          logo_path: "images/Eclipse2.png"
        },
        %{
          name: "orKsGP",
          shortname: "OGP",
          color: "#e31b22",
          logo_path: "images/orKsGp.png"
        },
        %{
          name: "Team Shift",
          shortname: "TS",
          color: "#ffffff",
          logo_path: "images/shift.jpg"
        },
        %{
          name: "Immuta Tech",
          shortname: "IMT",
          color: "#000035",
          logo_path: "images/immuta.jpg"
        },
        %{
          name: "Nelesta",
          shortname: "NLT",
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
          logo_path: "images/revival.png"
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
          name: "Loading TM",
          shortname: "LDG",
          color: "#199a8f",
          logo_path: "images/loading_tm.png"
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
    )
  end
end
