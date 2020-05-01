defmodule TMSOWeb.OverlaySummaryComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    TMSOWeb.OverlayView.render("overlay-summary-component.html", assigns)
  end

  def mount(socket) do
    {:ok, socket}
  end

end
