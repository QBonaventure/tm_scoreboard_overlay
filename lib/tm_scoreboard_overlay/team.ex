defmodule TMSO.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  schema "teams" do
    field :name, :string
    field :shortname, :string
    field :logo_path, :string
    field :color, :string
  end

end
