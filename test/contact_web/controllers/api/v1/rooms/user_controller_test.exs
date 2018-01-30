defmodule ContactWeb.Api.V1.Room.UserControllerTest do
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

  describe "add user to room" do
    test "happy path", %{conn: conn} do
      room = insert(:room)
      user = insert(:user)

      conn =
        post(conn, "api/v1/rooms/#{room.id}/users", %{
          data: %{
            type: "rooms_users",
            attributes: %{
              id: user.id
            }
          }
        })

      assert json_response(conn, 201)
    end
  end

  describe "delete user from room" do
    test "happy path", %{conn: conn} do
      user = insert(:user)
      room = insert(:room, members: [user])

      conn = delete(conn, "api/v1/rooms/#{room.id}/users/#{user.id}")

      assert json_response(conn, 202)
    end
  end
end
