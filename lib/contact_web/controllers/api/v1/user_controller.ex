defmodule ContactWeb.Api.V1.UserController do
  use ContactWeb, :controller

  alias Contact.{Accounts, Accounts.User}

  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, %User{} = user} ->
        render conn, "create.json", user: user
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render(ContactWeb.ErrorView, "400.json", changeset: changeset)
    end
  end
end
