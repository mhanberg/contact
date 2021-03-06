defmodule Contact.Messages do
  import Ecto.Query, warn: false
  alias Contact.Repo

  alias Contact.Messages.Message

  def list_messages do
    Repo.all(Message) |> Repo.preload(:sender) |> Repo.preload(room: [:owner, :members])
  end

  def get_message!(id), do: Repo.get!(Message, id) |> Repo.preload(:sender) |> Repo.preload(room: [:owner, :members])

  def get_messages_for_room(room_id) do
    Contact.Rooms.get_room!(room_id)
    |> Repo.preload(messages: :sender)
    |> Map.get(:messages, [])
    |> Enum.sort(&(NaiveDateTime.compare(&1.inserted_at, &2.inserted_at) == :lt))
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def update_message(id, attrs) do
    id
    |> get_message!()
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def delete_message(id) do
    id
    |> get_message!()
    |> Repo.delete()
  end

  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end
end
