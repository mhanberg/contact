defmodule ContactWeb.Api.V1.UserController do
  use ContactWeb, :controller

  alias Contact.{Accounts, Accounts.User}

  def create(conn, %{"data" => %{ "attributes" => attrs }}) do
    case Accounts.create_user(attrs) do
      {:ok, %User{} = user} ->
        render conn, "create.json", user: user
      {:error, changeset} ->
        conn
        |> put_status(409)
        |> render(ContactWeb.ErrorView, "409.json", changeset: changeset)
    end
  end

  def create(conn, %{}) do
    conn
    |> put_status(400)
    |> render(ContactWeb.ErrorView, "400.json")
  end
end
