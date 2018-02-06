defmodule ContactWeb.Api.V1.User.Team.RoomView do
  use ContactWeb, :view
  alias ContactWeb.Api.V1.RoomSerializer

  def render("index.json-api", %{rooms: rooms}) do
    RoomSerializer
    |> JaSerializer.format(rooms)
  end
end
