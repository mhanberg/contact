defmodule ContactWeb.Api.V1.User.Team.RoomController do
  import Ecto.Query, warn: false
  use ContactWeb, :controller

  action_fallback(ContactWeb.Api.V1.FallbackController)

  def index(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    with rooms <- Contact.Rooms.get_rooms_for_user_and_team(user_id, team_id) do
      render(conn, "index.json-api", rooms: rooms)
    end
  end
end
