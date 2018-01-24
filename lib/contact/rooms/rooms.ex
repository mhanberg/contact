defmodule Contact.Rooms do
  import Ecto.Query, warn: false
  alias Contact.Repo

  alias Contact.Rooms.Room

  def list_rooms do
    Repo.all(Room) |> Repo.preload(:owner)
  end

  def get_room!(id), do: Repo.get!(Room, id) |> Repo.preload(:owner)

  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end
end
