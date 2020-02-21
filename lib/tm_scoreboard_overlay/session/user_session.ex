defmodule TMSO.Session.UserSession do
  alias __MODULE__
  alias TMSO.{Repo,User}
  alias TMSO.Session.AgentStore
  alias Ecto.Changeset
  import Ecto.Query
  import Plug.Conn

  defstruct [
    key: nil,
    id: nil,
    nickname: nil,
    component_pid: nil
  ]

  def from_user(%User{id: id, nickname: nickname}) do
    %UserSession{
      key: :crypto.strong_rand_bytes(18) |> Base.url_encode64,
      id: id,
      nickname: nickname
    }
  end


  def clear(conn) do
    Plug.Conn.clear_session(conn)
  end

  def update_user_session(%UserSession{} = user_session) do
    AgentStore.update(user_session.key, user_session)
    user_session
  end

  def update_user_session(%UserSession{} = user_session, %Changeset{data: %User{}, changes: %{name: nickname}}) do
    user_session = %{user_session | nickname: nickname}
    AgentStore.update(user_session.key, user_session)

    user_session
  end

  def update_user_session(%UserSession{} = user_session, %Changeset{data: %User{}, changes: %{}}) do
    user_session
  end


  @spec set_user_session(%Plug.Conn{}, %User{}) :: {%Plug.Conn{}, String.t}
  def set_user_session(conn, %User{} = user) do
      {user_session, message} = create_user_session(user)
      AgentStore.create(user_session)
      conn = put_session(conn, :current_user, user_session.key)

      {conn, message}
  end


  @spec create_user_session(%User{}) :: {%UserSession{}, String.t}
  defp create_user_session(%User{} = user) do
    q = from(p in User, where:  p.nickname == ^user.nickname)

    {user_session, message} = case Repo.exists?(q) do
      false ->
        {:ok, user} =
          %User{}
          |> User.registration_changeset(%{nickname: user.nickname})
          |> Repo.insert
        {UserSession.from_user(user), greet(user)}
      true ->
        user_session =
          Repo.one(q)
          |> UserSession.from_user
        {user_session, greet(user_session)}
    end
  end


  defp greet(%User{nickname: nickname}), do: "Hello #{nickname}! Looks like it's your first connection."
  defp greet(%UserSession{nickname: nickname}), do: "Welcome back #{nickname}!"

end
