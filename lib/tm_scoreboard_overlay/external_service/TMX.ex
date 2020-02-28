defmodule TMSO.ExternalService.TMX do

  @search_url "https://tm.mania-exchange.com/tracksearch2/search?api=on&format=json&trackname="
  @get_map_url "https://api.mania-exchange.com/tm/maps/"


  def find_map(name) do
    "#{@search_url}#{name}"
    |> HTTPoison.get
    |> case do
      {:ok, %HTTPoison.Response{status_code: code, body: raw_body}} ->
        {:ok, %{"results" => maps}} = Jason.decode(raw_body)
        Enum.map(maps, &cast &1)
      {:error, reason} ->
        reason
    end
  end


  def get_map(id) when is_integer(id) do
    "#{@get_map_url}#{id}"
    |> HTTPoison.get
    |> case do
      {:ok, %HTTPoison.Response{status_code: code, body: raw_body}} ->
        {:ok, [%{} = map]} = Jason.decode(raw_body)
        cast(map)
      {:error, reason} ->
        reason
    end
  end


  defp cast(%{} = raw_info) do
    %{
      id: raw_info["TrackID"],
      uid: raw_info["TrackUID"],
      author: raw_info["Username"],
      name: raw_info["Name"],
      gbx_name: raw_info["GbxMapName"],
    }
  end

end
