defmodule TMSO.Repo.Migrations.FixTeamsData do
    use Ecto.Migration
    import Ecto.Query

    def change do
      from(t in TMSO.Team, where: t.name == "Astro", update: [set: [logo_path: "images/Astro.jpg"]])
      |> TMSO.Repo.update_all([])
      from(t in TMSO.Team, where: t.shortname == "GS", update: [set: [shortname: "GFS"]])
      |> TMSO.Repo.update_all([])
    end
  end
