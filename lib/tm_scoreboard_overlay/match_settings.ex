defmodule TMSO.MatchSettings do
  alias __MODULE__
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :overall_bonus_point?, :boolean, default: false
    field :overall_golden_point?, :boolean, default: false
  end

  @req_fields [:overall_bonus_point?, :overall_golden_point?]
  def changeset(%MatchSettings{} = settings, data \\ %{}) do
    settings
    |> cast(data, @req_fields)
    |> validate_required(@req_fields)
  end

end
