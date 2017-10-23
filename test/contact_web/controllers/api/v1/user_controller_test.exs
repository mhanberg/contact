defmodule ContactWeb.Api.V1.UserControllerTest do
  use ContactWeb.ConnCase

  @valid_body %{
    email: "legoman25@aol.com",
    username: "legoman25",
    first_name: "Mitch",
    last_name: "Hanberg",
    password: "password",
    password_confirmation: "password"
  }

  @expected @valid_body |> Map.delete(:password) |> Map.delete(:password_confirmation)

  test "create happy path" do
    conn = build_conn()

    conn = post conn, "/api/v1/users", @valid_body

    assert json_response(conn, 200) == render_json("create.json", user: @expected)
  end

  test "create renders 409 and error messages on invalid body" do
    conn = build_conn()

    conn = post conn, "api/v1/users", %{}
    expected = %{"errors" =>
      %{"email" => ["can't be blank"],
        "first_name" => ["can't be blank"], "last_name" => ["can't be blank"],
        "password" => ["can't be blank"],
        "password_confirmation" => ["can't be blank", "can't be blank"],
        "username" => ["can't be blank"]},
        "status" => "failure"
    }

    assert json_response(conn, 409) == expected
  end

  test "create renders 409 and password mismatch error" do
    conn = build_conn()

    conn = post conn, "api/v1/users", Map.put(@valid_body, :password_confirmation, "wrongpass")

    assert json_response(conn, 409) == %{"status" => "failure", "errors" => %{"password_confirmation" => ["does not match confirmation"]}}
  end

  test "create renders 409 when email is already taken" do
    conn = build_conn()
    conn = post conn, "/api/v1/users", @valid_body

    assert json_response(conn, 200) == render_json("create.json", user: @expected)

    conn = post conn, "/api/v1/users", %{ @valid_body | username: "something different" }

    assert json_response(conn, 409) == %{"status" => "failure", "errors" => %{"email" => ["has already been taken"]}}
  end

  test "create renders 409 when username is already taken" do
    conn = build_conn()
    conn = post conn, "/api/v1/users", @valid_body

    assert json_response(conn, 200) == render_json("create.json", user: @expected)

    conn = post conn, "/api/v1/users", %{ @valid_body | email: "different@yep.com" }

    assert json_response(conn, 409) == %{"status" => "failure", "errors" => %{"username" => ["has already been taken"]}}
  end

  defp render_json(template, assigns) do
    assigns = Map.new(assigns)

    ContactWeb.Api.V1.UserView.render(template, assigns)
    |> Poison.encode!
    |> Poison.decode!
  end
end
