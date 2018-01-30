defmodule Contact.Rooms.Member do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contact.Rooms.{Room, Member}
  alias Contact.Accounts.User

  schema "rooms_users" do
    belongs_to(:user, User)
    belongs_to(:room, Room)

    timestamps()
  end

  @doc false
  def changeset(%Member{} = member, attrs) do
    member
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
  end
end
