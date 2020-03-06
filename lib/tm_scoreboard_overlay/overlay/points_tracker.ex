defmodule TMSO.PointsTracker do

  def get_teams_score_results(trackers, match_settings) do

      %{team_a: %{points: 0, score: 0}, team_b: %{points: 0, score: 0}}
      |> calculate_points(trackers)
      |> grant_overall_points_bonus match_settings
  end


  defp calculate_points(results, trackers) do
    Enum.map_reduce(trackers, results, fn tracker, acc ->
      acc =
        acc
        |> Kernel.put_in([:team_a, :points], acc.team_a.points + Map.get(tracker, :team_a))
        |> Kernel.put_in([:team_b, :points], acc.team_b.points + Map.get(tracker, :team_b))

      acc =
        case Map.get(tracker, :winner, nil) do
          nil -> {false, acc}
          winner -> {true, Kernel.put_in(acc, [winner, :score], acc[winner][:score] + 1)}
        end
    end)
  end


  defp grant_overall_points_bonus({ended?, results}, match_settings) do
    case match_settings.overall_bonus_point? and Enum.all?(ended?, & &1)
    do
      false ->
        results
      true ->
        case which_team_won?(results) do
          :team_a -> Kernel.put_in(results, [:team_a, :score], results.team_a.score + 1)
          :team_b -> Kernel.put_in(results, [:team_b, :score], results.team_b.score + 1)
          :none -> results
        end
    end
  end


  defp which_team_won?(%{team_a: %{points: team_a_pts}, team_b: %{points: team_b_pts}})
    when team_a_pts == team_b_pts, do: :none

  defp which_team_won?(%{team_a: %{points: team_a_pts}, team_b: %{points: team_b_pts}})
    when team_a_pts > team_b_pts, do: :team_a

  defp which_team_won?(%{team_a: %{points: team_a_pts}, team_b: %{points: team_b_pts}}),
    do: :team_b

end
