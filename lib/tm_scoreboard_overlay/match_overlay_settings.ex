defmodule TMSO.MatchOverlaySettings do
  use Ecto.Schema
  alias __MODULE__
  alias TMSO.{Submatch,User,Team,MatchSettings}
  import Ecto.Changeset

  schema "match_overlay_settings" do
    belongs_to :user, User
    belongs_to :team_a, Team
    belongs_to :team_b, Team
    embeds_one :settings, MatchSettings
    embeds_many :submatches, Submatch
  end

  @req_fields [:user_id, :team_a_id, :team_b_id, :submatches, :settings]
  def changeset(%MatchOverlaySettings{} = mos, data \\ %{}) do
    mos
    |> change
    |> cast(data, [:user_id, :team_a_id, :team_b_id])
    |> cast_embed(:settings)
    |> cast_embed(:submatches)
    |> validate_required(@req_fields)
  end

end
