defmodule TMSO.ExternalService.Dedimania do

  @endpoint "http://dedimania.net:8082/Dedimania"
  @xpath_ta_time '//name[text()="RecordsTA"]/following-sibling::value//name[text()="Best"]/following-sibling::value/int/text()'
  @xpath_ta_player '//name[text()="RecordsTA"]/following-sibling::value//name[text()="NickName"]/following-sibling::value/string/text()'
  @xpath_rd_time '//name[text()="RecordsRounds"]/following-sibling::value//name[text()="Best"]/following-sibling::value/int/text()'
  @xpath_rd_player '//name[text()="RecordsRounds"]/following-sibling::value//name[text()="NickName"]/following-sibling::value/string/text()'

  def get_world_record(map_uid) when is_binary(map_uid), do: get_world_record(String.to_charlist(map_uid))

  def get_world_record(map_uid) do
    {response, _} =
      HTTPoison.post!(@endpoint, query(map_uid), headers()).body
      |> :zlib.gunzip
      |> :binary.bin_to_list
      |> :xmerl_scan.string

    {:xmlText, _, _, _, tatime, _} = @xpath_ta_time |> :xmerl_xpath.string(response)|> List.first
    {:xmlText, _, _, _, taplayer, _} = @xpath_ta_player |> :xmerl_xpath.string(response) |> List.first
    {:xmlText, _, _, _, rdtime, _} = @xpath_rd_time |> :xmerl_xpath.string(response) |> List.first
    {:xmlText, _, _, _, rdplayer, _} = @xpath_rd_player |> :xmerl_xpath.string(response) |> List.first

    case tatime > rdtime do
      false -> %{time: tatime, player: List.to_string taplayer}
      _ -> %{time: rdtime, player: List.to_string rdplayer}
    end
  end


  defp headers, do: [{"Content-Type", "text/xml"},{"Accept-Encoding", "gzip"}]

  defp query(map_uid) do
    [{:methodCall, [], [
        {:methodName, [], ['dedimania.GetChallengeInfo']},
        {:params, [], [
          {:param, [], [
            {:value, [], [
              {:string, [], [map_uid]}
            ]}
          ]}
        ]}
      ]}
    ]
    |> :xmerl.export_simple(:xmerl_xml)
    |> List.flatten
  end

end
