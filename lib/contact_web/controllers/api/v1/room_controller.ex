defmodule ContactWeb.Api.V1.RoomController do
  use ContactWeb, :controller

  action_fallback(ContactWeb.Api.V1.FallbackController)

  alias Contact.{Rooms, Rooms.Room}

  def show(conn, %{"id" => id}) do
    with %Room{} = room <- Rooms.get_room!(id) do
      render(conn, "show.json-api", room: room)
    end
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)

    with {:ok, %Room{} = room} <- Rooms.create_room(attrs) do
      conn
      |> put_status(201)
      |> render("show.json-api", room: room)
    end
  end

  def update(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    id = data["id"]

    with {:ok, %Room{} = room} <- Rooms.update_room(id, attrs) do
      render(conn, "show.json-api", room: room)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Room{}} <- Rooms.delete_room(id) do
      conn
      |> put_status(204)
      |> render("delete.json-api")
    end
  end
end
