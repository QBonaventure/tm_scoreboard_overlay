defmodule TMSO.Repo.Migrations.AddNumelopsTeam do
  use Ecto.Migration

  def up do
    TMSO.Repo.insert(
        %TMSO.Team{
            name: "Numelops",
            shortname: "NML",
            color: "#ff6600",
            logo_path: "images/numelops.png"
    })
  end

  def down do

  end

end
