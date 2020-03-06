defmodule TMSOWeb.CreateOverlayLive do
  use Phoenix.LiveView
  alias __MODULE__
  alias TMSOWeb.OverlayView
  alias TMSO.{MatchOverlaySettings,Submatch,MatchSettings,Team,Repo}
  alias TMSO.Session.AgentStore
  import Ecto.Query

  def render(assigns) do
    OverlayView.render("create_overlay.html", assigns)
  end

  def mount(session, socket) do
    user = AgentStore.get(session["current_user"])
    changeset =
      %MatchOverlaySettings{}
      |> MatchOverlaySettings.changeset %{user_id: user.id}

    teams = Repo.all(Team) |> Enum.sort_by(& String.downcase(&1.name))

    available_teams = [{"", ""} | Enum.map(teams, &{&1.name, &1.id})]

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(teams: teams)
      |> assign(available_teams: available_teams)
      |> assign(team_a: nil)
      |> assign(team_b: nil)
      |> assign(submatches: [])

    {:ok, socket}
  end


  def handle_event("create-overlay", params, socket) do
    data = params["match_overlay_settings"]
    changeset =
      %MatchOverlaySettings{}
      |> MatchOverlaySettings.changeset data


    case Repo.insert changeset do
      {:ok, overlay_settings} ->
        changeset =
          %MatchOverlaySettings{}
          |> MatchOverlaySettings.changeset %{user_id: changeset.changes.user_id}
        socket =
          socket
          |> assign(changeset: changeset)
          |> assign(team_a: nil)
          |> assign(team_b: nil)
          |> assign(submatches: [])
        {:noreply, socket}
      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


  def handle_event("validate", params, socket) do
    data = params["match_overlay_settings"]

    changeset =
      %MatchOverlaySettings{}
      |> MatchOverlaySettings.changeset data

    changeset = case Ecto.Changeset.apply_action(changeset, :insert) do
      {:error, changeset} -> changeset
      _ -> changeset
    end

    team_a = Enum.find(socket.assigns.teams, fn map -> Integer.to_string(map.id) == data["team_a_id"] end)
    team_b = Enum.find(socket.assigns.teams, fn map -> Integer.to_string(map.id) == data["team_b_id"] end)

    submatches =
      Map.get(data, "submatches", [])
      |> Enum.map(fn {_, sm} ->
        sm |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
      end)

    socket =
     socket
     |> assign(changeset: changeset)
     |> assign(team_a: team_a)
     |> assign(team_b: team_b)
     |> assign(submatches: submatches)

    {:noreply, socket}
  end


  def handle_event("add-submatch", params, socket) do
    changeset = socket.assigns.changeset
    settings_chgset = Map.get(changeset.changes, :settings, nil)
    data = changeset.changes

    data =
      case settings_chgset do
        nil -> Map.delete(data, :settings)
        _ -> Map.put(data, :settings, settings_chgset.changes)
      end

    current_submatches =
      Map.get(data, :submatches, [])
      |> Enum.map(fn chgset -> chgset.changes end)

    data = Map.put(data, :submatches, current_submatches ++ [%{}])

    changeset =
      changeset.data
      |> MatchOverlaySettings.changeset data

    {:error, changeset} = Ecto.Changeset.apply_action(changeset, :insert)

    changeset
        socket =
          socket
          |> assign(:changeset, changeset)
          |> assign(submatches: data.submatches)

    {:noreply, socket}
  end


  def handle_event("cancel-form", params, socket) do
    changeset = MatchOverlaySettings.changeset %MatchOverlaySettings{}

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(submatches: [])

    {:noreply, socket}
  end


  def handle_event("remove-submatch", params, socket) do
    index =
      String.replace(params["smid"], "match_overlay_settings_submatches_", "")
      |> String.to_integer

    submatches = socket.assigns.submatches |> List.delete_at(index)

    changeset =
      socket.assigns.changeset
      |> Map.update!(:changes, fn changes ->
        Map.update!(changes, :submatches, fn submatches ->
          new_submatches = List.delete_at(submatches, index)
        end)
      end)

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(submatches: submatches)

    {:noreply, socket}
  end


end
