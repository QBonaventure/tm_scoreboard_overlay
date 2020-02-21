defmodule TMSO.ExternalService.Maniaplanet do
  use OAuth2.Strategy
  alias __MODULE__
  import Application, only: [get_env: 2]

  # Public API

  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: get_env(:tm_scoreboard_overlay, Maniaplanet)[:client_id],
      client_secret: get_env(:tm_scoreboard_overlay, Maniaplanet)[:client_secret],
      redirect_uri: get_env(:tm_scoreboard_overlay, Maniaplanet)[:redirect_uri],
      authorize_url: get_env(:tm_scoreboard_overlay, Maniaplanet)[:authorize_url],
      token_url: get_env(:tm_scoreboard_overlay, Maniaplanet)[:token_url],
      site: get_env(:tm_scoreboard_overlay, Maniaplanet)[:site],
      response_type: get_env(:tm_scoreboard_overlay, Maniaplanet)[:response_type]
    ])
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def authorize_url do
    OAuth2.Client.authorize_url!(client(), scope: "basic", state: "mlkj")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end


  def get_user(%{access_token: token}) do
    headers = [
      "Authorization": "Bearer #{token}"
    ]

    "https://prod.live.maniaplanet.com/webservices/me"
    |> HTTPoison.get(headers)
    |> case do
      {:ok, %HTTPoison.Response{status_code: code, body: raw_body}} ->
        {code, raw_body}
      {:error, %{reason: reason}} ->
        {:error, reason}
      end
    |> (fn {_ok, body} ->
      body
      |> Jason.decode!
      |> case do
        %{"login" => login} ->
          %{nickname: login}
        _ ->
          {:error, "Error during JSON parsing"}
      end
    end).()
  end

end
