defmodule ContactWeb.Api.V1.UserControllerTest do
  use ContactWeb.ConnCase
  import Contact.Factory

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  @valid_body %{
    data: %{
      type: "users",
      attributes: %{
        email: "legoman25@aol.com",
        username: "legoman25",
        first_name: "Mitch",
        last_name: "Hanberg",
        password: "password",
        password_confirmation: "password"
      }
    }
  }

  test "create happy path", %{conn: conn} do
    conn = post conn, "/api/v1/users", @valid_body

    assert_success_result(json_response(conn, 200))
  end

  test "create renders 409 and error messages on invalid body", %{conn: conn} do
    conn = post conn, "api/v1/users", %{}
    expected = %{
      "errors" => [
        %{
          "status" => 400,
          "detail" => "Bad Request"
        }
      ]
    }

    assert json_response(conn, 400) == expected
  end

  test "create renders 409 and password mismatch error", %{conn: conn} do
    conn = post conn, "api/v1/users", put_in(@valid_body.data.attributes.password_confirmation, "wrongpass")

    assert json_response(conn, 409) == %{"errors" => %{"password_confirmation" => ["does not match confirmation"]}}
  end

  test "create renders 409 when email is already taken", %{conn: conn} do
    insert(:user)

    conn = post conn, "/api/v1/users", put_in(@valid_body.data.attributes.username, "something different")

    assert json_response(conn, 409) == %{"errors" => %{"email" => ["has already been taken"]}}
  end

  test "create renders 409 when username is already taken", %{conn: conn} do
    insert(:user)

    conn = post conn, "/api/v1/users", put_in(@valid_body.data.attributes.email, "different@yep.com")

    assert json_response(conn, 409) == %{"errors" => %{"username" => ["has already been taken"]}}
  end

  defp assert_success_result(response) do
    assert %{
      "data" => %{
        "attributes" => %{
          "email" => "legoman25@aol.com",
          "username" => "legoman25",
          "first-name" => "Mitch",
          "last-name" => "Hanberg"
        },
        "type" => "user",
        "id" => _
      },
      "jsonapi" => %{"version" => "1.0"}
    } = response
  end
end
