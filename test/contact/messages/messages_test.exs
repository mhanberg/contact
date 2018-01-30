defmodule Contact.MessagesTest do
  use Contact.DataCase
  import Contact.Factory

  alias Contact.Messages

  describe "messages" do
    alias Contact.Messages.Message

    def valid_attrs(),
      do: %{
        "body" => "some body",
        "room_id" => room_fixture().id,
        "sender_id" => sender_fixture().id
      }

    def update_attrs(),
      do: %{
        "body" => "some updated body",
        "room_id" => room_fixture().id,
        "sender_id" => sender_fixture().id
      }

    def invalid_attrs(), do: %{body: nil}

    def message_fixture(attrs \\ %{}) do
      insert(:message, attrs)
    end

    def sender_fixture(attrs \\ %{}) do
      insert(:user, attrs)
    end

    def room_fixture(attrs \\ %{}) do
      insert(:room, attrs)
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs())
      assert message.body == "some body"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(invalid_attrs())
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, message} = Messages.update_message(message.id, update_attrs())
      assert %Message{} = message
      assert "some updated body" == message.body
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message.id, invalid_attrs())
      assert Messages.get_message!(message.id) == message
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message.id)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
