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

  def set_color_tags(string, string), do: string
  def set_color_tags(_previous, string) do
    new = Regex.replace(~r/(.*)\$([[:xdigit:]]{3})(.*)/u, string, "\\1<span style=\"color: #\\2\">\\3")
    set_color_tags(string, new)
  end
  def set_color_tags(string), do: set_color_tags(nil, string)


  def set_other_tags(string), do: set_other_tags nil, string
  def set_other_tags(string, string), do: string
  def set_other_tags(_previous, string) do
    elmt_idx =
      Regex.scan(~r/(?<!\$)(\$(o|i|u|w|n|t|g|z))/u, string, capture: :first, return: :index)
      |> Enum.map(& Kernel.elem(List.first(&1), 0))
      |> Enum.reverse
    elmt =
      Regex.scan(~r/(?<!\$)(\$(o|i|u|w|n|t))/, string)
      |> Enum.reverse
      |> Enum.map &(List.first &1)

    {_, {_, new_string}} =
      Enum.map_reduce(elmt_idx, {0, string}, fn idx, acc ->
        string_splits = String.split_at(Kernel.elem(acc, 1), idx)
        elmt_to_replace = Enum.at(elmt, Kernel.elem(acc, 0))

        string = Kernel.elem(string_splits, 0) <>
          String.replace_leading(
            Kernel.elem(string_splits, 1),
            elmt_to_replace,
            get_replacement(elmt_to_replace))

        {idx, {Kernel.elem(acc, 0) + 1, string}}
      end)

    new_string
  end

  defp get_replacement(mp_tag) do
    class_name =
      case mp_tag do
        "$i" -> "italic"
        "$o" -> "bold"
        "$n" -> "narrow"
        "$t" -> "uppercase"
        "$s" -> "drop-shadow"
        "$w" -> "wide"
      end
    "<span class=\"#{class_name}\">"
  end

  def parse_text_to_html(text) do
    text
    |> set_color_tags
    |> set_other_tags
    |> Phoenix.HTML.raw
  end

  def time_format(ms_time) when is_list(ms_time), do: time_format(List.to_string(ms_time))
  def time_format(ms_time) when is_binary(ms_time) do
    [hour, min, sec, ms] =
      Regex.scan(~r/([0-9]{2})?([0-9]{2})?([0-9]{2})([0-9]{3})/, ms_time, capture: :all_but_first)
      |> List.flatten
      |> Enum.map(fn time_slice ->
          case time_slice do
            "" -> 0
            _ -> String.to_integer time_slice
          end
        end)

    {:ok, time} = Time.new(hour, min, sec, ms*1000)

    {time, _} =
      time
      |> Time.to_string
      |> String.replace_leading("00:", "")
      |> String.split_at(-3)

      time
  end

end
