defmodule TMSO.Repo.Migrations.UpdateTmLogoPath do
  use Ecto.Migration
  import Ecto.Query

  def up do
    from(t in TMSO.Team, where: t.logo_path == "images/Logo_Trackmania.svg", update: [set: [logo_path: "images/Logo_Trackmania.png"]])
    |> TMSO.Repo.update_all([])
  end

  def down do
    from(t in TMSO.Team, where: t.logo_path == "images/Logo_Trackmania.png", update: [set: [logo_path: "images/Logo_Trackmania.svg"]])
    |> TMSO.Repo.update_all([])
  end
end
