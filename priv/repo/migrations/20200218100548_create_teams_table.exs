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
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "beGenius",
          shortname: "BGN",
          color: "#f6a119",
          logo_path: "images/begenius.png"
        },
        %{
          name: "Canity",
          shortname: "FTC",
          color: "#914d99",
          logo_path: "images/canity.png"
        },
        %{
          name: "Dac-Sp",
          shortname: "DSP",
          color: "#095bf2",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Druidz Esports",
          shortname: "DDZ",
          color: "#43aeda",
          logo_path: "images/Druidz.png"
        },
        %{
          name: "Elementaries",
          shortname: "ELT",
          color: "#f68e1f",
          logo_path: "images/Elementaries.png"
        },
        %{
          name: "Elite",
          shortname: "ELE",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Evoleaf",
          shortname: "EVL",
          color: "#198a3f",
          logo_path: "images/EVOLEAF_logo.png"
        },
        %{
          name: "Failen 9",
          shortname: "FLN",
          color: "#f2902e",
          logo_path: "images/F9_logo_black.png"
        },
        %{
          name: "Team Flex",
          shortname: "TF",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Team HOT",
          shortname: "HOT",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Foenix Gaming",
          shortname: "FG",
          color: "#b11f24",
          logo_path: "images/Foenix.png"
        },
        %{
          name: "For the Bois",
          shortname: "FTB",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Funtime",
          shortname: "FT",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Gaming 4 Seasons",
          shortname: "GS",
          color: "#662d91",
          logo_path: "images/G4s_logo.png"
        },
        %{
          name: "Hardcore Power Drivers",
          shortname: "HPD",
          color: "#880907",
          logo_path: "images/hpD.png"
        },
        %{
          name: "insects",
          shortname: "INS",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Lambda Kappa",
          shortname: "LK",
          color: "#e30613",
          logo_path: "images/Lambdakappa_logo.png"
        },
        %{
          name: "Last But Not Least",
          shortname: "LBN",
          color: "#9a813f",
          logo_path: "images/LBNL.png"
        },
        %{
          name: "Lumin Hybrid",
          shortname: "LHD",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
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
          name: "Ombra Esport",
          shortname: "OMB",
          color: "#b42184",
          logo_path: "images/Ombra.png"
        },
        %{
          name: "Poz",
          shortname: "POZ",
          color: "#222222",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Project Conquerors",
          shortname: "PCS",
          color: "#ab200f",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "ReaWall",
          shortname: "RW",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Skylab",
          shortname: "SKL",
          color: "#0077a1",
          logo_path: "images/SkyLab.png"
        },
        %{
          name: "Team 300",
          shortname: "300",
          color: "#5b8eba",
          logo_path: "images/FTC.png"
        },
        %{
          name: "Team Gros Nul",
          shortname: "TGN",
          color: "#93ff29",
          logo_path: "images/TGN.jpg"
        },
        %{
          name: "Team Smurfs",
          shortname: "TSM",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
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
          name: "Ubiteam",
          shortname: "UBI",
          color: "#b22139",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Unity",
          shortname: "UNI",
          color: "#000000",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Unsymeria Futuroscope",
          shortname: "UNS",
          color: "#7db703",
          logo_path: "images/Unsymeria.png"
        },
        %{
          name: "Venture Esports",
          shortname: "VEN",
          color: "#328fc1",
          logo_path: "images/Venture.png"
        },
        %{
          name: "Zapasy",
          shortname: "ZPY",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "ZeyRo",
          shortname: "ZRO",
          color: "#",
          logo_path: "images/Logo_Trackmania.svg"
        },
        %{
          name: "Power of Teamplay",
          shortname: "POT",
          color: "#fff",
          logo_path: "images/Logo_Trackmania.svg"
        }
      ]
    )
  end
end
