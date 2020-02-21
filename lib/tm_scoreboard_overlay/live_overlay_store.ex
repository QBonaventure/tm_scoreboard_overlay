defmodule TMSO.LiveOverlayStore do
  use Agent
  alias TMSO.MatchOverlaySettings
  alias Phoenix.PubSub
  alias TMSOWeb.OverlayLive

  @name :overlay_store

  def start_link(_) do
    initial_value =
      TMSO.Repo.all(TMSO.MatchOverlaySettings)
      |> TMSO.Repo.preload([:user, :team_a, :team_b])
      |> Enum.reduce(%{}, &Map.put(&2, &1.user_id, &1))
    Agent.start_link(fn -> initial_value end, [name: {:global, @name}])
  end

  def get(user_id) do
    Agent.get(get_pid(), &Map.get(&1, user_id, %{}))
  end

  def all() do
    Agent.update(get_pid(), &(IO.inspect &1))
  end

  def set_live(overlay) do
    Agent.update(get_pid(), &Map.put(&1, overlay.user_id, overlay))
  end

  def get_pid, do: :global.whereis_name(@name)

  def handle_info({:hello}, state) do
    IO.inspect "dlkfsmldkfmsldfk"
    {:ok, state}
  end

end
