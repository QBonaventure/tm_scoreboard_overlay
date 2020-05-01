defmodule TMSO.Repo.Migrations.AddAndUpdateTeamsLogos do
  use Ecto.Migration
  import Ecto.Query

  def change do
    [
      {"Astro", [logo_path: "images/astro.png", color: "#64e55a"]},
      {"Dac-Sp", [logo_path: "images/dacsp.png"]},
      {"Elite", [logo_path: "images/elite.png", color: "#b0fe47"]},
      {"Team Flex", [logo_path: "images/flex.png", color: "#3385d9"]},
      {"Team HOT", [logo_path: "images/hot.png", color: "#e50301"]},
      {"Funtime", [logo_path: "images/funtime.png", color: "#9900cc"]},
      {"Lumin Hybrid", [logo_path: "images/luminhybrid.png", color: "#27c3ff"]},
      {"Poz", [logo_path: "images/poz.png", color: "#2a2a2a"]},
      {"Project Conquerors", [logo_path: "images/pcs.png", color: "#9a1d15"]},
      {"ReaWall", [logo_path: "images/reawall.png", color: "#000000"]},
      {"Team 300", [logo_path: "images/300.png"]},
      {"Team Smurfs", [logo_path: "images/smurfs.png", color: "#59abf1"]},
      {"Trackmania Heroes Europe", [logo_path: "images/the.png"]},
      {"Ubiteam", [logo_path: "images/ubiteam.png", color: "#ae2139"]},
      {"Unity", [logo_path: "images/unity.png", color: "#000000"]},
      {"Zapasy", [logo_path: "images/zapasy.png", color: "#00ffff"]},
      {"ZeyRo", [logo_path: "images/zeyro.png", color: "#10163b"]},
      {"Power of Teamplay", [logo_path: "images/pot.png", color: "#4b5f9e"]}
    ]
    |> Enum.each(fn {name, changes} ->
      from(t in TMSO.Team, where: t.name == ^name)
      |> TMSO.Repo.update_all(set: changes)
    end)
  end
end
