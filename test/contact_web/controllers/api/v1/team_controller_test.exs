defmodule ContactWeb.Api.V1.TeamControllerTest do
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

    {:ok, conn: conn, user: user}
  end

  describe "create" do
    test "happy path", %{conn: conn, user: user} do
      body = %{
        data: %{
          type: "teams",
          attributes: %{
            name: "Burger King",
            owner_id: user.id
          }
        }
      }
      conn = post conn, "/api/v1/teams", body

      assert json_response(conn, 201)
    end
  end

  describe "update" do
    test "happy path", %{conn: conn, user: user} do
      team = insert(:team, owner: user)
      new_owner = insert(:user)

      body = %{
        data: %{
          id: team.id,
          attributes: %{
            name: "Burger King",
            owner_id: new_owner.id
          }
        }
      }
      conn = patch conn, "/api/v1/teams/#{team.id}", body

      assert json_response(conn, 200)
    end
  end

  describe "delete" do
    test "happy path", %{conn: conn, user: user} do
      team = insert(:team, owner: user)

      conn = delete conn, "/api/v1/teams/#{team.id}"

      assert json_response(conn, 204)
    end
  end

  describe "show" do
    test "happy path", %{conn: conn, user: user} do
      team = insert(:team, owner: user)

      conn = get conn, "/api/v1/teams/#{team.id}"

      assert json_response(conn, 200)
    end
  end
end
