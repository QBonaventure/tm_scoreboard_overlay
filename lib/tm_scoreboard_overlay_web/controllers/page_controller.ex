defmodule TMSOWeb.PageController do
  use TMSOWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
