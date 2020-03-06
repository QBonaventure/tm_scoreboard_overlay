defmodule TMSO.Repo.Migrations.AddDefaultSettingsOverallPointsField do
  use Ecto.Migration
  alias TMSO.{Repo,MatchOverlaySettings,MatchSettings}
  import Ecto.Query

  def up do
    from(o in MatchOverlaySettings,
      update: [set: [settings: ^%MatchSettings{}]])
    |> Repo.update_all([])
  end

  def down do
    from(o in MatchOverlaySettings,
      update: [set: [settings: nil]])
    |> Repo.update_all([])
  end

end
