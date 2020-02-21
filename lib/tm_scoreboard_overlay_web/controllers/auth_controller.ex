defmodule TMSOWeb.AuthController do
  use TMSOWeb, :controller
  alias TMSO.{Repo,User}
  alias TMSO.Session.UserSession
  alias TMSO.ExternalService.Maniaplanet

  def callback(conn, %{"code" => code, "service" => "maniaplanet", "state" => _state}) do
    client = Maniaplanet.get_token!([code: code])
    %{nickname: nickname} = Maniaplanet.get_user(client.token)
    # service_id = Repo.get_by(User, name: "Maniaplanet").id
    #
    user = %User{nickname: nickname}

    {conn, message} = UserSession.set_user_session(conn, user)

    conn
    |> put_flash(:info, message)
    |> redirect(to: "/")
  end


  def logout(conn, _) do
    conn
    |> UserSession.clear
    |> redirect(to: "/")
  end

end
