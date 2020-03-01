defmodule TMSOWeb.Router do
  use TMSOWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :live_overlay do
    plug :put_layout, {TMSOWeb.LayoutView, "overlay-live.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TMSOWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/create_overlay", CreateOverlayLive
    live "/overlays", OverlayList

    get "/logout", AuthController, :logout
    get "/auth/:service/callback", AuthController, :callback
  end

  scope "/", TMSOWeb do
    pipe_through [:browser, :live_overlay]
    live "/:user_id/live", OverlayLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", TMSOWeb do
  #   pipe_through :api
  # end
end
