defmodule ContactWeb.Api.V1.UserController do
  use ContactWeb, :controller

  action_fallback ContactWeb.Api.V1.FallbackController

  alias Contact.{Accounts, Accounts.User}

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    with {:ok, %User{} = user} <- Accounts.create_user(attrs) do
      render conn, "show.json-api", user: user
    end
  end

  def create(conn, %{}) do
    conn
    |> put_status(400)
    |> render(ContactWeb.ErrorView, "400.json")
  end

  def update(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    id = data["id"]

    with {:ok, %User{} = user} <- Accounts.update_user(id, attrs) do
      render conn, "show.json-api", user: user
    end
  end

  def show(conn, %{"id" => id}) do
    with %User{} = user <- Accounts.get_user(id) do
      render conn, "show.json-api", user: user
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{}} <- Accounts.delete_user(id) do
      conn
      |> put_status(204)
      |> render("delete.json-api")
    end
  end
end
