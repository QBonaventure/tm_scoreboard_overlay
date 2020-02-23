defmodule TMSO.PointsTracker do

  def get_team_overall_score(trackers, team) do
    scores = %{team_a: 0, team_b: 0}

    {_, team_a_points} =
      Enum.map_reduce(trackers, 0, fn tracker, team_a_points ->
        {0, Map.get(tracker, :team_a) + team_a_points}
      end)

    {_, team_b_points} =
      Enum.map_reduce(trackers, 0, fn tracker, team_b_points ->
        {0, Map.get(tracker, :team_b) + team_b_points}
      end)

    {submatches_ended?, %{team_a: team_a_wins, team_b: team_b_wins}} =
      Enum.map_reduce(trackers, %{team_a: 0, team_b: 0}, fn tracker, acc ->
        case Map.get(tracker, :winner, nil) do
          nil -> {false, acc}
          team -> {true, Map.put(acc, team, Map.get(acc, team) + 1)}
        end
      end)

    {team_a_wins, team_b_wins} =
    case Enum.all?(submatches_ended?, & &1) and team_a_points != team_b_points do
      true ->
        case team_a_points > team_b_points do
          true -> {team_a_wins + 1, team_b_wins}
          false -> {team_a_wins, team_b_wins + 1}
        end
      false ->
        {team_a_wins, team_b_wins} 
    end


    %{team_a: %{points: team_a_points, score: team_a_wins}, team_b: %{points: team_b_points, score: team_b_wins}}
  end

end
