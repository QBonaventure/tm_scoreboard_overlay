defmodule TMSO.Submatch do
  use Ecto.Schema
  alias __MODULE__
  import Ecto.Changeset

  embedded_schema do
    field :tennis_mode, :boolean
    field :max_points, :integer
    field :players_per_team, :integer
    field :map_id, :integer
    field :win_pts_granted, :integer, default: 1
  end

  @req_fields [:tennis_mode, :max_points, :players_per_team, :win_pts_granted]
  def changeset(%Submatch{} = submatch, data \\ %{}) do
    submatch
    |> change
    |> cast(data, @req_fields ++ [:map_id])
    |> validate_required(@req_fields)
  end

end
