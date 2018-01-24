defmodule Contact.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contact.Rooms.Room
  alias Contact.Accounts.User

  @derive {Poison.Encoder, only: [:name, :owner]}
  schema "rooms" do
    field(:name, :string)
    belongs_to(:owner, User, on_replace: :nilify)

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    owner = get_owner(attrs["owner_id"])

    room
    |> cast(attrs, [:name])
    |> put_assoc(:owner, owner)
    |> validate_required([:name, :owner])
  end

  defp get_owner(nil), do: nil

  defp get_owner(id) do
    Contact.Repo.get!(User, id)
  end
end
