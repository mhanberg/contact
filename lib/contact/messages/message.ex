defmodule Contact.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contact.Messages.Message

  schema "messages" do
    field(:body, :string)
    belongs_to(:sender, Contact.Accounts.User, on_replace: :nilify)
    belongs_to(:room, Contact.Rooms.Room, on_replace: :nilify)

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    sender = get_sender(attrs["sender_id"])
    room = get_room(attrs["room_id"])

    message
    |> cast(attrs, [:body])
    |> put_assoc(:sender, sender)
    |> put_assoc(:room, room)
    |> validate_required([:body, :sender, :room])
  end

  defp get_sender(nil), do: nil

  defp get_sender(id) do
    Contact.Repo.get!(Contact.Accounts.User, id)
  end

  defp get_room(nil), do: nil

  defp get_room(id) do
    Contact.Repo.get!(Contact.Rooms.Room, id)
  end
end
