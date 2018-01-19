defmodule ContactWeb.Api.V1.Team.UserController do
  use ContactWeb, :controller

  action_fallback(ContactWeb.Api.V1.FallbackController)

  alias Contact.Teams

  def create(conn, %{"team_id" => team_id, "data" => data}) do
    %{"id" => user_id} = JaSerializer.Params.to_attributes(data)

    with {:ok, _t} <- Teams.add_member(team_id, user_id) do
      conn
      |> put_status(201)
      |> render("default.json-api")
    end
  end

  def delete(conn, %{"team_id" => team_id, "id" => user_id}) do
    with {:ok, %Member{}} <- Teams.delete_member(team_id, user_id) do
      conn
      |> put_status(202)
      |> render("default.json-api")
    end
  end
end
