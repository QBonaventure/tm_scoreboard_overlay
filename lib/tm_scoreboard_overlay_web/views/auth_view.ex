defmodule TMSOWeb.AuthView do
  use TMSOWeb, :view
  alias Plug.Conn
  alias TMSO.Session.{AgentStore,UserSession}

  def ext_service_login_link(ext_service) do
    link =
      String.to_existing_atom("Elixir.TeamHeda.ExternalService.#{ext_service}")
      |> apply(:authorize_url, [])

    link ext_service, to: link
  end

  @spec get_session(%Conn{}) :: nil | %UserSession{}
  def get_session(conn) do
    IO.inspect conn
    case Conn.get_session(conn, :current_user) do
      nil -> nil
      key ->
        IO.inspect :global.whereis_name(key)
        case session = AgentStore.get(key) do
          nil ->
            UserSession.clear(conn)
            nil
          _ -> session

        end
    end
  end

end
