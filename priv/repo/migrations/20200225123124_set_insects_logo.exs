defmodule TMSO.Repo.Migrations.SetInsectsLogo do
  use Ecto.Migration
  import Ecto.Query

  def change do
    [
      {"insects", [logo_path: "images/insects.jpg", color: "#80c992"]}
    ]
    |> Enum.each(fn {name, changes} ->
      from(t in TMSO.Team, where: t.name == ^name)
      |> TMSO.Repo.update_all(set: changes)
    end)
  end
end
