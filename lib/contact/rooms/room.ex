defmodule Contact.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contact.Rooms.Room
  alias Contact.Accounts.User

  @derive {Poison.Encoder, only: [:name, :owner, :team]}
  schema "rooms" do
    field(:name, :string)
    belongs_to(:owner, User, on_replace: :nilify)
    belongs_to(:team, Contact.Teams.Team, on_replace: :nilify)

    many_to_many(
      :members,
      User,
      join_through: Contact.Rooms.Member,
      on_delete: :delete_all,
      on_replace: :delete
    )

    has_many(
      :messages,
      Contact.Messages.Message,
      on_delete: :delete_all,
      on_replace: :nilify
    )

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    owner = get_owner(attrs["owner_id"])
    team = get_team(attrs["team_id"])

    room
    |> cast(attrs, [:name])
    |> put_assoc(:owner, owner)
    |> put_assoc(:team, team)
    |> validate_required([:name, :owner, :team])
  end

  defp get_owner(nil), do: nil

  defp get_owner(id) do
    Contact.Repo.get!(User, id)
  end

  defp get_team(nil), do: nil

  defp get_team(id) do
    Contact.Repo.get!(Contact.Teams.Team, id)
  end
end
