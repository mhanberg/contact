defmodule ContactWeb.Api.V1.FallbackController do
  use ContactWeb, :controller

  def call(conn, {:error, changeset}) do
    conn
    |> put_status(409)
    |> render(ContactWeb.ErrorView, "409.json", changeset: changeset)
  end

  def call(conn, nil) do
    conn
    |> put_status(404)
    |> render(ContactWeb.ErrorView, "404.json")
  end
end
