defmodule ContactWeb.Api.V1.TeamController do
  use ContactWeb, :controller

  action_fallback(ContactWeb.Api.V1.FallbackController)

  alias Contact.{Accounts, Accounts.Team}

  def show(conn, %{"id" => id}) do
    with %Team{} = team <- Accounts.get_team(id) do
      render(conn, "show.json-api", team: team)
    end
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)

    with {:ok, %Team{} = team} <- Accounts.create_team(attrs) do
      conn
      |> put_status(201)
      |> render("show.json-api", team: team)
    end
  end

  def update(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    id = data["id"]

    with {:ok, %Team{} = team} <- Accounts.update_team(id, attrs) do
      render(conn, "show.json-api", team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Team{}} <- Accounts.delete_team(id) do
      conn
      |> put_status(204)
      |> render("delete.json-api")
    end
  end
end
