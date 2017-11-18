defmodule ContactWeb.Api.V1.FallbackController do
  use ContactWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(401)
    |> render(ContactWeb.ErrorView, "401.json")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> render(ContactWeb.ErrorView, "404.json")
  end

  def call(conn, {:error, changeset}) do
    conn
    |> put_status(409)
    |> render(ContactWeb.ErrorView, "409.json", changeset: changeset)
  end

  def call(conn, _) do
    conn
    |> put_status(500)
    |> render(ContactWeb.ErrorView, "500.json")
  end
end
