defmodule Contact.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contact.Accounts.User
  alias Contact.Teams.Team

  @derive {Poison.Encoder, only: [:name, :owner, :rooms]}
  schema "teams" do
    field(:name, :string)
    belongs_to(:owner, User, on_replace: :nilify)
    has_many(:rooms, Contact.Rooms.Room, on_delete: :delete_all)

    many_to_many(
      :members,
      User,
      join_through: Contact.Teams.Member,
      on_delete: :delete_all,
      on_replace: :delete
    )

    timestamps()
  end

  def changeset(%Team{} = team, attrs) do
    owner = get_owner(attrs["owner_id"])

    team
    |> cast(attrs, [:name])
    |> put_assoc(:owner, owner)
    |> validate_required([:name, :owner])
    |> validate_length(:name, max: 25, count: :codepoints)
  end

  defp get_owner(nil), do: nil

  defp get_owner(id) do
    Contact.Repo.get!(User, id)
  end
end
