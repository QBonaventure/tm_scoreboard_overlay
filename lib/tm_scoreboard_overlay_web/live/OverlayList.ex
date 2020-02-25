defmodule TMSOWeb.OverlayList do
  use Phoenix.LiveView
  alias __MODULE__
  alias TMSOWeb.OverlayView
  alias TMSO.{OverlayController,MatchOverlaySettings,Submatch,MatchSettings,Team,Repo,LiveOverlayStore}
  alias TMSO.Session.AgentStore
  alias TMSOWeb.OverlayLive
  import Ecto.Query


  def render(assigns) do
    OverlayView.render("overlays.html", assigns)
  end


  def mount(params, session, socket) do
    user_id =
    case AgentStore.get(session["current_user"]) do
      nil -> redirect(socket, to: "/")
      user -> user.id
    end

    overlays = Repo.all(MatchOverlaySettings) |> Repo.preload([:team_a, :team_b])

    {live_overlay, points_tracker} =
      case :global.whereis_name(OverlayController.server_name(user_id)) do
        :undefined ->
          {nil, []}
        pid ->
          live_overlay_state = GenServer.call(pid, {:get_overlay_state})
          {live_overlay_state.overlay, live_overlay_state.points_tracker}
      end

    socket =
      socket
      |> assign(overlays: overlays)
      |> assign(overlay: live_overlay)
      |> assign(points_tracker: points_tracker)

    {:ok, socket}
  end





  def handle_event("add-point", params, socket) do
    smid = params["smid"]
    team = String.to_atom("team_#{params["team"]}")

    new_state = GenServer.call(
      {:global, OverlayController.server_name(socket.assigns.overlay)},
      {:addpoint, smid, team}
    )

    {:noreply, assign(socket, points_tracker: new_state.points_tracker)}
  end


  def handle_event("substract-point", params, socket) do
    smid = params["smid"]
    team = String.to_atom("team_#{params["team"]}")

    new_state = GenServer.call(
      {:global, OverlayController.server_name(socket.assigns.overlay)},
      {:substractpoint, smid, team}
    )

    {:noreply, assign(socket, points_tracker: new_state.points_tracker)}
  end


  def handle_event("delete-overlay", params, socket) do
    if socket.assigns.overlay != nil do
      user_id = socket.assigns.overlay.user_id
      server = {:global, OverlayController.server_name(user_id)}
      :ok = GenServer.stop(server)
      socket = assign(socket, overlay: nil)
      Phoenix.PubSub.broadcast(TMSO.PubSub, OverlayLive.topic(), {:unset_live})
    end

    changeset =
      get_overlay_by_id(socket.assigns.overlays, params["oid"])
      |> MatchOverlaySettings.changeset
      |> TMSO.Repo.delete

    new_overlays =
      socket.assigns.overlays
      |> Enum.reject(& &1.id == String.to_integer(params["oid"]))

    socket =
      socket
      |> assign(overlays: new_overlays)

    {:noreply, socket}
  end


  def get_overlay_by_id(overlays, oid), do:
    Enum.find(overlays, &Integer.to_string(&1.id) == oid)


  def handle_event("set-live-overlay", params, socket) do
    live_ov = get_overlay_by_id(socket.assigns.overlays, params["oid"])

    OverlayController.start live_ov
    Phoenix.PubSub.broadcast(TMSO.PubSub, OverlayLive.topic(), {:overlay_set_live, live_ov})

    socket =
      socket
      |> assign(:overlay, live_ov)
      |> assign(points_tracker: [])

    {:noreply, socket}
  end

end
