defmodule ContactWeb.Api.V1.UserControllerTest do
  use ContactWeb.ConnCase
  import Contact.Factory
  alias ContactWeb.Api.V1.UserSerializer

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

  describe "unauthenticated" do
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
      insert(:user, email: @valid_body.data.attributes.email)

      conn = post conn, "/api/v1/users", put_in(@valid_body.data.attributes.username, "something different")

      assert json_response(conn, 409) == %{"errors" => %{"email" => ["has already been taken"]}}
    end

    test "create renders 409 when username is already taken", %{conn: conn} do
      insert(:user, username: @valid_body.data.attributes.username)

      conn = post conn, "/api/v1/users", put_in(@valid_body.data.attributes.email, "different@yep.com")

      assert json_response(conn, 409) == %{"errors" => %{"username" => ["has already been taken"]}}
    end

    test "sign_in happy path with email", %{conn: conn} do
      insert(:user, email: "legoman25@aol.com")

      body = %{
        data: %{
          type: "token",
          attributes: %{
            email: "legoman25@aol.com",
            password: "password"
          }
        }
      }

      conn = post conn, "/api/v1/users/sign_in", body

      assert json_response(conn, 200)
    end

    test "sign_in happy path with username", %{conn: conn} do
      insert(:user, username: "legoman25")

      body = %{
        data: %{
          type: "token",
          attributes: %{
            email: "legoman25",
            password: "password"
          }
        }
      }

      conn = post conn, "/api/v1/users/sign_in", body

      assert json_response(conn, 200)
    end

    test "sign_in sad path user doesnt exist", %{conn: conn} do
      body = %{
        data: %{
          type: "token",
          attributes: %{
            email: "doesntexist",
            password: "doesntmatter"
          }
        }
      }

      conn = post conn, "/api/v1/users/sign_in", body

      assert json_response(conn, 401)
    end

    test "sign_in sad path user exists but password doesn't match", %{conn: conn} do
      insert(:user, username: "legoman25")

      body = %{
        data: %{
          type: "token",
          attributes: %{
            username: "legoman25",
            password: "doesntmatch"
          }
        }
      }

      conn = post conn, "/api/v1/users/sign_in", body

      assert json_response(conn, 401)
    end
  end

  describe "authenticated" do
    setup %{conn: conn} do
      user = insert(:user, email: "legoman25@aol.com", username: "legoman25")
      {:ok, token, _claims} = ContactWeb.Guardian.encode_and_sign(user)
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "update happy path", %{conn: conn, user: user} do
      conn = patch conn, "/api/v1/users/#{user.id}", %{ "data" => %{ "id" => user.id, "attributes" => %{ first_name: "billy" }}}

      assert response = json_response(conn, 200)

      expected = %{
        "data" => %{
          "attributes" => %{
            "email" => user.email,
            "username" => user.username,
            "first-name" => "billy",
            "last-name" => user.last_name
          },
          "type" => "user",
          "id" => "#{user.id}",
          "links" => %{"self" => "/api/v1/users/#{user.id}"}
        },
        "jsonapi" => %{"version" => "1.0"}
      }

      assert expected == response
    end

    test "update returns 409 when email is changed but already taken", %{conn: conn, user: user} do
      insert(:user, email: "imtaken@foo.bar")

      conn = patch conn, "/api/v1/users/#{user.id}", %{ "data" => %{ "id" => user.id, "attributes" => %{"email" => "imtaken@foo.bar"}}}

      assert json_response(conn, 409) == %{"errors" => %{"email" => ["has already been taken"]}}
    end

    test "update returns 409 when username is changed but already taken", %{conn: conn, user: user} do
      insert(:user, username: "imtaken")

      conn = patch conn, "/api/v1/users/#{user.id}", %{ "data" => %{ "id" => user.id, "attributes" => %{ "username" => "imtaken"}}}

      assert json_response(conn, 409) == %{"errors" => %{"username" => ["has already been taken"]}}
    end

    test "show happy path", %{conn: conn, user: user} do
      conn = get conn, "/api/v1/users/#{user.id}"

      expected = UserSerializer |> JaSerializer.format(user)
      assert json_response(conn, 200) == expected
    end

    test "show sad path", %{conn: conn} do
      conn = get conn, "/api/v1/users/23423515125312"

      assert json_response(conn, 404)
    end

    test "delete happy path", %{conn: conn, user: user} do
      conn = delete conn, "/api/v1/users/#{user.id}"

      assert json_response(conn, 204)
    end

    test "delete sad path", %{conn: conn} do
      conn = delete conn, "/api/v1/users/2342342423432"

      assert json_response(conn, 404)
    end
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
