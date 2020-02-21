defmodule TMSOWeb.OverlayLive do
  use Phoenix.LiveView
  alias __MODULE__
  alias TMSOWeb.OverlayView
  alias TMSO.{OverlayController}
  alias TMSO.Session.AgentStore

  def topic, do: "overlay_live"

  def render(assigns) do
    OverlayView.render("overlay-live.html", assigns)
  end


  def mount(params, session, socket) do
    {user_id, _} = Integer.parse(params["user_id"])

    overlay =
      case :global.whereis_name(OverlayController.server_name(user_id)) do
        :undefined -> nil
        pid -> GenServer.call(pid, {:get_overlay})
      end

    socket =
      socket
      |> assign(overlay: overlay)

    {:ok, socket}
  end

end
