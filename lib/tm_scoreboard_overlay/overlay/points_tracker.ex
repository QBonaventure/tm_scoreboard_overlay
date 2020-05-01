defmodule TMSO.PointsTracker do


  def get_teams_score_results(trackers, match_settings, gp_winning_team) when gp_winning_team in [:team_a, :team_b] do
    results = get_teams_score_results(trackers, match_settings, nil)

    case match_ends_on_overall_equality?(trackers) do
      true -> Kernel.put_in(results, [gp_winning_team, :score], Kernel.get_in(results, [gp_winning_team, :score])+1)
      false -> results
    end
  end

  def get_teams_score_results(trackers, match_settings, _team) do
      %{team_a: %{points: 0, score: 0}, team_b: %{points: 0, score: 0}}
      |> calculate_points(trackers)
      |> grant_overall_points_bonus match_settings
  end


  def need_golden_point?(trackers, match_settings) do
    match_settings.overall_golden_point?
    and match_ends_on_overall_equality?(trackers)
  end


  def match_ends_on_overall_equality?(trackers) do
    {ended_sm?, overall_score} = Enum.map_reduce(trackers, %{team_a: 0, team_b: 0}, fn tracker, acc ->
        acc =
          acc
          |> Kernel.put_in([:team_a], acc.team_a + Map.get(tracker, :team_a))
          |> Kernel.put_in([:team_b], acc.team_b + Map.get(tracker, :team_b))
        {Map.has_key?(tracker, :winner), acc}
    end)

    Enum.all?(ended_sm?, & &1 == true) and overall_score.team_a == overall_score.team_b and overall_score.team_a > 0
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
