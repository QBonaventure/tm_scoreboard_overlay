defmodule TMSO.Submatch do
  use Ecto.Schema
  alias __MODULE__
  import Ecto.Changeset

  embedded_schema do
    field :tennis_mode, :boolean
    field :max_points, :integer
    field :players_per_team, :integer
  end

  @req_fields [:tennis_mode, :max_points, :players_per_team]
  def changeset(%Submatch{} = submatch, data \\ %{}) do
    submatch
    |> change
    |> cast(data, @req_fields)
    |> validate_required(@req_fields)
  end

end
