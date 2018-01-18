defmodule ContactWeb.Api.V1.Team.UserControllerTest do
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

  describe "add user to team" do
    test "happy path", %{conn: conn} do
      team = insert(:team)
      user = insert(:user)

      conn =
        post(conn, "api/v1/teams/#{team.id}/users", %{
          data: %{
            type: "teams_users",
            attributes: %{
              id: user.id
            }
          }
        })

      assert json_response(conn, 201)
    end
  end

  describe "delete user from team" do
    test "happy path", %{conn: conn} do
      user = insert(:user)
      team = insert(:team, members: [user])

      conn = delete(conn, "api/v1/teams/#{team.id}/users/#{user.id}")

      assert json_response(conn, 202)
    end
  end
end
