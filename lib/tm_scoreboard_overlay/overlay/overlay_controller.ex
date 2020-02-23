defmodule TMSO.OverlayController do
  use GenServer
  alias TMSO.{MatchOverlaySettings}
  alias TMSOWeb.OverlayLive


  def server_name(%MatchOverlaySettings{} = overlay), do: {:overlay_controller, overlay.user_id}
  def server_name(user_id) when is_integer(user_id) , do: {:overlay_controller, user_id}

  def start(overlay) do
    server_name = server_name overlay
    pid = :global.whereis_name(server_name)

    if pid != :undefined do
      GenServer.stop(pid)
    end

    GenServer.start(__MODULE__, %{overlay: overlay}, [name: {:global, server_name}])
  end



  def update_points(trackers, smid, team, point_diff) do
    trackers
    |> Enum.map(fn submatch ->
      case submatch.smid == smid do
        true ->
          team_points = Map.get(submatch, team) + point_diff
          case team_points < 0 do
            false ->
              Map.put(submatch, team, team_points)
            true -> submatch
          end
        false -> submatch
      end
    end)
  end



  def tennis_mode_win?(submatch), do: diff = submatch.team_a - submatch.team_b



  def handle_call({:get_overlay_state}, _from, state) do
    {:reply, state, state}
  end



  def handle_call({:addpoint, smid, team}, _from, state) do
    updated_sms =
      update_points(state.points_tracker, smid, team, 1)
      |> Enum.map(fn submatch ->
        case submatch.smid == smid and Map.get(submatch, team) >= submatch.max_points do
          true ->
            case submatch.tennis_mode? do
              false -> Map.put(submatch, :winner, team)
              true ->
                case Kernel.abs(submatch.team_a - submatch.team_b) > 1 do
                  true -> Map.put(submatch, :winner, team)
                  false -> submatch
                end
              end
            false ->
              submatch
          end
        end)

    Phoenix.PubSub.broadcast(TMSO.PubSub, OverlayLive.topic(), {:trackers_update, updated_sms})
    state = Map.put(state, :points_tracker, updated_sms)

    {:reply, state, state}
  end



  def handle_call({:substractpoint, smid, team}, _from, state) do
    updated_sm =
      update_points(state.points_tracker, smid, team, -1)
      |> Enum.map(fn submatch ->
        case submatch.smid == smid and Map.get(submatch, :winner) do
          false -> submatch
          nil -> submatch
          ^team -> Map.delete(submatch, :winner)
        end
      end)
      |> IO.inspect

    Phoenix.PubSub.broadcast(TMSO.PubSub, OverlayLive.topic(), {:trackers_update, updated_sm})
    state = Map.put(state, :points_tracker, updated_sm)

    {:reply, state, state}
  end



  def init(state) do
    points_tracker = Enum.map(state.overlay.submatches, fn sm ->
      %{
        smid: sm.id,
        active?: false,
        tennis_mode?: sm.tennis_mode,
        max_points: sm.max_points,
        team_a: 0,
        team_b: 0
      }
    end)

    new_state = Map.put(state, :points_tracker, points_tracker)

    {:ok, new_state}
  end

end