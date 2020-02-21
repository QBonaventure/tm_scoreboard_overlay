defmodule TMSO.OverlayController do
  use GenServer
  alias TMSO.MatchOverlaySettings


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


  def handle_call({:get_overlay}, _from, state) do
    {:reply, state.overlay, state}
  end


  def init(state) do
    points_tracker = Enum.map(state.overlay.submatches, fn sm ->
      %{
        active?: false,
        tennis_mode?: sm.tennis_mode,
        max_points: sm.max_points,
        team_a: 0,
        team_b: 0
      }
    end)
    |> IO.inspect

    {:ok, state}
  end

end
