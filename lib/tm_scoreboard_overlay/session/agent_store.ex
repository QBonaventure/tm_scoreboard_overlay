defmodule TMSO.Session.AgentStore do
  alias TMSO.Repo
  alias TMSO.Session.UserSession

  def create(%UserSession{key: key, id: id} = args) do
    Agent.start_link(fn -> args end, name: {:global, {:session, key}})
  end

  def get(key) do
    case :global.whereis_name({:session, key}) do
      :undefined -> nil
      pid -> Agent.get({:global, {:session, key}}, & &1)
    end
  end

  def update(key, %UserSession{} = new_state) do
    case :global.whereis_name({:session, key}) do
      :undefined -> nil
      pid -> Agent.update({:global, {:session, key}}, fn state -> new_state end)
    end
  end

end
