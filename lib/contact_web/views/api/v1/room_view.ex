defmodule ContactWeb.Api.V1.RoomView do
  use ContactWeb, :view
  alias ContactWeb.Api.V1.RoomSerializer

  def render("show.json-api", %{room: room}) do
    RoomSerializer
    |> JaSerializer.format(room)
  end

  def render("delete.json-api", _assigns) do
    ""
  end
end
