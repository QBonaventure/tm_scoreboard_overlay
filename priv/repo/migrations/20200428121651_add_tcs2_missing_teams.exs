defmodule TMSO.Repo.Migrations.AddTcs2MissingTeams do
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
            name: "æ",
            shortname: "AE",
            color: "#054e05",
            logo_path: "images/polaria.png"
    },
        %{
            name: "Blackbird",
            shortname: "BBD",
            color: "#836700",
            logo_path: "images/blackbird.png"
    },
        %{
            name: "Chenil Esport",
            shortname: "CNL",
            color: "#cba675",
            logo_path: "images/Chenil.png"
    },
        %{
            name: "Cyborg",
            shortname: "CBG",
            color: "#dfdfdf",
            logo_path: "images/Cyborg.png"
    },
        %{
            name: "Eclipse Blue",
            shortname: "ECL",
            color: "#12499a",
            logo_path: "images/Eclipse2.png"
    },
        %{
            name: "Eclipse Orange",
            shortname: "ECL",
            color: "#c14e12",
            logo_path: "images/Eclipse.png"
    },
        %{
            name: "Exalty",
            shortname: "EXY",
            color: "#369dc8",
            logo_path: "images/Exalty.png"
    },
        %{
            name: "Hypnotik",
            shortname: "HYP",
            color: "#e3a9a4",
            logo_path: "images/Hypnotik.png"
    },
        %{
            name: "Loyalty",
            shortname: "LYT",
            color: "#00b9fd",
            logo_path: "images/Loyalty.png"
    },
        %{
            name: "NCBz",
            shortname: "NCB",
            color: "#2d4fbe",
            logo_path: "images/NCBz.png"
    },
        %{
            name: "orKsGP",
            shortname: "OGP",
            color: "#e31b22",
            logo_path: "images/orKsGp.png"
    },
        %{
            name: "Proxiz",
            shortname: "PXZ",
            color: "#24da3d",
            logo_path: "images/PxZ.png"
    },
        %{
            name: "Team Q",
            shortname: "TQ",
            color: "#ef5ea2",
            logo_path: "images/Q.png"
    },
        %{
            name: "SunSet",
            shortname: "SNS",
            color: "#d11919",
            logo_path: "images/Sunset.png"
    },
        %{
            name: "Tsun",
            shortname: "TSN",
            color: "#007eff",
            logo_path: "images/Tsun.png"
    },
        %{
            name: "Vitilia",
            shortname: "VTL",
            color: "#09cbca",
            logo_path: "images/vitilia.png"
    },
        %{
            name: "WazoBleu",
            shortname: "WB",
            color: "#40c8f4",
            logo_path: "images/WazoBleu.png"
    },
    %{
            name: "I Care",
            shortname: "IC",
            color: "#fff",
            logo_path: "images/Logo_Trackmania.png"
    },
    %{
            name: "Marabout",
            shortname: "MBT",
            color: "#fff",
            logo_path: "images/Logo_Trackmania.png"
    },
    %{
            name: "Retarded Players Gang",
            shortname: "RPG",
            color: "#fff",
            logo_path: "images/Logo_Trackmania.png"
    },
    %{
            name: "Šibice",
            shortname: "SBC",
            color: "#fff",
            logo_path: "images/Logo_Trackmania.png"
    },
    %{
            name: "The Worst",
            shortname: "TW",
            color: "#fff",
            logo_path: "images/Logo_Trackmania.png"
    }
  ]
  end

end
