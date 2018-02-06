defmodule Contact.Rooms do
  import Ecto.Query, warn: false
  alias Contact.Repo

  alias Contact.Accounts.User
  alias Contact.Rooms.Room
  alias Contact.Rooms.Member

  def list_rooms do
    Repo.all(Room) |> Repo.preload(:owner) |> Repo.preload(:members) |> Repo.preload(:team)
  end

  def get_room!(id), do: Repo.get!(Room, id) |> Repo.preload(:owner) |> Repo.preload(:members) |> Repo.preload(:team)

  def get_rooms_for_user_and_team(user_id, team_id) do
    Contact.Repo.all(
      from(
        r in Contact.Rooms.Room,
        join: t in assoc(r, :team),
        join: m in assoc(r, :members),
        where: t.id == ^team_id and m.id == ^user_id
      )
    )
  end

  def create_room(attrs \\ %{}) do
    case result = %Room{} |> Room.changeset(attrs) |> Repo.insert() do
      {:ok, room} ->
        add_member(room.id, room.owner_id)
        {:ok, room}

      _ ->
        result
    end
  end

  def update_room(id, attrs) do
    id
    |> get_room!()
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def delete_room(id) do
    id
    |> get_room!()
    |> Repo.delete()
  end

  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  def add_member(room_id, user_id) do
    room = Room |> Repo.get!(room_id) |> Repo.preload(:members)
    user = User |> Repo.get!(user_id)

    room
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:members, [user])
    |> Repo.update()
  end

  def delete_member(room_id, user_id) do
    case Member |> Repo.get_by(room_id: room_id, user_id: user_id) do
      %Member{} = member ->
        Repo.delete(member)

      nil ->
        {:error, :not_found}
    end
  end
end
