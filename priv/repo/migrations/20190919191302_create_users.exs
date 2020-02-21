defmodule TeamHeda.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nickname, :string
      timestamps()
    end

    create index(:users, [:nickname])
  end

end
