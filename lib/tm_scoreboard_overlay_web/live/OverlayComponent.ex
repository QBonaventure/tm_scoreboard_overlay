defmodule TMSOWeb.OverlayComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML


    def render(assigns) do
      TMSOWeb.OverlayView.render("overlay-component.html", assigns)
    end

    def mount(socket) do
      {:ok, socket}
    end


end
