defmodule ContactWeb.Api.V1.UserControllerTest do
  use ContactWeb.ConnCase

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

  test "create happy path" do
    conn = build_conn()

    conn = post conn, "/api/v1/users", @valid_body

    assert_success_result(json_response(conn, 200))
  end

  test "create renders 409 and error messages on invalid body" do
    conn = build_conn()

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

  test "create renders 409 and password mismatch error" do
    conn = build_conn()

    conn = post conn, "api/v1/users", put_in(@valid_body.data.attributes.password_confirmation, "wrongpass")

    assert json_response(conn, 409) == %{"errors" => %{"password_confirmation" => ["does not match confirmation"]}}
  end

  test "create renders 409 when email is already taken" do
    conn = build_conn()
    conn = post conn, "/api/v1/users", @valid_body

    assert_success_result(json_response(conn, 200))

    conn = post conn, "/api/v1/users", put_in(@valid_body.data.attributes.username, "something different")

    assert json_response(conn, 409) == %{"errors" => %{"email" => ["has already been taken"]}}
  end

  test "create renders 409 when username is already taken" do
    conn = build_conn()
    conn = post conn, "/api/v1/users", @valid_body

    assert_success_result(json_response(conn, 200))

    conn = post conn, "/api/v1/users", put_in(@valid_body.data.attributes.email, "different@yep.com")

    assert json_response(conn, 409) == %{"errors" => %{"username" => ["has already been taken"]}}
  end

  defp assert_success_result(response) do
    assert %{
      "data" => %{
        "type" => "users",
        "id" => _,
        "attributes" => %{
          "email" => "legoman25@aol.com",
          "username" => "legoman25",
          "first_name" => "Mitch",
          "last_name" => "Hanberg"
        }
      }
    } = response
  end
end
