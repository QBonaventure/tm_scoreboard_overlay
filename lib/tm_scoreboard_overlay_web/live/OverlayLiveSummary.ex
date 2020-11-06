defmodule TMSOWeb.OverlayLiveSummary do
  use Phoenix.LiveView
  alias TMSOWeb.OverlayView
  alias TMSO.{OverlayController}
  alias TMSO.ExternalService.{TMX,Dedimania,Maniaplanet}

  def topic(user_id) when is_integer(user_id),
    do: "overlay_live_"<>Integer.to_string user_id


  def render(assigns) do
    OverlayView.render("overlay-live-summary.html", assigns)
  end


  def mount(params, session, socket) do
    {user_id, _} = Integer.parse(params["user_id"])

    {overlay_state, points_tracker} =
      case :global.whereis_name(OverlayController.server_name(user_id)) do
        :undefined ->
          {nil, []}
        pid ->
          overlay_state = GenServer.call(pid, {:get_overlay_state})
          {overlay_state.overlay, overlay_state.points_tracker}
      end

      maps_info =
        Enum.map(overlay_state.submatches, fn sm ->
          pt = Enum.find(points_tracker, & &1.smid == sm.id)
          map_info = sm |> Map.get(:map_id) |> TMX.get_map
          world_record = Dedimania.get_world_record map_info.uid
          %{
            smid: sm.id,
            name: map_info.name,
            author: map_info.author,
            world_record: world_record.time,
            wr_holder: world_record.player,
            players_per_team: sm.players_per_team,
            max_points: sm.max_points,
            tennis_mode?: pt.tennis_mode?,
            winner: pt.winner,
            team_a_pts: pt.team_a,
            team_b_pts: pt.team_b,
          }
      end)

    Phoenix.PubSub.subscribe(TMSO.PubSub, topic(user_id))

    socket =
      socket
      |> assign(overlay: overlay_state)
      |> assign(maps_info: maps_info)

    {:ok, socket}
  end


  def handle_info({:unset_live}, socket) do
    socket =
      socket
      |> assign(overlay: nil)
      |> assign(points_tracker: [])
      |> assign(map_info: nil)
    {:noreply, socket}
  end

  def handle_info({:overlay_set_live, overlay}, socket) do
    socket =
      socket
      |> assign(overlay: overlay)
      |> assign(points_tracker: [])
      |> assign(map_info: nil)
    {:noreply, socket}
  end

  def handle_info({:trackers_update, trackers}, socket) do
    {:noreply, assign(socket, points_tracker: trackers)}
  end

end
