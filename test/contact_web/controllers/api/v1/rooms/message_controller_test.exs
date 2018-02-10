defmodule ContactWeb.Api.V1.Room.MessageControllerTest do
  use ContactWeb.ConnCase
  import Contact.Factory

  setup %{conn: conn} do
    user = insert(:user, email: "legoman25@aol.com", username: "legoman25")
    {:ok, token, _claims} = ContactWeb.Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "render messages for room" do
    test "happy", %{conn: conn} do
      room = insert(:room)
      insert_list(2, :message, room: room)

      conn =
        get(conn, "/api/v1/rooms/#{room.id}/messages")

      assert json_response(conn, 200)
    end
  end
end
