defmodule TMSO.Repo.Migrations.CreateMatchSettings do
  use Ecto.Migration

  def change do
    create table(:match_overlay_settings) do
      add :user_id, references(:users)
      add :team_a_id, references(:teams)
      add :team_b_id, references(:teams)
      add :settings, :map
      add :submatches, {:array, :map}, default: []
    end
  end
end
