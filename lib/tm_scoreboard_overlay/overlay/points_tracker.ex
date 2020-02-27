defmodule TMSO.PointsTracker do

  def get_teams_score_results(trackers) do
      %{team_a: %{points: 0, score: 0}, team_b: %{points: 0, score: 0}}
      |> calculate_points(trackers)
      |> grant_overall_points_bonus
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


  defp grant_overall_points_bonus({ended?, results}) do
    case Enum.all?(ended?, & &1) and results.team_a.points != results.team_b.points do
      false ->
        results
      true ->
        case results.team_a.points > results.team_b.points do
          true -> Kernel.put_in(results, [:team_a, :score], results.team_a.score + 1)
          false -> Kernel.put_in(results, [:team_b, :score], results.team_b.score + 1)
        end
    end
  end

end
