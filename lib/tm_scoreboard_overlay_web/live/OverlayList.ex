defmodule TMSOWeb.OverlayList do
  use Phoenix.LiveView
  alias TMSOWeb.OverlayView
  alias TMSO.{OverlayController,MatchOverlaySettings,Repo}
  alias TMSO.Session.{AgentStore, UserSession}
  alias TMSOWeb.OverlayLive
  import Ecto.Query


  def render(assigns) do
    OverlayView.render("overlays.html", assigns)
  end


  def mount(_params, session, socket) do
    case AgentStore.get(session["current_user"]) do
      nil -> {:ok, redirect(socket, to: "/")}
      user -> mount(socket, user)
    end
  end

  def mount(socket, %UserSession{} = user) do
    my_overlays_q = from(o in MatchOverlaySettings, where: o.user_id == ^user.id)
    overlays = Repo.all(my_overlays_q) |> Repo.preload([:team_a, :team_b])

    {live_overlay, points_tracker} =
      case :global.whereis_name(OverlayController.server_name(user.id)) do
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


  def get_overlay_by_id(overlays, oid), do:
    Enum.find(overlays, &Integer.to_string(&1.id) == oid)



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

    Phoenix.PubSub.broadcast(TMSO.PubSub, OverlayLive.topic(socket.assigns.overlay.user_id), {:trackers_update, new_state.points_tracker})
    {:noreply, assign(socket, points_tracker: new_state.points_tracker)}
  end


  def handle_event("delete-overlay", params, socket) do
    if socket.assigns.overlay != nil do
      user_id = socket.assigns.overlay.user_id
      server = {:global, OverlayController.server_name(user_id)}
      :ok = GenServer.stop(server)
      socket = assign(socket, overlay: nil)
      Phoenix.PubSub.broadcast(TMSO.PubSub, OverlayLive.topic(user_id), {:unset_live})
    end

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


  def handle_event("set-live-overlay", params, socket) do
    live_ov = get_overlay_by_id(socket.assigns.overlays, params["oid"])

    OverlayController.start live_ov
    Phoenix.PubSub.broadcast(TMSO.PubSub, OverlayLive.topic(live_ov.user_id), {:overlay_set_live, live_ov})

    socket =
      socket
      |> assign(:overlay, live_ov)
      |> assign(points_tracker: [])

    {:noreply, socket}
  end

  def handle_event("activate-submatch", params, socket) do
    Phoenix.PubSub.broadcast(TMSO.PubSub, OverlayLive.topic(socket.assigns.overlay.user_id), {:activate_submatch, params["smid"]})

    tracker = GenServer.call(
      {:global, OverlayController.server_name(socket.assigns.overlay)},
      {:activate_submatch, params["smid"]}
    )

    # upd_tracker =
    #   socket.assigns.points_tracker
    #   |> Enum.map(&Map.put(&1, :active?, &1.smid == params["smid"]))

    {:noreply, assign(socket, points_tracker: tracker)}
  end

end
