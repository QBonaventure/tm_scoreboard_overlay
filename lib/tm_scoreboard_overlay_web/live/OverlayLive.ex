defmodule TMSOWeb.OverlayLive do
  use Phoenix.LiveView
  alias __MODULE__
  alias TMSOWeb.OverlayView
  alias TMSO.{OverlayController}
  alias TMSO.Session.AgentStore

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

    {:ok, socket}
  end


  def handle_info({:unset_live}, socket) do
    socket =
      socket
      |> assign(overlay: nil)
      |> assign(points_tracker: [])
    {:noreply, socket}
  end


  def handle_info({:overlay_set_live}, socket) do
    # IO.inspect "kljlkjlkj"
    # socket =
    #   socket
    #   |> assign(overlay: overlay)
    #   |> assign(points_tracker: [])
    {:noreply, socket}
  end


  def handle_info({:trackers_update, trackers}, socket) do
    {:noreply, assign(socket, points_tracker: trackers)}
  end


end
