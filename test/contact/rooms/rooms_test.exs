defmodule Contact.RoomsTest do
  use Contact.DataCase
  import Contact.Factory
  alias Contact.Rooms
  alias Contact.Rooms.Room

  describe "rooms" do
    def valid_attrs(), do: %{"name" => "some name", "owner_id" => user_fixture().id}
    def update_attrs(), do: %{"name" => "some updated name", "owner_id" => user_fixture().id}
    def invalid_attrs(), do: %{name: nil}

    def room_fixture(attrs \\ %{}) do
      insert(:room, attrs)
    end

    def user_fixture() do
      insert(:user)
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Rooms.create_room(valid_attrs())
      assert room.name == "some name"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(invalid_attrs())
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, room} = Rooms.update_room(room, update_attrs())
      assert %Room{} = room
      assert room.name == "some updated name"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, invalid_attrs())
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end

    test "see if insert(:user) works" do
      user_fixture()
    end
  end
end
