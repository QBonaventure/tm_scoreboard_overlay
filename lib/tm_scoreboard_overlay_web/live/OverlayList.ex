defmodule TMSOWeb.OverlayList do
  use Phoenix.LiveView
  alias __MODULE__
  alias TMSOWeb.OverlayView
  alias TMSO.{OverlayController,MatchOverlaySettings,Submatch,MatchSettings,Team,Repo,LiveOverlayStore}
  alias TMSO.Session.AgentStore
  import Ecto.Query


  def render(assigns) do
    OverlayView.render("overlays.html", assigns)
  end


  def mount(session, socket) do
    overlays = Repo.all(MatchOverlaySettings) |> Repo.preload([:team_a, :team_b])

    socket =
      socket
      |> assign(overlays: overlays)
      |> assign(overlay: nil)

    {:ok, socket}
  end


  def handle_event("set-live-overlay", params, socket) do
    live_ov = Enum.find(socket.assigns.overlays, &Integer.to_string(&1.id) == params["oid"])

    OverlayController.start live_ov


    {:noreply, assign(socket, overlay: live_ov)}
  end

end
