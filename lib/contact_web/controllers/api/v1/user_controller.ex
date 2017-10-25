defmodule ContactWeb.Api.V1.UserController do
  use ContactWeb, :controller

  action_fallback ContactWeb.Api.V1.FallbackController

  alias Contact.{Accounts, Accounts.User}

  def create(conn, %{"data" => %{ "attributes" => attrs }}) do
    with {:ok, %User{} = user} <- Accounts.create_user(attrs) do
      render conn, "create.json", user: user
    end
  end

  def create(conn, %{}) do
    conn
    |> put_status(400)
    |> render(ContactWeb.ErrorView, "400.json")
  end
end
