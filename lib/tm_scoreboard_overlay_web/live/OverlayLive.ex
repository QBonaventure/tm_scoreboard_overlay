defmodule TMSOWeb.OverlayLive do
  use Phoenix.LiveView
  alias TMSOWeb.OverlayView
  alias TMSO.{OverlayController}
  alias TMSO.ExternalService.{TMX,Dedimania,Maniaplanet}

  def topic(), do: "overlay_live"


  def render(assigns) do
    OverlayView.render("overlay-live.html", assigns)
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

    Phoenix.PubSub.subscribe(TMSO.PubSub, topic())

    socket =
      socket
      |> assign(overlay: overlay_state)
      |> assign(points_tracker: points_tracker)
      |> assign(map_info: nil)

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

  def handle_info({:activate_submatch, smid}, socket) do
    map =
      Enum.find(socket.assigns.overlay.submatches, & &1.id == smid)
      |> Map.get(:map_id)
      |> TMX.get_map

    world_record = Dedimania.get_world_record(map.uid)
IO.inspect world_record.time
    map_info = %{
      name: map.name,
      author: map.author,
      world_record: world_record.time,
      wr_holder: world_record.player
    }

    {:noreply, assign(socket, map_info: map_info)}
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
