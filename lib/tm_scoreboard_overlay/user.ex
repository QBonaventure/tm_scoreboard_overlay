defmodule TMSO.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias TMSO.{User,UserExternalAccount}

  schema "users" do
    field :nickname, :string

    timestamps()
  end

  def changeset(%User{} = User, data) do
    User
    |> cast(data, [:nickname])
    |> validate_required([:nickname])
    |> validate_length(:nickname, min: 2)
    |> validate_length(:nickname, max: 36)
  end


  def update_my_infos_changeset(%User{} = User, data \\ %{}) do
    User
    |> cast(data, [:nickname])
    |> validate_required([:nickname])
    |> validate_length(:nickname, min: 2)
    |> validate_length(:nickname, max: 36)
  end


  def registration_changeset(%User{nickname: nil} = new_User, data) do
    new_User
    |> cast(data, [:nickname])
    |> validate_required([:nickname])
    |> validate_length(:nickname, min: 2)
    |> validate_length(:nickname, max: 36)
  end

end
